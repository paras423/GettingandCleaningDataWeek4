# load libraries
library(dplyr) 


setwd("UCI HAR Dataset")       # set dataset directory


xtrain   <- read.table("./train/X_train.txt")      # read the train data
ytrain   <- read.table("./train/Y_train.txt") 
subtrain <- read.table("./train/subject_train.txt")


xtest   <- read.table("./test/X_test.txt")           #read the test data 
ytest   <- read.table("./test/Y_test.txt") 
subtest <- read.table("./test/subject_test.txt")


features <- read.table("./features.txt")   


activitylabels <- read.table("./activity_labels.txt")      # read the activity labels 


xtotal   <- rbind(xtrain, xtest)        # merge of training and test sets
ytotal   <- rbind(ytrain, ytest)
subtotal <- rbind(subtrain, subtest) 


sel_features <- variable_names[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
xtotal      <- xtotal[,sel_features[,1]]     # keep only measurements for mean and standard deviation 


colnames(xtotal)   <- sel_features[,2]     #naming the columns 
colnames(ytotal)   <- "activity"
colnames(subtotal) <- "subject"


total <- cbind(subtotal, ytotal, xtotal)  #merging final data set


total$activity <- factor(total$activity, levels = activitylabels[,1], labels = activitylabels[,2]) 
total$subject  <- as.factor(total$subject)   # turn activities & subjects into factors 


totalmean <- total %>% group_by(activity, subject) %>% summarize_all(funs(mean)) 

# export summary dataset
write.table(totalmean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE) 

