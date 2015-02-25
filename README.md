## Introduction
To preface, I have chosen to organize my data in wide form. This script requires the qdap, reshape2, and plyr libraries.

I have 3 relevant files in this repo plus this README:
<ol>
<li><b>codebook.txt</b>: Text file describing the 81 variables. The 'activity' and 'subject_id' variables each have their own description, while the other 79 variables have been grouped together with one summary description </li>
<li><b>tidydata.txt</b>: Text file with my tidy data created with write.table() using row.name=FALSE</li>
<li><b>run_analysis.R</b>: R script with the code for performing my analysis that can be run as long as the Samsung data is in the working directory. The output is my tidy data set in a text file named tidydata.txt</li>
</ol>

##Script Description
I have chosen to perform the 5 steps in the rubric out of order (1,4,2,3,5). Specifically, I perform step 4 immediately after step 1 so that I don't have to extract the desired columns and column names separately from the combined data set and features.txt.

* The first thing I do is unzip the data.

<b>TASK 1</b>:
* I then read in the data sets, activity labels, and subject ids for both train and test. 
* Since there is no common identifier, I am assuming the row numbers match up.
* I add the activity lablels and subject ids as columns to the data sets for train and test.
* I then add the labeled test data set to the last row of the labeled train data set using rbind.

<b>TASK 4</b>:
* I read in the features.txt file
* I create a character vector to store the column names and put activity and subject_id in the first two elements since these are not in the feature.txt file. I then add all the descriptive variable names from the second column of the data frame created from features to my column name vector.
* I assign my descriptive variable name vector to the column names of my combined data set.

<b>TASK 2</b>:
* I use grep to find the indices of all the column names in my combined data set that have mean or std in them (I specifically include the meanFreq and angle related variables as they are inputs into the angle variables) and put them in a vector. This results in 79 variables.
* I add columns 1 & 2 to the vector because I also want to keep the activity and subject id.
* I subset the combined data using the vector of column indices into a new data frame

<b>TASK 3</b>:
* I read in the activity labels.
* Using mgsub in the qdap library, I replace all the activity numerical identifiers with descriptive labels.

<b>TASK 5</b>:
* I use melt to reshape the data such that every row is one observation of every combination of activity+subject_id+variable and store this in a new data frame. My original data had 10,299 observations of 81 variables. I melt the data with 2 id variables leaving 79 so I now have 10,299 x 79 = 813,621 rows in this new data frame. There are 4 columns: 3 identifying the activity+subject_id+variable and 1 with the value.
* In this form, I am able to use ddply to average all the observations of every combination of activity+subject_id+variable and store them in a new data frame. The data is now in tidy long form. There are 6 activities, 30 subjects, and 79 variables therefore there are 6 x 30 x 79 = 14,220 rows in this new data frame. There are 4 columns: 3 identifying the activity+subject_id+variable and 1 with the mean of all the observations of that activity+subject_id+variable combination.
* I use dcast to reshape the data into wide form where each variable is in one column and store it in a new data frame. There are 180 rows (6 activities x 30 subjects) and 81 columns (1 for activity, 1 for subject id, and 79 variables).
* Finally, I write the tidy wide form data to a text file.
