#Peer assessment for Getting and Cleaning Data

------------  
Human Activity Recognition Using Smartphones Dataset
Author : Matthieu Ferry
Version : 1.0
------------  

All this project is about manipulating and tidying the data contained in the UCI HAR Dataset provided with this assignment.
UCI HAR Dataset contains its own CodeBook and Readme file, so I will only cover my own actions and files here.

How the script works includes more than the transformations to the variables. For example, your README might say, "Read these files in, combined them in this way, subsetted this using that, transformed these variables, changed an ordered list to a dataframe, wrote data-frame out using write.table". The README is much more concerned with how to use the computer to do the work and to look at the work.


The projet includes the following files:
=========================================

- 'README.md': this file

- 'run_analysis.R': R script manipulating UCI HAR Dataset to answer the questions of the assignment

- 'CodeBook.md': The Code Book for the assignment.

- 'my_tidy_data_set.txt': The tidy data set resulting of the 5th step of the assignment.

How the script 'run_analysis.R' works :
=========================================

Setup process
--------------
Fisrt I defined several variables relative to the file names and path, so they can be adjusted easily without interfering with loading instructions

Loading process
--------------
To speed up the loading of training and testing set, I loaded the first rows to look at the columns classes, then I loaded the full datasets.  
I loaded the subject and activity id for both test and training sets in distinct data frames 

Binding process
--------------
I column binded subject ids, activity ids and data for test data on one hand and traingin data on the other hand.  
Then I row binded the data to have a complete data set with both training and testing data.

Naming the columns
--------------
I added the names of the columns contained in the features.txt file

Extracting mean and std measurements
--------------
To Extract only the measurements on the mean and standard deviation for each measurement I scanned all the names of the variables and removed the columns of the dataset when the columns neither contained "mean" nor "std"

Use descriptive activity names
--------------
To use descriptive activity names to name the activities in the data set I first loaded the data of 'activity_labels.txt', the made a join on activity id and then removed the useless activity id columns

Descriptive variable names
--------------
To appropriately labels the data set with descriptive variable names I removed '()' and '-' charaters in the variable names and used uppercase to have 'Mean' instead of 'mean' and 'Std' instead of 'std'

Tidy data set
--------------
To creates a second, independent tidy data set I used ddply form plyr package to group by columns Subject.id and Activity.Name and apply the mean to the other variables.
I then recorded the tidy set in the 'my_tidy_data_set.txt' file.

The tidy set has 180 observation of 81 variables.