##Getting and Cleaning Data Peer Graded Assignment
library(dplyr)

# Load activity labels and features

features <- read.table("features.txt", col.names = c("num","features"))
activity_labels <- read.table("activity_labels.txt" , col.names = c("label","activity"))

# Merge the training and the test sets to create one set.

# Read test dataset

subject_test <- read.table("test/subject_test.txt", col.names = "Subject")
x_test <- read.table("test/x_test.txt", col.names = features$features)
y_test <- read.table("test/y_test.txt", col.names = "label")
y_test_label <- left_join(y_test, activity_labels, by = "label")

tidy_test <- cbind(subject_test, y_test_label, x_test)
tidy_test <- select(tidy_test, -label)

# Read train dataset

subject_train <- read.table("train/subject_train.txt", col.names = "Subject")
x_train <- read.table("train/x_train.txt", col.names = features$features)
y_train <- read.table("train/y_train.txt", col.names = "label")
y_train_label <- left_join(y_train, activity_labels, by = "label")

tidy_train <- cbind(subject_train, y_train_label, x_train)
tidy_train <- select(tidy_train, -label)

#combine test and train data sets

tidy_set <- rbind(tidy_test, tidy_train)

# Extract mean and standard deviation

tidy_mean_std <- select(tidy_set, contains("mean"), contains("std"))

# Average of each variable for each activity and each subject

tidy_mean_std$subject <- as.factor(tidy_set$Subject)
tidy_mean_std$activity <- as.factor(tidy_set$activity)

tidy_file <- tidy_mean_std %>%
    group_by(subject, activity) %>%
    summarize_all(funs(mean))  

## Generate tidy file

write.table(tidy_file, "tidy_data_set.txt", row.name=FALSE)

