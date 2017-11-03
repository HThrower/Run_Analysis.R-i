
library(reshape2)
filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}

#load the dataset(Training/test data)
train<- read_csv("~/R/UCI HAR Dataset.csv/UCI HAR Dataset/train/X_train.txt")
trainActivity<- read_csv("~/R/UCI HAR Dataset.csv/UCI HAR Dataset/train/y_train.txt")
trainSubject<-subject_train <- read_csv("~/R/UCI HAR Dataset.csv/UCI HAR Dataset/train/subject_train.txt")
train<-cbind(trainActivity,trainSubject,train)
  
test<- X_test <- read_csv("~/R/UCI HAR Dataset.csv/UCI HAR Dataset/test/X_test.txt")
testActivities <- read_csv("~/R/UCI HAR Dataset.csv/UCI HAR Dataset/test/y_test.txt")
subject_test <- read_csv("~/R/UCI HAR Dataset.csv/UCI HAR Dataset/test/subject_test.txt")
test<-cbind(test, testActivities, subject_test)

#Mean of dataset
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)

#merge of data set
MergTotalData<-cbind(train,test)
colnames(allData) <- c("subject", "activity", featuresWanted.names)


#The factor value of  (Activity/features)
activityName<- read_csv("~/R/Getting and Cleaning Data Course Project/UCI HAR Dataset/activity_labels.txt")
activityName<- as.character(activityLabels)
features <- read_csv("~/R/Getting and Cleaning Data Course Project/UCI HAR Dataset/features.txt")  
features<- as.character(features)
 
#activities & subjects into factor
MergTotalData$activity <- factor(MergTotalData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
MergTotalData$subject <- as.factor(MergTotalData$subject)

MergTotalData.melted <- melt(MergTotalData, id = c("subject", "activity"))
MergTotalData.mean <- dcast(MergTotalData.melted, subject + activity ~ variable, mean)

write.table(MergTotalData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)