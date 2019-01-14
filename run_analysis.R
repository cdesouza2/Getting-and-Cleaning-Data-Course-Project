## Code to perform analysis for Getting and Cleaning Data Course assignment.
## The purpose of this analysis is to do the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

## Assumes use of dplyr package - this should be installed and loaded

## Assumes the downloaded data (from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
## has been unzipped to a sub-directory: "UCI HAR Dataset" in the current working directory.
setwd("UCI HAR Dataset")

## Read in activity_labels text file, as a data frame with 2 columns: Code and Label
activity_labels <- read.table("activity_labels.txt",
                              stringsAsFactors = FALSE,
                              col.names = c("Code", "Label"))

## Read in features text file, as a data frame with 2 columns: Code and Label
feature_labels <- read.table("features.txt",
                             stringsAsFactors = FALSE,
                             col.names = c("Code", "Label"))

## Get the indices of those features which we are interested in - means and stdevs
reqd_features <- grep("(-mean|-std)", feature_labels$Label)

## Define a function for reading x, y and subject measurement data
## that can be re-used for either testing or training data.
read_measurement_data <- function(x_filename, y_filename, subject_filename) {
  
  ## Read in raw X data set, setting the column names to feature_labels
  x_data <- read.table(x_filename, stringsAsFactors = FALSE, col.names = feature_labels$Label)

  ## Read in raw Y data set, with the 1 column ActivityCode
  y_data <- read.table(y_filename, stringsAsFactors = FALSE, col.names = c("ActivityCode"))

  ## Read in raw subject data set, with the 1 column SubjectCode
  subject_data <- read.table(subject_filename, stringsAsFactors = FALSE, col.names = c("SubjectCode"))

  ## Convert x_data to a tbl_df, so can use dplyr functions
  x_df <- tbl_df(x_data)

  res_df <- x_df %>%
  select(reqd_features) %>% ## Now select from x_df only those features/variables of interest
  mutate(
    ActivityCode = y_data[row_number(), "ActivityCode"],    ## Add a column for ActivityCode, joining on row_number
    SubjectCode = subject_data[row_number(), "SubjectCode"] ## Add a column for SubjectCode, joining on row_number
  ) %>%
  mutate(
    ActivityLabel = activity_labels[ActivityCode, "Label"]  ## Add a column for ActivityLabel, joining on ActivityCode
  ) %>%
  select( -ActivityCode ) %>% ## Remove ActivityCode column as this is no longer required
  gather( key = "MeasureName", value = "MeasureValue", -SubjectCode, -ActivityLabel, na.rm = TRUE )
    ## gather measurement data into effectively key and value pairs

  as.data.frame(res_df)
}

## Initialise overall resulting data frame
overall_data <- data.frame(row.names = c("SubjectCode", "ActivityLabel", "MeasureName", "MeasureValue"))
str(overall_data)

## Process test data and concatenate to result
test_data <- read_measurement_data("test\\X_test.txt", "test\\Y_test.txt", "test\\subject_test.txt")
str(test_data)
overall_data <- rbind(overall_data, test_data)

## Process training data and concatenate to result
train_data <- read_measurement_data("train\\X_train.txt", "train\\Y_train.txt", "train\\subject_train.txt")
str(train_data)
overall_data <- rbind(overall_data, train_data)

## Check overall resulting data frame
str(overall_data)

## Now summarise data, to calculate the average of each measurement for each activity and each subject
data_summary <-
  tbl_df(overall_data) %>%
  group_by(SubjectCode, ActivityLabel, MeasureName) %>%
  summarise(MeasureAverage = mean(MeasureValue))
str(data_summary)

## Write data_summary to file
write.table(data_summary, "tidy_data_summary.txt", row.names = FALSE)
