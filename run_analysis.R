

activity <- read_csv("~/R/UCI HAR Dataset.csv/activity.csv")
View(activity)
#steps per day
total.steps <- aggregate(steps ~ date, data = activity , sum, na.rm = TRUE)
hist(total.steps$steps,col="red",
      main="Histogram of Total Steps taken per day",xlab="Total Steps taken per day",cex.axis=1,cex.lab = 1)
##What is mean/median total number of steps taken per day? 10766 & 10765
mean(total.steps$steps)
median(total.steps$steps)
print(mean)
##What is the average daily activity pattern? 835 maximum number of steps and 
##206.2average number of steps taken
steps_interval <- aggregate(steps ~ interval, data = activity, mean, na.rm = TRUE)
plot(steps ~ interval, data = steps_interval, type = "l", xlab = "Time Intervals (5-minute)", ylab = "Mean number of steps taken (all Days)", 
     main = "Average number of steps Taken at 5 minute Intervals",  col = "yellow")
maxStepInterval<-steps_interval[which.max(steps_interval$steps),"interval"]
max.step<-max(steps_interval$average_steps)

##Imputing missing values
## 2304 total number of missing values
missing_rows <- sum(!complete.cases(k))
complete.k <- activity

MedianStepsPerInterval <- function(interval){
  steps_interval[steps_interval$interval==interval,"steps"]
}
  flag = 0
  for (i in 1:nrow(complete.k)) {
    if (is.na(complete.k[i,"steps"])) {
      complete.k[i,"steps"] <- MeanStepsPerInterval(complete.k[i,"interval"])
      flag = flag + 1
    }
  }
  total_steps <- aggregate(steps ~ date, data = complete.k, sum)
  hist(total_steps$steps, col = "pink",xlab = "Total Number of Steps", 
       ylab = "Frequency", main = "Histogram of Total Number of Steps taken each Day")
##     the mean is the same as before however, 
##the median is different from the begining based on the added missing values

mean(total_steps$steps)
median(total_steps$steps)
print(median)

complete.k$day <- ifelse(as.POSIXlt(as.Date(complete.k$date))$wday%%6==
                                  0, "weekend", "weekday")
complete.k$day <- factor(complete.k$day, levels = c("weekday", "weekend"))

steps.interval= aggregate(steps ~ interval + day, complete.k, mean)
library(lattice)
xyplot(steps ~ interval | factor(day), data = steps.interval, aspect = 1/2, 
       type = "l")








