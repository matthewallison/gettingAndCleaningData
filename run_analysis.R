# 1. Merges the training and the test sets to create one data set.

# download the set - keep these commented out if file is already downloaded
#setwd("~/R")
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="tmp.zip", method="curl")
#unzip("tmp.zip")
#file.remove("tmp.zip")
setwd("~/R/UCI HAR Dataset")
subject_test <- read.table("test/subject_test.txt")
test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
test$Activity <- y_test[,1]
test$Subject <- subject_test[,1]
subject_train <- read.table("train/subject_train.txt")
train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
train$Activity <- y_train[,1]
train$Subject <- subject_train[,1]
whole <- rbind(train, test)
View(whole)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("features.txt", colClasses="character")
features <- features[,2]
extracted <- whole[,c("Activity", "Subject")]
extracted <- cbind(whole[,which(grepl("mean\\(\\)", features) | grepl("std\\(\\)", features))], extracted)
View(extracted)

# 3. Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table("activity_labels.txt", colClasses="character")
activity_labels <- activity_labels[,2]
getActivity <- function(x) {activity_labels[x]}
extracted$Activity <- sapply(extracted$Activity, getActivity)
View(extracted)

# 4. Appropriately labels the data set with descriptive variable names. 

newLabels <- features[which(grepl("mean\\(\\)", features) | grepl("std\\(\\)", features))]
newLabels <- sub("^t", "time", newLabels)
newLabels <- sub("^f", "freq", newLabels)
newLabels <- gsub("std\\(\\)", "Std", newLabels)
newLabels <- gsub("mean\\(\\)", "Mean", newLabels)
newLabels <- gsub("-", "", newLabels)
newLabels <- gsub("BodyBody", "Body", newLabels)
names(extracted)[seq_along(newLabels)] <- newLabels
View(extracted)

# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.

# uncomment these lines if you need to install dplyr or reshape2
#install.packages("dplyr")
#install.packages("reshape2")
require(dplyr)
require(reshape2)
melted <- melt(extracted, id.vars=c("Activity", "Subject"), variable.name="Variable")
grouped <- group_by(melted, Activity, Subject, Variable)
result <- summarise(grouped, Mean=mean(value))
# Uncomment this if we want wide data
#result <- dcast(melted, Activity + Subject ~ Variable, mean)
View(result)
write.table(result, file="result.txt", row.names=F)
