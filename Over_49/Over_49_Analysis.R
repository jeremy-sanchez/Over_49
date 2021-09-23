#Let's first load in the covariate data, Scores, (and the data frames used to create it)

load("Over_49_Analysis.Rdata")
######################################### Modeling  ############################################
#Goal: Predict whether a given NFL game will see over or under 49 points scored. 

#Libraries we will be using (code to install them if need to be below)


#install.packages("rpart.plot")
#install.packages("rpart")
#install.packages("randomForest")
#install.packages("e1071")


library(rpart.plot) #Single Trees
library(rpart)

library(randomForest) #Random Forest, Bagging

library(e1071) #Support Vector Machines

## Week 12 numbers
Train_Rows <- 1:161
Test_Rows <- 162:177

## Week 13 Numbers
Train_Rows <- 1:177
Test_Rows <- 178:191

#I have all the data here for week 13, but don't include Dallas at
  #Baltimore (row 192)


##################  Preliminaries

#Preparing our training data

#Assigning over or under to the training data
Over49 <- ifelse(Scores$Total[Train_Rows] >= 49, 1, 0)
Over49_Train <- Over49[Train_Rows]

Train <- cbind(Over49_Train, Scores[Train_Rows,][,7:18])

#Preparing our test data
Test <- Scores[Test_Rows,][,6:18]
Test_Predictors <- Test[,c(2:13)] 

Actual <- ifelse(Scores$Total[Test_Rows] >= 49, 1, 0) 


################  Naive Model: We always predict 1 (over)

number_of_games <- length(Actual) #this gives us the number of games each week
Naive_Model <- rep(1, times = number_of_games)

#Since the naive model requires no 'analysis', we can find the MCR now

Naive_MCR <- mean((Actual - Naive_Model)^2)

###############   Model 1: Principle Components Logistic Regression            

#We want our principle components explain 95 percent of the variance.
  #We can decide how many components to use by viewing the summary below.

Predictors <- Train[,c(2:13)]
PCA <- prcomp(Predictors, center = TRUE, scale = TRUE)
summary(PCA)

#In this case, we have 8 variables needed. Let's store these and regress on them

chosen <- as.data.frame(PCA$x[,1:8])
chosen$Total <- as.factor(as.numeric(as.factor(Over49_Train)) -1)

Logistic <- glm(Total ~., data = chosen, family = "binomial")

summary(Logistic)

#For the testing data, we need to hand-calculate the principle components 

#Transformations for the analysis
PCA_Test_Predictors <- CENTER(Test_Predictors,as.numeric(PCA$center))
PCA_Test_Predictors <- SCALE(Test_Predictors,as.numeric(PCA$scale))

##project and get the principle component scores 

PC1 <- PCA$rotation[,1]
PC2 <- PCA$rotation[,2]
PC3 <- PCA$rotation[,3]
PC4 <- PCA$rotation[,4]
PC5 <- PCA$rotation[,5]
PC6 <- PCA$rotation[,6]
PC7 <- PCA$rotation[,7]
PC8 <- PCA$rotation[,8]

Test_PC_1 <- as.matrix(PCA_Test_Predictors) %*% PC1
Test_PC_2 <- as.matrix(PCA_Test_Predictors) %*% PC2
Test_PC_3 <- as.matrix(PCA_Test_Predictors) %*% PC3
Test_PC_4 <- as.matrix(PCA_Test_Predictors) %*% PC4
Test_PC_5 <- as.matrix(PCA_Test_Predictors) %*% PC5
Test_PC_6 <- as.matrix(PCA_Test_Predictors) %*% PC6
Test_PC_7 <- as.matrix(PCA_Test_Predictors) %*% PC7
Test_PC_8 <- as.matrix(PCA_Test_Predictors) %*% PC8

#Combining our principle components into a data frame

Test_PCs <- as.data.frame(cbind(Test_PC_1, Test_PC_2, Test_PC_3, Test_PC_4, Test_PC_5, 
                  Test_PC_6, Test_PC_7, Test_PC_8))
colnames(Test_PCs) <- c("PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7","PC8")

#Now we can perform a test, and make some predictions.

#rounding is making sure the response is 0 or 1
PCR_Predictions <- round(predict(Logistic, Test_PCs, type = "response"))
PCR_MCR <- mean((Actual-PCR_Predictions)^2)


########################### Model 2: One Classification Tree               
Tree <- rpart(Over49_Train~., data = Train, method = "class")

