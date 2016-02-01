# run_analysis.R
rm(list=ls())

# Read data files. For both train and test sets, read subject, X, and y files.
subject_train <- read.table("UCI_HAR_Dataset/train/subject_train.txt")
X_train <- read.table("UCI_HAR_Dataset/train/X_train.txt")
y_train <- read.table("UCI_HAR_Dataset/train/y_train.txt")
subject_test <- read.table("UCI_HAR_Dataset/test/subject_test.txt")
X_test <- read.table("UCI_HAR_Dataset/test/X_test.txt")
y_test <- read.table("UCI_HAR_Dataset/test/y_test.txt")

# Combine train and test datasets
subject <- rbind(subject_train,subject_test)
X <- rbind(X_train,X_test)
y <- rbind(y_train,y_test)
n <- length(y[,1])

# Name columns
names(subject) <- "subject"
names(y) <- "activityid"
# Add activity description
activitylabels <- read.table("UCI_HAR_Dataset/activity_labels.txt",stringsAsFactors=FALSE)
names(activitylabels) <- c("activityid","activity")
activity <- vector(mode="character",length=n)
for (i in 1:6) {
  activity[y==i] <- activitylabels$activity[i]
}

# We only care about the mean and standard deviation columns.
# Read features.txt to get list of column names and select those with "mean" or "std".
features <- read.table("UCI_HAR_Dataset/features.txt")
names(features) <- c("column","feature")
desiredcolumns <- grep("mean|std",features$feature)
desiredfeatures <- grep("mean|std",features$feature,value=TRUE)
X <- X[,desiredcolumns]
names(X) <- desiredfeatures

# Combine the data frames into the "tidy" data frame
tidydata <- cbind(subject,activity,X)
ncol <- length(tidydata[1,])

# Average the data by subject and column
avgdata <- aggregate(tidydata[,3:ncol],by=list(subject=tidydata$subject,activity=tidydata$activity),FUN=mean)

# Output to file
write.table(avgdata,"avgBySubjectAndActivity.txt",row.names=FALSE)