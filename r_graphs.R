metrics <- read.csv("metrics.csv")
activities <- read.csv("bodystates.csv")


f_to_celsius <- function(temp_Far){
  temp_C <- (temp_Far - 32)*5/9
  return(temp_C)
}

metrics$time <- strptime(as.character(metrics$time), format = "%A %b %d %H:%M:%S %Y")
metrics$skin_temp <- f_to_celsius(metrics$skin_temp)



metrics2 <- metrics[as.Date(metrics$time) == "2014-03-04", ]

plot(metrics2$time, metrics2$steps, col = "red", pch = 19, cex = 0.6, xlab = "Time", ylab = "")
# add grid lines
grid(nx = 26, ny = 26, col = "grey", lty = "dotted", lwd = par("lwd"), equilogs = TRUE)
# add more points
points(metrics2$time, metrics2$heart_rate, col = "blue", pch = 19, cex = 0.4)
points(metrics2$time, metrics2$skin_temp, col = "green", pch = 21, cex = 0.4)
# add legend
legend(2000, 9.5, c("Steps", "Heart rate", "Skin temperature"), lty = c(1, 1, 1), col = c("red", "blue", "green"))




activities$time1 <- strptime(as.character(activities$time1), format = "%A %b %d %H:%M:%S %Y")
activities$time2 <- strptime(as.character(activities$time2), format = "%A %b %d %H:%M:%S %Y")

activities2 <- activities[as.Date(activities$time1) == "2014-03-04", ]

plot(activities2$time1, activities2$fake_val, type = "l", ylim = c(0, 200))
for (i in 1:nrow(activities2)){
  cur_col <- gray((as.integer(activities2$bodystate[i]))/8)
  rect(activities2$time1[i], 0, activities2$time2[i], 200, col = cur_col)
}

points(metrics2$time, metrics2$steps, col = "blue", pch = 19, cex = 0.6)
points(metrics2$time, metrics2$heart_rate, col = "red", pch = 21, cex = 0.5)
points(metrics2$time, metrics2$skin_temp, col = "green", pch = 19, cex = 0.2)








