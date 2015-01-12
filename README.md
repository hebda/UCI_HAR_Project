This repository provides a script run_analysis.R which is used to complete the five tasks of the project.
The script run_analysis.R:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The product of the script is a file smartphone_summary.txt, which contains the table created from step 5.
It is written to the same directory as run_analysis.R.

Before execution, the data must be in the same directory as run_analysis.R. To get the data, do:
wget https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
unzip getdata%2Fprojectfiles%2FUCI\ HAR\ Dataset.zip
rm getdata%2Fprojectfiles%2FUCI\ HAR\ Dataset.zip

To run the script, it suffices to execute:
R CMD BATCH run_analysis.R

The output can be viewed in R with:
data <- read.table('smartphone_summary.txt', header = TRUE)
View(data)

CodeBook.md descibes the input and output data, including transformations applied and units.