Tree_CV <- Tree$cptable

#We will choose the cp with the lowest validation error rate.
cp_xerror_min <- unname(Tree$cptable[, "CP"][unname(which.min(Tree$cptable[, "xerror"]))])

cp_xerror_min
#Now we'll prune the tree and make predictions using it.
Tree_Pruned <- prune.rpart(Tree, cp = cp_xerror_min)

Tree_Plot <- rpart.plot(Tree_Pruned)

#Our predictors are again the covariates and not transformed PCs.
Test_Predictors <- Test[,c(2:13)]

#Predictions should be 0 or 1
Tree_Predictions <- round(rpart.predict(Tree_Pruned, newdata = Test_Predictors, type = c("prob")))

MCR_Tree  <- mean((Actual-Tree_Predictions)^2)


###########################  Model 3: Bagging
num_covariates <- ncol(Test_Predictors)

Bagging <- randomForest(as.factor(Over49_Train) ~ ., data=Train, 
                        mtry=num_covariates)

#Predictions should be 0 or 1
Bagging_Predictions <- as.numeric(predict(Bagging, Test_Predictors)) - 1

#This tells us the number of trees made ??
Bagging$ntree

MCR_Bagging <- mean((Actual-Bagging_Predictions)^2)

############################    Model 4: Random Forest

#To choose the number of splits, we are going to do a cross validation using 
  #on the number of co-variates to include throughout (1 through 11, since at
  #12 we are just doing bagging again.)

RF_Validation_Error_Rate_Vector <- vector()

##split for validation 
set.seed(567)
train_index <- sample(nrow(Train), nrow(Train)*.7, replace = FALSE)

Train_RF <- Train[train_index,]
Validation_RF <- Train[-train_index,]

Actual_Valid_RF <- Validation_RF$Over49_Train
Validation_Predictors <- Validation_RF[,2:13]

##run the validation 
for(ii in 1:11)
{
  Random_Forest <- randomForest(as.factor(Over49_Train) ~ ., data=Train_RF, mtry=ii)
  Valid_Predictions <- as.numeric(predict(Random_Forest, Validation_Predictors)) - 1
  RF_Validation_Error_Rate_Vector[ii] <- mean((Actual_Valid_RF - Valid_Predictions)^2)
}

RF_Validation_Error_Rate_Vector

#Choose number of ??? here based on training data. 
  #I decided to use: Week 12: 3, Week 13: 4
 # week_12_mtry <- 3
  week_13_mtry <- 4


#Looks like 3 splits is optimal, but we will choose 4 for a tad more flexibility

Random_Forest <- randomForest(as.factor(Over49_Train) ~ ., data=Train, 
                              mtry=week_13_mtry)

RF_Predictions <- as.numeric(predict(Random_Forest, Test_Predictors)) - 1

MCR_RF <- mean((Actual-RF_Predictions)^2)

## Variable importance plot
varImpPlot(Random_Forest, main="Variable Importance", pch=15)
############################   Model 5: Support vector machines

#Cost Parameter vector for the tune() function.
cost_vec <- c(0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 2,3,5,8,13,21,34,
              55, 89, 100)

####### radial kernel 

#Gamma's are chosen similarly to the cost paramater.
SVM_Tuning_Radial <- tune(svm,as.factor(Over49_Train)~., data = Train,
                          kernel = "radial",ranges=list(cost=cost_vec,
                    gamma = c(0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 2,3,5,8,13,21)))

SVM_Radial_Fit <- SVM_Tuning_Radial$best.model
SVM_Radial_Fit$gamma
SVM_Radial_Fit$cost

1e-04*10000

#Now let's make predictions for the radial kernel.
Radial_Predictions <- as.numeric(predict(SVM_Radial_Fit, Test_Predictors))-1

Radial_MCR <- mean((Actual-Radial_Predictions)^2)


#################### linear kernel
SVM_Tuning_Linear <- tune(svm, as.factor(Over49_Train)~., data = Train,
                          kernel = "linear",ranges=list(cost=cost_vec))

#best: cost = .01
SVM_Linear_Fit <- SVM_Tuning_Linear$best.model
SVM_Linear_Fit$cost

#Here are predictions for the linear kernel.
Linear_Predictions <- as.numeric(predict(SVM_Linear_Fit, Test_Predictors))-1
Linear_MCR <- mean((Actual-Linear_Predictions)^2)

