# Reading David's project FAQ first is useful : https://class.coursera.org/getdata-007/forum/thread?thread_id=49

# directory structures and file names
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

# Should be approx 30%
nrow(test)/(nrow(test)+nrow(train))
# Should be approx 70%
nrow(train)/(nrow(test)+nrow(train))

# c/ Loading features and activity labels to have names
# -------------------------------------------------------
# Will be variable names (561)
features <- read.table(features_path, colClasses = c("numeric","character"), header = FALSE, comment.char = "")
activity <- read.table(activity_path, colClasses = c("numeric","character"), header = FALSE, comment.char = "")

subject_train_ids <- read.table(subject_train_path, colClasses = c("numeric"), col.names = c("Subject id"), header = FALSE, comment.char = "")
activity_train_ids <- read.table(y_train_path, colClasses = c("numeric"), col.names = c("Activity id"), header = FALSE, comment.char = "")

subject_test_ids <- read.table(subject_test_path, colClasses = c("numeric"), col.names = c("Subject id"), header = FALSE, comment.char = "")
activity_test_ids <- read.table(y_test_path, colClasses = c("numeric"), col.names = c("Activity id"), header = FALSE, comment.char = "")

# Merges the training and the test sets to create one data set.
#first add the  subject ids, then the activity ids
test <- cbind(test,subject_test_ids,activity_test_ids)
train <- cbind(train,subject_train_ids,activity_train_ids)
#finally the big merge
all_data <- rbind(test,train)

#name the columns
names(all_data) <- c(features[,2],"Subject id","Activity id")

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# 3. Uses descriptive activity names to name the activities in the data set
# As stated in the code book of the data provided (README.txt) the table linking activity names to thier ids is in activity_labels.txt


# 4. Appropriately labels the data set with descriptive variable names.

# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject. Please
# upload the tidy data set created in step 5 of the instructions. Please upload
# your data set as a txt file created with write.table() using row.name=FALSE
# (do not cut and paste a dataset directly into the text box, as this may cause
# errors saving your submission).

