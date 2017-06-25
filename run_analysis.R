#the function donwloads the data, cleans it, and returns a dataset with the average of 
#each variable for each activity and each subject.
 
cleanSportData <- function(){
    library(dplyr)
    library(reshape2)
    #if not present, create data folder
    if(!file.exists("./data")){dir.create("./data")}
    
    #if not present, download zip file
    URLfile<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    if(!file.exists("./data/galaxyDB.zip")){
        download.file(URLfile, "./data/galaxyDB.zip", method = "curl")
    }
    #if not already done, unzip file
    if(!file.exists("./data/UCI HAR Dataset")){
        unzip("./data/galaxyDB.zip", exdir = "./data")
    }
    
    #import datasets and build complete dataset (subject, activity, trainORtest, allothermeasures)
        #variables names
    activity_labels<-tbl_df(read.table("./data/UCI HAR Dataset/activity_labels.txt"))
    variables561<-tbl_df(read.table("./data/UCI HAR Dataset/features.txt"))
        #test
    subject_test<-tbl_df(read.table("./data/UCI HAR Dataset/test/subject_test.txt"))
    activity_test<-tbl_df(read.table("./data/UCI HAR Dataset/test/y_test.txt"))
    X_test<-tbl_df(read.table("./data/UCI HAR Dataset/test/X_test.txt"))
    #give appropriate variables names
    names(X_test)<-variables561$V2
    names(subject_test)<-c("personID")
    names(activity_test)<-c("activity")
    #extract only mean and std for each measurement
    meanIndex<-grep("mean()", variables561$V2,fixed = TRUE)
    mean_test<-X_test[,meanIndex]
    stdIndex<-grep("std()",variables561$V2,fixed = TRUE)
    std_test<-X_test[,stdIndex]
    
    merged_test<-tbl_df(cbind(subject_test,activity_test,mean_test,std_test))
    merged_test<-mutate(merged_test,group=1)
    
        #train
    subject_train<-tbl_df(read.table("./data/UCI HAR Dataset/train/subject_train.txt"))
    activity_train<-tbl_df(read.table("./data/UCI HAR Dataset/train/y_train.txt"))
    X_train<-tbl_df(read.table("./data/UCI HAR Dataset/train/X_train.txt"))
    #give appropriate variables names
    names(X_train)<-variables561$V2
    names(subject_train)<-c("personID")
    names(activity_train)<-c("activity")
    #extract only mean and std for each measurement
    mean_train<-X_train[,meanIndex]
    std_train<-X_train[,stdIndex]
    
    merged_train<-tbl_df(cbind(subject_train,activity_train,mean_train,std_train))
    merged_train<-mutate(merged_train,group=2)
    
    testAndTrain<-tbl_df(rbind(merged_test,merged_train))
    
    #better describe activity names (standing, walking ecc)
    testAndTrain<-mutate(testAndTrain,activity = factor(activity, labels = activity_labels$V2))
    testAndTrain<-mutate(testAndTrain,group=factor(group,labels = c("testing group","training group")))
    testAndTrain
    #second dataset: average of each variable for each activity and each subject
        #get vector of names of mean and standard deviation for each measurement
    meanvar<-grep("mean()", variables561$V2,value = TRUE,fixed = TRUE)
    stdvar<-grep("std()", variables561$V2,value = TRUE,fixed = TRUE)
    varstdmean<-c(meanvar,stdvar)
        #get the mean of all columns grouped by person and activity
    melted<-melt(testAndTrain,id=c("personID","activity","group"),measure.vars = varstdmean)
    casted<-dcast(melted,activity+personID~variable,mean)
    categoriesmean<-tbl_df(casted)
    return(categoriesmean)
}