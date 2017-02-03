rm(list=ls())
library(dplyr)
library(tidyr)


setwd("~/RStats")
df <- read.csv('data/Churn.csv', stringsAsFactors = F)
names(df)

contract <- df %>%
  select(Account.Length, VMail.Message, Day.Mins, Eve.Mins,
         Night.Mins, Intl.Mins, CustServ.Calls, Churn, Int.l.Plan, VMail.Plan,
         Area.Code, Phone)

usage <- df%>%
  select(Area.Code, Phone, Day.Calls, Day.Charge,Eve.Calls, Eve.Charge,
         Night.Calls, Night.Charge, Intl.Calls, Intl.Charge, State)

write.csv(usage, "Phone_Usage.csv", row.names = F)
write.csv(contract, "Contracts.csv", row.names = F)

df2 <- inner_join(usage, contract)

#quick check
table(df$Churn)

#split the dataset into Train and Test
split = as.integer(nrow(df)*0.8)
train = df[1:split,]
test = df[(split+1):nrow(df), ]

## here's an arguably better way to split
set.seed(4444)
train_rows = sample(1:nrow(df), 0.8*nrow(df))
str(train_rows)

train = df[train_rows, ]
test <- df[-train_rows,]

table(train$Churn)
table(test$Churn)

# Random Forest prediction of Churn data
names(df)
library(randomForest)
fit <- randomForest(Churn ~ CustServ.Calls + Day.Charge + Eve.Charge 
                    + Night.Charge + Intl.Charge,   data=df)
print(fit) # view results 
importance(fit) # importance of each predictor
text(fit, pretty=0)
#----------------------------------------

library(rpart)
# grow tree 
tree <- rpart(Churn ~ CustServ.Calls + Day.Charge + Eve.Charge 
             + Night.Charge + Intl.Charge,   
             method="class", data=train)

formula2 <- Churn ~ CustServ.Calls + Intl.Charge

fit2 <- rpart(formula2,
              method="class", data=train)


printcp(fit2)
plotcp(fit)
summary(fit2)


# plot tree 
plot(tree, uniform=TRUE, 
  	main="Classification Tree for Churn")
text(tree, use.n=TRUE, all=TRUE, cex=.8)

# create attractive postscript plot of tree 
post(fit, file = "churn_tree.ps", 
  	title = "Classification Tree for Churn Data")


#Try some predictions
variablesToUse <- c("CustServ.Calls", "Day.Charge", "Eve.Charge",
                    "Night.Charge", "Intl.Charge")

treePredictions <- predict(tree, newdata=test, 
                           type='class')

table(treePredictions, test$Churn)


#predictions using formula 2
pred_fit2 <- predict(fit2, newdata=test, type='class')
table(pred_fit2, test$Churn)

