# Step 1
# Merge the training and the test sets to create one data set.

# load training data
trainingDataX <- read.table("./data/train/X_train.txt")
trainingDataY <- read.table("./data/train/y_train.txt")
trainingSubj <- read.table("./data/train/subject_train.txt")

# load test data
testDataX <- read.table("./data/test/X_test.txt")
testDataY <- read.table("./data/test/y_test.txt")
testSubj <- read.table("./data/test/subject_test.txt")

# merge data
mergeXData <- rbind(trainingDataX, testDataX)
mergeYData <- rbind(trainingDataY, testDataY)
mergeSubject <- rbind(trainingSubj, testSubj)

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("./data/features.txt")
meanStdDev <- grep("mean\\(\\) | std\\(\\)", features[,2])
mergeXData <- mergeXData[,meanStdDev]
names(mergeXData) <- gsub("\\(\\)", "", features[meanStdDev, 2])
names(mergeXData) <- gsub("mean", "Mean", names(mergeXData))
names(mergeXData) <- gsub("std", "Std", names(mergeXData) )
names(mergeXData) <- gsub("-", "", names(mergeXData))

# Step 3
# Use descriptive activity names to name the activities in the data set

activity <- read.table("./data/activity_labels.txt")
activity[,2] <- tolower(gsub("_", "", activity[,2]))
substr(activity[2,2], 8, 8) <- toupper(substr(activity[2,2], 8, 8))
substr(activity[3,2], 8, 8) <- toupper(substr(activity[3,2], 8, 8))
activityLabel <- activity[mergeYData[,1], 2]
mergeYData[,1] <- activityLabel
names(mergeYData) <- "activity"

# Step 4
# Appropriately labels the data set with descriptive variable names. 

names(mergeSubject) <- "subject"
cleanData <- cbind(mergeSubject, mergeYData, mergeXData)
write.table(cleanData, "./data/merged_data.txt")

# Step 5
# Creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject. 

subjLen <- length(table(mergeSubject))
actLen <- dim(activity)[1]
colLen <- dim(cleanData)[2]
result <- matrix(NA, nrow=subjLen*actLen, ncol=colLen)
result <- as.data.frame(result)
colnames(result) <- colnames(cleanData)
row <- 1
for (i in 1:subjLen){
  for (j in 1:actLen){
    result[row,1] <- sort(unique(mergeSubject)[,1])[i]
    result[row,2] <- activity[j,2]
    bool1 <- i == cleanData$subject
    bool2 <- activity[j,2] == cleanData$activity
    result[row, 3:colLen] <- colMeans(cleanData[bool1&bool2, 3:colLen])
    row <- row + 1
  }
}
head(result)
write.table(result, "./data/data_with_means.txt",row.names=FALSE)