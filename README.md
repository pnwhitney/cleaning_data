**run_analysis.R**
==================
The enclosed implementation of run_analysis.R contains a top level
function aptly called "run_analysis". This function invokes a series of
other functions all implemented in the same file. Each lower level function
executes one piece of the overall functionality in order to complete the entire
assignment. It should be rather easy to read the assignment and identify what each
function does as each step is a step called out in the assignment.
Each function is detailed further below:

*mean_set*
----------
# Create the groups and aggregations for the activity / subject groups
# Also assigns reasonable names for each data frame column

*set_factor_names*
------------------
# Sets the factor names. These names came from the activities_labels.txt file

*extract_mean_and_std*
----------------------
# Sets only the desired columns for the tidy data set


*merge_data_sets*
-----------------
# Merges the training and test data sets

*training_set*
# Reads the training data set from the source file and also reads the subject_id and
# activity_ids for the training data set

*test_set*
----------
# Reads the test data set from the source file and also reads the subject_id and
# activity_ids for the test data set
 