# GettingCleaningDataCoursera
Final Assignment for Coursera Getting and Cleaning Data Course
The objective of this assignment is to download and create a tiny dataset based on an existing dataset.

tidyscript.R is the resulting script from this assignment. The script does the following
1) Downloads the data into a zip file from the source website.
2) loads train and test data separately, then combines them into one dataframe using rbind.
3) columns of interest are selected from the larger dataframe. For the assignment, the mean and standard deviation columns are of interest. grep was used to select the columns of interest.
4) the reduced dataset is saved as data.selected
5) descriptive activity headers are read into the data.selected dataframe
6) variables are given descriptive names using gsub
7) the selected columns are then aggregated by test subject using aggregate
8) the mean value for each of the selected columns is calculated for each subject using aggregate
9) the resulting tidy dataset is saved as data_tidy, a txt file
