# import the required libraries
library(dplyr)
library(caret)


# Get the training and testing datasets from online and save to variables
training <- as_tibble(read.csv("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"))
testing <- as_tibble(read.csv("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"))
head(training)

training <- training[, 8:ncol(training)]
testing <- testing[, 8:ncol(testing)]

set.seed(42069)
preProcessValues <- preProcess(training, method = "medianImpute")
training_imputed <- predict(preProcessValues, training)
modelFit <- train(factor(classe) ~ ., data = training_imputed, model = "rpart", preProcess = "medianImpute")
print(modelFit)
