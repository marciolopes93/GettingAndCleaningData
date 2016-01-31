# preliminaries
## set wd, download file, unzip file
setwd("~/OneDrive/Coursera/Getting and Cleaning Data")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "./Human Activity Recognition.zip", method="curl")
dateDownloaded <- date()
unzip("Human Activity Recognition.zip")
setwd("~/OneDrive/Coursera/Getting and Cleaning Data/UCI HAR Dataset")

# read relevant files in and name columns appropriately
features <- read.table("features.txt", header=F) # List of all features
activity <- read.table("activity_labels.txt", header=F) # Links the class labels (y) with their activity name
subjectTrain <- read.table("train/subject_train.txt", header=F) # Each row identifies the subject (1-30)
subjectTest <- read.table("test/subject_test.txt", header=F) # Each row identifies the subject (1-30)
xTrain <- read.table("train/X_train.txt", header=F) # Training set
xTest <- read.table("test/X_test.txt", header=F) # Test set
yTrain <- read.table("train/y_train.txt", header=F) # Training labels (y)
yTest <- read.table("test/y_test.txt", header=F) # Test labels (y)

colnames(activity) <- c("ClassLabel", "ActivityName")
colnames(subjectTrain) <- colnames(subjectTest) <- "Subject"
colnames(xTrain) <- colnames(xTest) <- features[, 2]
colnames(yTrain) <- colnames(yTest) <- "ClassLabel"

# (1) merge the training and the test sets to create one data set
## merge all training data, and all testing data separately
train <- cbind(subjectTrain, yTrain, xTrain) # 7352 obs
test <- cbind(subjectTest, yTest, xTest) # 2947 obs
## merge train and test data frames
data <- rbind(train, test) # 10299

## remove unnecessary items from workspace
rm(subjectTest, subjectTrain, xTest, xTrain, yTest, yTrain)

# (2) extract only the measurements on the mean and standard deviation for each measurement
## NOTE: instructions unclear; decided to include all columns with "mean" or "std"
##       in them, as opposed to those with "mean()" or "std()" only. Also see:
##       https://www.coursera.org/learn/data-cleaning/module/78HFW/discussions/jMw0rsYEEeWb3QofSqIPlQ
colnames(data)
grep("mean|std", names(data), value=T) # columns to keep
keep <- grep("mean|std", colnames(data)); keep # column numbers to keep

subset <- data[, c(1, 2, keep)] # select only: Subject, ClassLabel, keep
rm(data)

# (3) use descriptive activity names to name the activities in the data set
## replace ClassLabel with ActivityName
summary(subset$ClassLabel); table(subset$ClassLabel)
for (id in activity[, 1]){
    subset[subset$ClassLabel==id, 2] <- as.character(activity[id, 2])
}
summary(subset$ClassLabel); table(subset$ClassLabel) # confirm correctly applied

# (4) appropriately labels the data set with descriptive variable names
## already appropriately named in steps above but one column name must change due
## to step 3
names(subset)[2] <- "ActivityName"
## can be more descriptive for illustrative purposes too, by changing "std" to "StDev" and
## f = frequency, t = time for example
colnames(subset) <- gsub("-std", "-StDev", colnames(subset)); colnames(subset)
colnames(subset) <- gsub("^t", "time", colnames(subset)); colnames(subset)
colnames(subset) <- gsub("^f", "frequency", colnames(subset)); colnames(subset)
### good practice to use only letters, numbers and points, with no special characters
### such as "-" or "_". However, I have chosen to leave these as the authors originally
### intended

# (5) create a second, independent tidy data set with the average of each variable for 
# each activity and each subject
library(dplyr)
subsetGrouped <- group_by(subset, Subject, ActivityName)
tidy <- summarize_each(subsetGrouped, funs(mean))

setwd("~/OneDrive/Coursera/Getting and Cleaning Data")
write.table(tidy, "tidy.txt", row.name=F)
