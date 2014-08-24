Getting and Cleaning Data Course Project
========================================
This file describes how run_analysis.R script works.
1. Unzip the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and place in the data folder in the working directory.

2. Source("run_analysis.R") command in RStudio. 
3. Two output files are generated in the data file in the current working directory:
  - merged_data.txt: contains a data frame called cleanData 
  - data_with_means.txt: contains a data frame called result.
4. Use data <- read.table("data_with_means.txt") command in RStudio if you want to read the file. There are a total of 6 activities and 30 subjects in the table.