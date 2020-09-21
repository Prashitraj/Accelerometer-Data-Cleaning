library(dplyr)
setwd("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")

# loading training data
x_train<-read.table("train/X_train.txt")
y_train<-read.table("train/y_train.txt")
sub_train<-read.table("train/subject_train.txt")

# loading testing data
x_test<-read.table("test/X_test.txt")
y_test<-read.table("test/y_test.txt")
sub_test<-read.table("test/subject_test.txt")

col_names<-read.table("features.txt")

# Merges the training and the test sets to create one data set.
x_total<-rbind(x_train,x_test)
y_total<-rbind(y_train,y_test)
sub_total<-rbind(sub_train,sub_test)

activity_labels<-read.table("activity_labels.txt")

# Extracts only the measurements on the mean and standard deviation for each measurement.
col_names<-col_names[grep("mean|std",col_names[,2]),]
x_total<-x_total[,col_names[,1]]

# Uses descriptive activity names to name the activities in the data set
colnames(y_total)<-"activity"
y_total$activityLabel <- factor(y_total$activity,labels = as.character(activity_labels[,2]))
activityLabel<-y_total$activityLabel

# Appropriately labels the data set with descriptive variable names
colnames(x_total)<-col_names[,2]
colnames(sub_total)<-"subject"
total<-cbind(x_total,activityLabel,sub_total)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
total_mean <- total %>% group_by(activityLabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)
