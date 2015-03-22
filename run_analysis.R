#1 setwd & install data.table
setwd("clningdata_prj/UCI HAR Dataset/")
if (!require("data.table")) {
  install.packages("data.table")
}

#2 load data
mytestData <- read.table("test/X_test.txt",header=FALSE)
mytestData_act <- read.table("test/y_test.txt",header=FALSE)
mytestData_sub <- read.table("test/subject_test.txt",header=FALSE)

mytrainData <- read.table("train/X_train.txt",header=FALSE)
mytrainData_act <- read.table("train/y_train.txt",header=FALSE)
mytrainData_sub <- read.table("train/subject_train.txt",header=FALSE)

#3 Uses descriptive activity names to name the activities in the data set
myactivities <- read.table("activity_labels.txt",header=FALSE,colClasses="character")
mytestData_act$V1 <- factor(mytestData_act$V1,levels=activities$V1,labels=activities$V2)
mytrainData_act$V1 <- factor(mytrainData_act$V1,levels=activities$V1,labels=activities$V2)

#4 labels the data set with descriptive activity names
myfeatures <- read.table("features.txt",header=FALSE,colClasses="character")
colnames(mytestData)<-myfeatures$V2
colnames(mytrainData)<-myfeatures$V2
colnames(mytestData_act)<-c("Activity")
colnames(mytrainData_act)<-c("Activity")
colnames(mytestData_sub)<-c("Subject")
colnames(mytrainData_sub)<-c("Subject")

#5 merge test and training sets into one data set, including the activities
mytestData<-cbind(mytestData,mytestData_act)
mytestData<-cbind(mytestData,mytestData_sub)
mytrainData<-cbind(mytrainData,mytrainData_act)
mytrainData<-cbind(mytrainData,mytrainData_sub)
mybigData<-rbind(mytestData,mytrainData)

#6 extract only the measurements on the mean and standard deviation for each measurement
mybigData_mean<-sapply(mybigData,mean,na.rm=TRUE)
mybigData_sd<-sapply(mybigData,sd,na.rm=TRUE)

#7 Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(data.table)
myDT <- data.table(mybigData)
mytidy<-myDT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(mytidy,file="mytidydata.txt",sep=",",row.names = FALSE)
