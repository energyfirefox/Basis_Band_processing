
metrics <- read.csv("metrics.csv")
activities <- read.csv("bodystates.csv")

metrics$time <- as.POSIXct(strptime(metrics$time, format = "%A %b %d %H:%M:%S %Y", tz = "EEST"))
train_set <- metrics[ ,c("time", "steps", "skin_temp", "heart_rate", "gsr")]
f_to_celsius <- function(temp_Far){
  temp_C <- (temp_Far - 32)*5/9
  return(temp_C)
}

train_set$skin_temp <- f_to_celsius(train_set$skin_temp)

table(activities$bodystate)
train_set <- train_set[complete.cases(train_set), ]
train_set_vars <- train_set[ ,c("steps", "skin_temp", "heart_rate", "gsr")]
fit <- kmeans(train_set_vars, 4, iter.max= 100, nstart =10)
aggregate(train_set_vars,by=list(fit$cluster),FUN=mean)
train_set <- data.frame(train_set, fit$cluster)
plot(train_set$skin_temp, train_set$steps, col = train_set$fit.cluster, pch = 19)
plot(train_set$heart_rate, train_set$steps, col = (train_set$fit.cluster + 1), pch = 19, xlab = "Heart rate", ylab = "Steps")


# make classify dataset for one day
cl_train_set <- metrics[as.Date(metrics$time) == "2014-03-04", ]
cl_train_set$skin_temp <- f_to_celsius(cl_train_set$skin_temp)
 
activities$time1 <- strptime(as.character(activities$time1), format = "%A %b %d %H:%M:%S %Y", tz = "EEST")
activities$time2 <- strptime(as.character(activities$time2), format = "%A %b %d %H:%M:%S %Y", tz = "EEST")

activities2 <- activities[as.Date(activities$time1) == "2014-03-04", ]
# sort by time1 ascending order:
activities2 <- activities2[with(activities2, order(time1)), ]

time_vector <- vector()
activity_vector <- vector()

for (i in 1:nrow(activities2)){
  interval <- as.integer(difftime(activities2$time2[i], activities2$time1[i], units = "mins"))
  for (j in (1:interval-1)){
    time_vector <- c(time_vector, activities2$time1[i] + 60*j)
    activity_vector <- c(activity_vector, as.character(activities2$bodystate[i]))
  }
}

time_vector <- as.POSIXct(time_vector, origin = '1970-01-01')

cl_activities <- data.frame(time = time_vector, activity = activity_vector)
cl_activities$time <- as.character(cl_activities$time -3600*2)
cl_train_set$time <- as.character(cl_train_set$time)
head(cl_train_set$time)
head(cl_activities$time)

classify_dataset <- merge(cl_train_set, cl_activities, by = "time", all = TRUE)

# select only data for Mar, 04 for checking from train set:
train_set_checking <- train_set[as.Date(train_set$time) == "2014-03-04", ]
train_set_checking$time <- as.character(train_set_checking$time)

full_checking_set <- merge(train_set_checking, classify_dataset, by = c("time", "steps", "skin_temp", "heart_rate", "gsr"), all = TRUE)


names(full_checking_set)
table(full_checking_set$fit.cluster, full_checking_set$activity)


