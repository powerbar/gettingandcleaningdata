setwd("./data/project3")

library(reshape2)
## print("Read X test data")
test.x <- read.table("./train/X_train.txt", quote="\"")
## print("Read X train data")
train.x <- read.table("./test/X_test.txt", quote="\"")
## print("Merge X test and train to X dataset")
merged.x <- rbind(test.x, train.x)

## print("Read test labels")
test.y <- read.table("./test/Y_test.txt", quote="\"")
## print("Read train labels")
train.y <- read.table("./train/Y_train.txt", quote="\"")
## print("Merge test labels and train labels")
merged.y <- rbind(test.y, train.y)

## print("Load test subjects")
test.subject <- read.table("./test/subject_test.txt", quote="\"")
## print("Load train subjects")
train.subject<- read.table("./train/subject_train.txt", quote="\"")
## print("Merge test and train subjects")
merged.subject <- rbind(test.subject, train.subject)

## print("Load activity labels")
activity <- read.table("./activity_labels.txt", quote="\"")
## print("Load features")
features <- read.table("./features.txt", quote="\"")

## print("Assign column names to merged dataset")
colnames(merged.x) <- as.character(features$V2)

colnames(activity)[2] <- "Activity"
colnames(merged.subject) <- "Subject"

merged.y <- merge(merged.y, activity, by.x="V1", by.y="V1", sort=FALSE)

merged.x <- cbind(merged.subject, merged.y, merged.x)

## extract all column names for data set
nt <- names(merged.x)
## find variables having to do with mean
mean.n <- grep(("-mean()-"),nt, fixed=T)
## find variables having to do with std
std.n <- grep(("-std()-"),nt, fixed=T)
## sum up all variables to be extractede from data set
n01 <- c(mean.n, std.n)
## subset variables having to do with mean and sta into new data set data01
data01 <- merged.x[, c(1,3,c(n01))]

## to change column names
## extract column names for data01
nc <- colnames(data01)
## strip -, (, ), etc. away for column names and change to lower case
## store the new col names in nc.c
nc.c <- sub("-",".", nc)
nc.c <- sub("()-",".", nc.c)
nc.c <- sub("\\(\\)", "", nc.c)
nc.c <- tolower(nc.c)
## update column names of data01 with "cleaned" column names
colnames(data01) <- nc.c

## order data01 by subject into data01.order
data01.order <- data01[order(data01$subject), ]

## melt
molten <- melt(data01.order, id=c("subject","activity"))
## dcast
cast <- dcast(molten, subject + activity ~ variable, mean)

## write the tidy data set
write.table(mean.cast1, "./mean.cast.txt", sep="/t")
