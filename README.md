# gettingAndCleaningProject
directory created for "Getting and cleaning data" final project

Performed steps to clean data and obtain final dataset:

1) if they are not already existing, create folder /data, dowload zip file and unzip it
2) import all necessary tables
3) change variables names
4) extract only mean and std per each measurement
5) add "group" column to identify wether row comes from test group or train group
6) merge all tables in one
7) change the value of activity column values (to make the activity clear)
8) identify column with identifier and column with measures
9) cast the dataset to obtain the mean of all measurements columns grouped by person and activity
10)return this last dataset
