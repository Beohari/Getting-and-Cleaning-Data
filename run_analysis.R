library(dplyr)

mycolnames <- read.table("./Assignment 4 Data/UCI HAR Dataset/features.txt")

testdata <- read.table("./Assignment 4 Data/UCI HAR Dataset/test/X_test.txt",
                       col.names = as.character(mycolnames[,2]))
traindata <- read.table("./Assignment 4 Data/UCI HAR Dataset/train/X_train.txt",
                        col.names = as.character(mycolnames[,2]))

# the part up here just gets the training and testing data into data frames

testlabels <- read.table("./Assignment 4 Data/UCI HAR Dataset/test/y_test.txt")
trainlabels <- read.table("./Assignment 4 Data/UCI HAR Dataset/train/y_train.txt")

newtestlabels <- factor(testlabels[,1], labels = c("Walking", "Walking Upstairs",
                                                   "Walking Downstairs", "Sitting",
                                                   "Standing", "Laying"))

newtrainlabels <- factor(trainlabels[,1], labels = c("Walking", "Walking Upstairs",
                                                   "Walking Downstairs", "Sitting",
                                                   "Standing", "Laying"))

# the part up here makes some lists of the activities that correspond to the
# rows in the testdata and traindata data frames

testsubjects <- read.table("./Assignment 4 Data/UCI HAR Dataset/test/subject_test.txt")

trainsubjects <- read.table("./Assignment 4 Data/UCI HAR Dataset/train/subject_train.txt")

# the part up here gets the number of the subject for each observation

testdata <- cbind(testdata, Activity = as.vector(newtestlabels), as.vector(testsubjects))
traindata <- cbind(traindata, Activity = as.vector(newtrainlabels), as.vector(trainsubjects))

# these parts add new columns to the data frames for the activity and subject

alldata <- rbind(testdata, traindata)

alldata <- rename(alldata, Subject = V1)

# and now we have one data frame with everything

meanstdlogical <- grepl("mean|std|Subject|Activity", names(alldata))

meanstddata <- alldata[, meanstdlogical]

# this data frame has every observation, and only the columns with mean or std

groupeddata <- group_by(meanstddata, Subject, Activity)

finaldata <- summarise_all(groupeddata, .funs = c(mean = "mean"))
finaldata

# this is the final, neat, data frame
