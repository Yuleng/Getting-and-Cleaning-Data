## This is the R code for coursera project on
## Getting and Cleaning Data

## create the data file for downloading the data. large data, Be patient for download
if (!file.exists("data")) {dir.create("data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/galaxy.zip")
dateDownload1 <- date()

## unzip and read the test and train data
unzip("./data/galaxy.zip")
test <- read.table("./UCI HAR Dataset/test/X_test.txt")
train <- read.table("./UCI HAR Dataset/train/X_train.txt")

## step1.Merges the training and the test sets to create one data set
data <- rbind(test,train)

## step2.Extracts only the measurements on the mean and standard deviation for each measurement.
feature <- read.table("./UCI HAR Dataset/features.txt") ## read the features index
toMatch <- c("mean()","std()")
index <- grep(paste(toMatch, collapse="|"), feature$V2) ## create an index for extracting the columns
data_ms <- data[,index]

## step3.Uses descriptive activity names to name the activities in the data set
test_label <- read.table("./UCI HAR Dataset/test/y_test.txt")
train_label <- read.table("./UCI HAR Dataset/train/y_train.txt")
activity <- rbind(test_label, train_label) ## note the order of binding should be the same as step1
activity_label <- read.table("./UCI HAR Dataset/activity_labels.txt")
## use plyr packaged to merge two tables preserving the order
library(plyr)
act <- join(activity,activity_label)  ## note merge function cannot preserve the order
## add a column with activity names
data_ms$activity <- act[,2]

## step4.Appropriately labels the data set with descriptive variable names.
names(data_ms) <- c(as.character(feature$V2[index]),"activity")

## step5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data_tidy <- ddply(data_ms,.(activity),colwise(mean))

## write the txt file
write.table(data_tidy,file="./data_tidy.txt", row.names=F)