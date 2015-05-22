

#Download the file
#Set working directory.

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


#Merge the train and test datasets
obs <- rbind( X_test, X_train)
act <- rbind( a_test, a_train)
sub <- rbind( s_test, s_train)

#Find columns in feature list that are either mean or standard dev
mean_sd_col_names <- feat[grep("(mean|std)\\(", feat[,2]),] 

#create a frame with only these columns.
mean_sd_obs <- obs[,mean_sd_col_names[,1]]


#Transform activity codes vectoir into a vector of activity names
act <- as.factor(act[,1])
levels(act) <- act_lab[,2]

activities <- data.frame(v1=act)

colnames(activities)<-"Activity"
colnames(sub)<-"Subjects"

combined <- cbind(sub,activities,mean_sd_obs)






