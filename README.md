# Course Project
## Coursera: Getting and Cleaning Data


Required to submit: 
1. a [tidy data set](../master/result.txt) as described below, 
2. a [link to a Github repository](https://github.com/matthewallison/gettingAndCleaningData) with your [script](../master/run_analysis.R) for performing the analysis, and 
3. a [code book](../master/CodeBook.md) that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 


Data for the project can be obtained [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).


Description of run_analysis.R:
* Lines 3-7: Download the zipped data and unzip
* Lines 8-20: Read in the test and training sets.  The "subject" and "y" data are added into the "X" sets as new columns.  Finally, the test and train sets are combined using rbind.
* Lines 24-28: Read in the features list.  Grep on the features for the indexes which contain a mean or standard deviation.  Extract those indexes from the whole set. Use cbind to add to the Subject and Activity columns.
* Lines 32-36: Change the activity names to the descriptions provided using sapply.
* Lines 40-48: Extract just the feature names used above.  Clean the names from special characters and make parts easier to understand.  Finally, put these new names into the data set as column headers.  Note "Activity" and "Subject" are left unchanged.
* Lines 53-63: Create a tidy data set with the average of each variable for each activity and each subject.  This solution uses reshape2::melt to make a long data set.  Then group by Activity, Subject, and the Variable, and use summarise to take the mean.  Alternatively, a wide tidy data set could be obtained using dcast (commented out).
* Line 64: Write a txt file created with write.table() using row.name=FALSE for submission.

