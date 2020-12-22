

# Load Packages and get the Data
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
path <- getwd()

## Loading datasets 

source_file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
download.file( source_file , destfile = paste0(getwd() , '/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'), method = "curl")
unzip("getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",exdir = "data")


##
activity_labels <-  fread(input = "C:/Users/SS/Documents/data/UCI HAR Dataset/activity_labels.txt", col.names = c("classLabels", "activityName") )
features <- fread(input = "C:/Users/SS/Documents/data/UCI HAR Dataset/features.txt"  , col.names = c("index", "featureNames"))

# Data Cleansing 
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[featuresWanted, featureNames]
measurements <- gsub('[()]', '', measurements)


# Load train datasets
train <- fread(input = "C:/Users/SS/Documents/data/UCI HAR Dataset/train/X_train.txt")   ###[, featuresWanted, with = FALSE]
trainActivities <- fread(input = "C:/Users/SS/Documents/data/UCI HAR Dataset/train/Y_train.txt" , col.names = c("Activity"))
trainSubjects <- fread(input = "C:/Users/SS/Documents/data/UCI HAR Dataset/train/subject_train.txt", col.names = c("SubjectNum"))
train <- cbind(trainSubjects, trainActivities, train)

# Load test datasets
test <- fread(input = "C:/Users/SS/Documents/data/UCI HAR Dataset/test/X_test.txt")
testActivities <- fread( input = "C:/Users/SS/Documents/data/UCI HAR Dataset/test/Y_test.txt" , col.names = c("Activity"))
testSubjects <- fread(input = "C:/Users/SS/Documents/data/UCI HAR Dataset/test/subject_test.txt" , col.names = c("SubjectNum"))

# Merging all datasets 
test <- cbind(testSubjects, testActivities, test)
combined <- rbind(train, test)


# merge datasets
combined <- rbind(train, test)

# Convert classLabels to activityName basically. More explicit. 
combined[["Activity"]] <- factor(combined[, Activity]
                              , levels = activity_labels[["classLabels"]]
                              , labels = activity_labels[["activityName"]])

combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])

## Creating the final output file 

data.table::fwrite(x = combined, file = "tidyData.txt", quote = FALSE)
















