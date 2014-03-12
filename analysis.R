library(rpart.plot)
library(rattle)
library(RColorBrewer)
classify_dataset <- read.csv("classify_dataset.csv")
sum(is.na(classify_dataset))

summary(classify_dataset)

# remove na data:

dataset <- classify_dataset[complete.cases(classify_dataset), ]

## classification tree
library(rpart)
fittree <- rpart(activity ~ heart_rate + steps + skin_temp + gsr, data = dataset, method = "class")
prp(fittree)

train_set <- dataset[ ,c("heart_rate", "steps", "skin_temp", "gsr")]
prediction <- predict(fittree, train_set, type = "class")
table(prediction, dataset$activity)


# logistic regression

dataset$sleep <- 0
dataset$inactive <- 0
dataset$light_activity <- 0
dataset$moderate_activity <- 0

dataset$activity <- as.character(dataset$activity)

for (i in 1:nrow(dataset)){
  cur_str <- dataset$activity[i]
  if (cur_str == "sleep"){
    dataset$sleep[i] <- 1
  }
  if (cur_str == "inactive"){
    dataset$inactive[i] <- 1
  }
  if (cur_str == "light_activity"){
    dataset$light_activity[i] <- 1
  }
  if (cur_str == "moderate_activity"){
    dataset$moderate_activity[i] <- 1
  }
}



fitregression <- glm(activity ~ heart_rate + steps + skin_temp + gsr, data = dataset, family = "binomial")
summary(fitregression)

regr_prediction <- predict(fitregression, train_set, type = "terms")

