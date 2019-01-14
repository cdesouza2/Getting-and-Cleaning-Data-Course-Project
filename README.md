# Getting-and-Cleaning-Data-Course-Project

The main file in this repository is run_analysis.R.
The purpose of the analysis performed by the R code in this file is:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In order to run the code in this file, the following must be performed
1. The "dplyr" package must be installed and loaded
2. The downloaded data (from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) must be unzipped to a sub-directory: "UCI HAR Dataset" in the current working directory.

After running the code in this file, a tidy data summary file called "tidy_data_summary" is produced in the current working directory, and contains the output from step 5 above.
