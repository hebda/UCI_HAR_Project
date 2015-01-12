# run_analysis.R uses the Human Activity Recognition Using Smartphones Data Set 
# The goals are the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Preprocessing:
# wget https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# unzip getdata%2Fprojectfiles%2FUCI\ HAR\ Dataset.zip
# rm getdata%2Fprojectfiles%2FUCI\ HAR\ Dataset.zip
# Afterwards, the data will be in the directory 'UCI HAR Dataset'

# packages needed to be loaded
library(plyr)


# Step 1: merge training and test sets
# The data are found in the train and test directories.
df_train_X<-read.table('UCI HAR Dataset/train/X_train.txt')
df_train_Y<-read.table('UCI HAR Dataset/train/y_train.txt')
df_train_subjects<-read.table('UCI HAR Dataset/train/subject_train.txt')
df_test_X<-read.table('UCI HAR Dataset/test/X_test.txt')
df_test_Y<-read.table('UCI HAR Dataset/test/y_test.txt')
df_test_subjects<-read.table('UCI HAR Dataset/test/subject_test.txt')

# merge the data frames
smartphone_measurements <- rbind(
    cbind(df_train_subjects, cbind(df_train_Y,df_train_X)),
    cbind(df_test_subjects, cbind(df_test_Y,df_test_X)) )
# swap order of columns
smartphone_measurements[,1:2] <- smartphone_measurements[,2:1]

# clear the memory of the unneeded data frames
rm(df_train_X,df_train_Y,df_train_subjects,df_test_X,df_test_Y,df_test_subjects)


# Step 4: Give the dataset appropriate names for the variables.

#rename the firist two columns since we already know what those are.
names(smartphone_measurements)[1]<-'activity'
names(smartphone_measurements)[2]<-'subject'

# For the variables V1,...,V561, the names are found in features.txt. 
# Only those with mean or std in the name will be kept.
variable_names<-read.table('UCI HAR Dataset/features.txt',as.is=T)
names(smartphone_measurements)[-(1:2)]<-variable_names[,2]


# Step 2: extract only the measurements on the mean and standard deviation for each measurement.
mean_indices<-grep('mean',names(smartphone_measurements))
std_indices<-grep('std',names(smartphone_measurements))
smartphone_measurements<-smartphone_measurements[,sort(unique(c(1,2,mean_indices,std_indices)))]


# Step 3: use descriptive labels for activities by replacing factors 1,2,... with WALKING,WALKING_UPSTAIRS,...
# Appropriate labels are found in activity_labels.txt
activity_names<-read.table('UCI HAR Dataset/activity_labels.txt',as.is=T)
activity_factors<-factor(activity_names$V2,levels=activity_names$V2)

# Create a function to replace the activity integers with factors.
name_activity <- function(x){ activity_factors[x] }
smartphone_measurements$activity<-unlist(lapply(smartphone_measurements$activity,name_activity))


# Step 5: Create another dataset with the average of each variable for each activity and each subject.

smartphone_summary<-aggregate( smartphone_measurements[-(1:2)] , smartphone_measurements[1:2], mean)
smartphone_summary<-arrange(smartphone_summary,activity,subject)

# for reference, these work too
# alt1:
# ddply(smartphone_measurements, c("subject","activity"), function(x){
#   y <- subset(x, select= c(-activity,-subject))
#   apply(y, 2, mean)
# })
# alt2:
# aggregate( . ~ subject + activity, smartphone_measurements, mean)

write.table(smartphone_summary,row.name=F,file='smartphone_summary.txt')
