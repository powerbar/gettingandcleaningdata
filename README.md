gettingandcleaningdata
======================

## Purpose  

To undertake the course project for Getting and Cleaning Data course on Coursera

## Goal

Per the course project instructions, conduct the full process of reading, loading the Samsung sensor data set and all the ensuing measures necessary for generating a tidy data set.  It is mean to demonstrate the student’s knowledge of the whole process of tidying data set

## Key steps

1.  Read and load the Samsung data set and the reshape2 package for R required for carrying out melt and cast functions;
2.  Create one R script called run_analysis.R;
3.  Merges the training and the test sets to create one data set;
4.  Extracts only the mean and standard deviation measurement out of the original data set. 
5.  Uses descriptive activity names to name the activities in the data set, and fine-tune the variable names to go with the variable naming protocols as laid out by Google’s R style guide (https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml);
6.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Actual process and commands given

### initial setup
setwd("./data/project3")

library(reshape2)

### read and load train data and test data
test.x <- read.table("./train/X_train.txt", quote="\"")

train.x <- read.table("./test/X_test.txt", quote="\"")

### Merge X test and train to X dataset
merged.x <- rbind(test.x, train.x)

## Read test and train labels
tesint("t.y <- read.table("./test/Y_test.txt", quote="\"")

train.y <- read.table("./train/Y_train.txt", quote="\"")
### Merge test labels and train labels
merged.y <- rbind(test.y, train.y)

### Load test and train subjects
test.subject <- read.table("./test/subject_test.txt", quote="\"")

train.subject<- read.table("./train/subject_train.txt", quote="\"")
### Merge test and train subjects
merged.subject <- rbind(test.subject, train.subject)

### Load activity and feature labels
activity <- read.table("./activity_labels.txt", quote="\"")

features <- read.table("./features.txt", quote="\"")

### Assign column names to merged dataset
colnames(merged.x) <- as.character(features$V2)

colnames(activity)[2] <- "Activity"
colnames(merged.subject) <- "Subject"

### Merge x and y data sets
merged.y <- merge(merged.y, activity, by.x="V1", by.y="V1", sort=FALSE)

merged.x <- cbind(merged.subject, merged.y, merged.x)

### To pick mean and std related varialbes, first step is to extract all column names relevant out of data set
nt <- names(merged.x)

mean.n <- grep(("-mean()-"),nt, fixed=T)

std.n <- grep(("-std()-"),nt, fixed=T)
### sum up all variables to be extractede from data set
n01 <- c(mean.n, std.n)
### subset variables having to do with mean and sta into new data set data01
data01 <- merged.x[, c(1,3,c(n01))]

### T0 change and finetune column names, first to extract column names for data01
nc <- colnames(data01)
#### strip -, (, ), etc. away for column names and change to lower case
#### store the new col names in nc.c
nc.c <- sub("-",".", nc)
nc.c <- sub("()-",".", nc.c)
nc.c <- sub("\\(\\)", "", nc.c)
nc.c <- tolower(nc.c)
### update column names of data01 with "cleaned" column names
colnames(data01) <- nc.c

### order data01 by subject into data01.order
data01.order <- data01[order(data01$subject), ]

### melt
molten <- melt(data01.order, id=c("subject","activity"))
### dcast
cast <- dcast(molten, subject + activity ~ variable, mean)

### write the tidy data set into a .txt file for upload
write.table(mean.cast1, "./mean.cast.txt", sep="/t")
