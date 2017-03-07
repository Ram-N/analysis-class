#'
#' Tree Based Predictions of ESP failures
#' 
#' Ram Narasimhan, 2017

#Step 0. Read the file
esp3 <- read.csv("Wells_ESP3.csv", stringsAsFactors = F)


#Step 1: Split the dataset into test and train
rows_to_train <- 800
train_rows = sample(nrow(esp3), rows_to_train)
train_rows
train = df2[train_rows , ]
test = df2[-train_rows , ]

dim(test); dim(train)
table(train$Condition)
table(test$Condition)

#########################
#########################

#Step 2: Use Rpart to build and visualize tree to model Condition of ESP's
formula1 <- Condition ~ Motor_Oil_Temperature + Intake_Temperature_F + Motor_Vibration + 
  PressureROC + Intake_Pressure_Mpa + TDH
rpart_tree <- rpart(formula1 , method="class", data=train)

#Step 2.1 look at an ascii way of describing the tree
rpart_tree

plot(rpart_tree)
text(rpart_tree, pretty=0) #doesn't look good

rpart.plot(rpart_tree)
rpart.plot(rpart_tree, type = 4, extra=101)
rpart.plot(rpart_tree, type = 4, extra=102)


#Step 2.2 PREDICTIONS USING RPART
# How good is the rpart Model?
predict(rpart_tree, data=test)
rpart_based_pred <- predict(rpart_tree, newdata=test, type='class')
table(rpart_based_pred, test$Condition)

## Step 3: Build a Evolution Tress
evol_tree <- evtree(Condition ~ Intake_Temperature_F, method="class", data=train)
evol_tree #look at an ascii way of describing the tree
plot(evol_tree) #3.1

#Step 3.2: Is EVOL PRED a good predictor?
evol_pred <- predict(evol_tree, test)
table(evol_pred, test$Condition)

## Step 4
## Let's build in a random forest classifier
rf <- randomForest(formula1, data = train)
rf #pretty informative

#Step 4.1 Predictions using RF
rf_preds <- predict(rf, test)
table(rf_preds, test$Condition)


# Step 5: Calcuate the Accuracy of each of the 3 Decision Trees
mean(rf_preds == test$Condition)
mean(rpart_based_pred==test$Condition)
mean(evol_pred == test$Condition)


####


