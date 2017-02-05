#' Understanding Decision Trees
#' Random forests
#' And comparing both
#' 
#' Ram Narasimhan, 2017

rm(list=ls())
library(rpart)
library(rpart.plot)
library(caret)
library(tree)
library(evtree)
library(randomForest)


#IRIS dataset

rows_to_train <- 50
train_rows = sample(1:150, rows_to_train)
train_rows
train = iris[train_rows , ]
test = iris[-train_rows , ]

#Use Rpart to build and visualize tree

dtree <- rpart(Species ~ ., method="class", data=train)

#look at an ascii way of describing the tree
dtree

plot(dtree)
text(dtree, pretty=0) #doesn't look good

rpart.plot(dtree)
rpart.plot(dtree, type = 4, extra=101)
rpart.plot(dtree, type = 4, extra=102)


#Interesting plots to understand the underlying data

featurePlot(x=iris[,1:4], y=iris[,5], 
            plot="density", 
            scales=list(x=list(relation="free"), 
                        y=list(relation="free")),
            auto.key=list(columns=3))


featurePlot(x=iris[,1:4], y=iris[,5], 
            plot="box", 
            scales=list(x=list(relation="free"), 
                        y=list(relation="free")),
            auto.key=list(columns=3))
#Note that setosa is relatively 'easier' to predict


#EV TREE has some decent viz
evol_tree <- evtree(Species ~ ., method="class", data=train)
evol_tree#look at an ascii way of describing the tree
plot(evol_tree)


#How good are the models?
predict(dtree, data=test)
tree_pred <- predict(dtree, test, type='class')
tree_pred
table(tree_pred, test[, 5])

#Is EVOL PRED a good predictor?
evol_pred <- predict(evol_tree, test)
table(evol_pred, test[, 5])



## Let's bring in a random forest classifier
rf <- randomForest(Species ~ ., data = train)
rf #pretty informative
plot(rf)

rf_preds <- predict(rf, test)
table(rf_preds, test$Species)
mean(rf_preds == test$Species)
mean(tree_pred==test$Species)
mean(evol_pred == test$Species)

###########################################################