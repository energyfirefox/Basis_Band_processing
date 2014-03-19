
metrics <- read.csv("metrics.csv")
activities <- read.csv("bodystates.csv")
train_set <- metrics[ ,c("steps", "skin_temp", "heart_rate", "gsr")]

table(activities$bodystate)
train_set <- train_set[complete.cases(train_set), ]
fit <- kmeans(train_set, 4)
aggregate(train_set,by=list(fit$cluster),FUN=mean)
train_set <- data.frame(train_set, fit$cluster)
plot(train_set$skin_temp, train_set$steps, col = train_set$fit.cluster, pch = 19)
plot(train_set$heart_rate, train_set$steps, col = train_set$fit.cluster, pch = 19, xlab = "Heart rate", ylab = "Steps")

