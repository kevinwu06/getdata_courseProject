# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject 
#    - Create a txt file with write.table() using row.name=FALSE)
#    - Each variable you measure should be in one column, 
#    - Each different observation of that variable should be in a different row

# data downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# on 2/13/2015 7:23PM

unzip("getdata-projectfiles-UCI HAR Dataset.zip") #unzip the data

#read in data sets, activity labels, & subject ids
test_set <- read.table("UCI HAR Dataset/test/X_test.txt") 
test_label <- read.table("UCI HAR Dataset/test/y_test.txt") 
train_set <- read.table("UCI HAR Dataset/train/X_train.txt") 
train_label <- read.table("UCI HAR Dataset/train/y_train.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")

#adding labels and subject ids to data sets w/ labels in column 1, subject id in column 2
test_labeled_set <- cbind(test_label, test_subject, test_set) 
train_labeled_set <- cbind(train_label, train_subject, train_set)
rm(test_label,test_subject,test_set,train_label,train_subject,train_set) #free up memory

#combining labeled data sets
combined <- rbind(train_labeled_set, test_labeled_set)
rm(test_labeled_set,train_labeled_set)

#reading in feature labels and creating vector of variable names from them
features <- read.table("UCI HAR Dataset/features.txt")
col_names <- c("activity","subject_id",as.character(features[,2]))

#labeling the data set with descriptive variable names
colnames(combined) <- col_names

#find column indices for mean and standard deviation of each measurement
#NOTE: excluding meanFreq() and angle() related means
meanORstd_index <- grep(paste(c("mean()","std()"),collapse="|"), colnames(combined), fixed=FALSE)

#extract only activity, subject id, and mean + std. dev. of each measurement 
meanORstd_index <- c(1,2,meanORstd_index)
data <- combined[,meanORstd_index]
rm(combined)

# reading in activity labels and replacing # with label
activity_label <- read.table("UCI HAR Dataset/activity_labels.txt")
act_num <- activity_label[,1]
act_lab <- as.character(activity_label[,2])
suppressWarnings(data[,1] <- mapply(gsub, act_num, act_lab, x = data[,1]))

#When there are multiple measurements of the same subject, across time or using different tools, 
#the data is often described as being in "wide" format if there is one observation row per subject 
#with each measurement present as a different variable and "long" format if there is one observation 
#row per measurement (thus, multiple rows per subject).

#create factor variables for activity and subject id

#calculate average of each variable for each activity and subject
