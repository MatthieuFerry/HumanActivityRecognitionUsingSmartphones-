# Reading David's project FAQ first is useful : https://class.coursera.org/getdata-007/forum/thread?thread_id=49

# directory structures and file names
# here I have the UCI HAR Dataset directory under my current working directory
data_directory  <- "UCI HAR Dataset"
train_directory <- "train"
test_directory  <- "test"

train_file      <- "X_train.txt"
test_file       <- "X_test.txt"

train_labels    <- "y_train.txt"
test_labels     <- "y_test.txt"

subject_train   <- "subject_train.txt"
subject_test    <- "subject_test.txt"

y_train         <- "y_train.txt"
y_test          <- "y_test.txt"

features_file   <- "features.txt"
activity_file   <- "activity_labels.txt"

train_set_path <- paste(data_directory, train_directory, train_file, sep="/")
test_set_path  <- paste(data_directory, test_directory, test_file,   sep="/")

y_train_path   <- paste(data_directory, train_directory, y_train, sep="/")
y_test_path    <- paste(data_directory, test_directory, y_test,   sep="/")

subject_train_path <- paste(data_directory, train_directory, subject_train, sep="/")
subject_test_path  <- paste(data_directory, test_directory, subject_test,   sep="/")

features_path  <- paste(data_directory, features_file,  sep="/")
activity_path  <- paste(data_directory, activity_file,  sep="/")

# 1. Merges the training and the test sets to create one data set.

# a/ loading training set
# -------------------------

# To have a first look to the data without loading the huge file, we can set nrows=100 for example
nrows <- 100
train_first_look <- read.table(train_set_path, nrows=nrows, header = FALSE, dec = ".", fill = TRUE, comment.char = "")

#Classes of columns : as we saw in "R programming" mooc, Week1 in reading_data_I.pdf
classes_train <- sapply(train_first_look, class)
rm(train_first_look)

# Loading fulldataset, using the classes to speed up the process
train <- read.table(train_set_path, colClasses = classes_train, header = FALSE, dec = ".", comment.char = "")

# b/ loading test set
# -------------------------

test_first_look <- read.table(test_set_path, nrows=nrows, header = FALSE, dec = ".", fill = TRUE, comment.char = "")
classes_test <- sapply(test_first_look, class)
rm(test_first_look)

test <- read.table(test_set_path, colClasses = classes_test, header = FALSE, dec = ".", fill = TRUE, comment.char = "")

# c/ Loading features and activity labels to have names
# -------------------------------------------------------
# Will be variable names (561)
features <- read.table(features_path, colClasses = c("numeric","character"), col.names = c("Variable.id","Variable.Name"), header = FALSE, comment.char = "")

subject_train_ids <- read.table(subject_train_path, colClasses = c("numeric"), col.names = c("Subject.id"), header = FALSE, comment.char = "")
activity_train_ids <- read.table(y_train_path, colClasses = c("numeric"), col.names = c("Activity id"), header = FALSE, comment.char = "")

subject_test_ids <- read.table(subject_test_path, colClasses = c("numeric"), col.names = c("Subject.id"), header = FALSE, comment.char = "")
activity_test_ids <- read.table(y_test_path, colClasses = c("numeric"), col.names = c("Activity.id"), header = FALSE, comment.char = "")

# Merges the training and the test sets to create one data set.
# As stated by Hadley Wickham in "Tidy Data" :
# Fixed variables should come first, followed by measured variables, each ordered so that
# related variables are contiguous. Rows can then be ordered by the first variable, breaking
# ties with the second and subsequent (fixed) variables.

# first add the  subject ids, then the activity ids
test <- cbind(subject_test_ids,activity_test_ids,test)
train <- cbind(subject_train_ids,activity_train_ids,train)
#finally the big merge
all_data <- rbind(test,train)

#name the columns
names(all_data) <- c("Subject.id","Activity.id",features[,2])

#ordering the data by subject id then by activity id
all_data <- all_data[order(all_data$Subject.id,all_data$Activity.id),]

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_string <- "mean"
std_string <- "std"

# Removes all columns with name containing neither "mean" nor "std"
# grepl return TRUE if there is a match
for (i in seq_along(features$Variable.Name)) {
        if (!grepl(mean_string,features$Variable.Name[i]) & !grepl(std_string,features$Variable.Name[i])) {
               all_data[,features$Variable.Name[i]] <- NULL
        }
}

# 3. Uses descriptive activity names to name the activities in the data set
# As stated in the code book of the data provided (README.txt) the table linking activity names to thier ids is in activity_labels.txt

activity <- read.table(activity_path, colClasses = c("numeric","character"), col.names = c("Activity.id","Activity.Name"), header = FALSE, comment.char = "")

library(plyr)
all_data <- join(all_data, activity, by = "Activity.id")

# Removes not required anymore column Activity.id
all_data$Activity.id <- NULL

# 4. Appropriately labels the data set with descriptive variable names.
labels <- names(all_data)
labels <- labels[complete.cases(labels)]

#cleaning variable names
for (i in seq_along(labels)) {
        labels[i] <- gsub("mean","Mean",labels[i])
        labels[i] <- gsub("std","Std",labels[i])
        labels[i] <- gsub("\\()","",labels[i]) # '(' is a special character in regex so we need to escape it
        labels[i] <- gsub("-","",labels[i])
}

names(all_data) <- labels

# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject. Please
# upload the tidy data set created in step 5 of the instructions. Please upload
# your data set as a txt file created with write.table() using row.name=FALSE
# (do not cut and paste a dataset directly into the text box, as this may cause
# errors saving your submission).

tidy <- ddply(all_data, .(Subject.id, Activity.Name), numcolwise(mean))
# Tidy a bit more by prefixing Mean. to the variable names
#cleaning variable names
labels  <- names(tidy)
for (i in 3:length(labels)) { #skips the 2 first
        labels[i] <- paste0("Mean.",labels[i])
}
names(tidy) <- labels

write.table(tidy,"my_tidy_data_set.txt",row.name=FALSE)
