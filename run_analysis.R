#@Author: Tim Zhukov
#Assume that we have downloaded the file and set the current working directory

library(data.table)

#load the data into dataframes
feat     <- read.table("features.txt") #names

#X - read with lables
X_test  <- read.table("test/X_test.txt"  ,sep="",header=FALSE,col.names=feat[,2]) #test
X_train <- read.table("train/X_train.txt",sep="",header=FALSE,col.names=feat[,2]) #train

#Activities
a_test  <- read.table("test/y_test.txt"  ,sep="",header=FALSE) #test
a_train <- read.table("train/y_train.txt",sep="",header=FALSE) #train

act_lab   <- read.table("activity_labels.txt",sep="",header=FALSE) #train

#Subjects
s_test  <- read.table("test/subject_test.txt"   ,sep="",header=FALSE) #train
s_train <- read.table("train/subject_train.txt",sep="",header=FALSE) #train

#1
#Merge the train and test datasets
obs <- rbind( X_test, X_train)
act <- rbind( a_test, a_train)
sub <- rbind( s_test, s_train)

#2
#Find columns in feature list that are either mean or standard dev
mean_sd_col_names <- feat[grep("(mean|std)\\(", feat[,2]),] 

#create a frame with only these columns.
mean_sd_obs <- obs[,mean_sd_col_names[,1]]

#3
#Transform activity codes vector into a vector of activity names
act <- as.factor(act[,1])
levels(act) <- act_lab[,2]

activities <- data.frame(v1=act)

#Assign names to the columns
colnames(activities)<-"Activity"
colnames(sub)<-"Subjects"

#4 - Since we read the data with headers from the features.txt, we don't need to assign names to them
combined <- cbind(sub,activities,mean_sd_obs)

write.table(format(combined, scientific=T) , "tidy1.txt" , row.names=F , col.names=F , quote=2)

#5 - Average out the data using Subjects and Activites as bucket vector.
tidy_average <- aggregate(combined[, 3:ncol(combined)] , by=list(Subjects = combined$Subjects , Activities = combined$Activity) , mean)

write.table(format(tidy_average, scientific=T) , "tidy2.txt" , row.names=F , col.names=F , quote=2)
