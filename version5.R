# Import the required libraries
library(dplyr)
library(caret)
library(ISLR)

# Get the training and testing datasets from online and save to variables
training <- read.csv("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv")
testing <- read.csv("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv")

# Remove near-zero variance predictors
nzv <- nearZeroVar(training)
training <- training[, -nzv]

# Select relevant columns
training <- training[, 8:ncol(training)]
testing <- testing[, 8:ncol(testing)]

# Remove the problem_id column from testing
testing <- testing %>% select(-problem_id)

# Remove columns with all NA values
training <- training %>% select(where(~ !all(is.na(.))))
testing <- testing %>% select(where(~ !all(is.na(.))))

# Convert columns to numeric, except the last column in training which is 'classe'
training <- training %>%
        mutate(across(
                -ncol(training),
                as.numeric
        ))

# Ensure 'classe' is a factor in training
training$classe <- factor(training$classe)

# Identify common columns between training and testing datasets
common_cols <- intersect(names(training), names(testing))

# Select common columns from both datasets
training <- training[, c(common_cols, "classe")]
testing <- testing[, common_cols]

# Set seed for reproducibility
set.seed(42069)

# Train the model
modelFit <- train(classe ~ ., data = training, method = "treebag", preProcess = c("pca"), na.action = na.pass)

# Summary of the final model
summary(modelFit$finalModel)

# Predict on the testing dataset
pred <- predict(modelFit, newdata = testing)
print(pred)
# Check the structure and first few predictions
str(pred)
head(pred)
