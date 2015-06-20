# main function which simply calls other functions to execute each step of the process
run_analysis <- function() {
    test_set <- test_set()
    training_set <- training_set()
    merge_data_sets <- merge_data_sets(training_set, test_set)
    extract_mean_and_std <- extract_mean_and_std(merge_data_sets)
    set_factor_names <- set_factor_names(extract_mean_and_std)
    mean_set <- mean_set(set_factor_names)
    write.table(mean_set, file = "./mean_set.txt", row.name = FALSE)
}

# Create the groups and aggregations for the activity / subject groups
# Also assignes reasonable names for each data frame column
mean_set <- function(data_set) {
    grouped_set <- group_by(data_set, activity_id, subject_id)
    grouped_mean <- aggregate(grouped_set[,3:81], list(grouped_set$activity_id, grouped_set$subject_id), mean)
    names(grouped_mean)[1] <- paste("activity_group")
    names(grouped_mean)[2] <- paste("subject_group")
    for(index in 3:81) {
        names(grouped_mean)[index] <- paste("mean_of", names(grouped_mean)[index], sep="_")
    }
    grouped_mean
}

# Sets the factor names. These names came from the activities_labels.txt file
set_factor_names <- function(data_set) {
    data_set$activity_id <- as.factor(data_set$activity_id)
    levels(data_set$activity_id) <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
    data_set
}

# Sets only the desired columns for the tidy data set
extract_mean_and_std <- function(merge_data_sets) {
    id_set <- subset(merge_data_sets, select=(names(merge_data_sets)[grep('*_id', names(merge_data_sets))]))
    mean_set <- subset(merge_data_sets, select=(names(merge_data_sets)[grep('*mean()*', names(merge_data_sets))]))
    std_set <- subset(merge_data_sets, select=(names(merge_data_sets)[grep('*std()*', names(merge_data_sets))]))
    extract_mean_and_std <- cbind(id_set, mean_set, std_set)
}

# Merges the training and test data sets
merge_data_sets <- function(training_set, test_set) {
    # Note that each of the two data sets have distinct subject ids!
    # As a result the two data sets can simply be appended to join
    # the two data sets.
    merge_data_sets <- rbind(training_set, test_set)
}

# Reads the training data set from the source file and also reads the subject_id and
# activity_ids for the training data set
training_set <- function() {
    training_subjects <- read.csv("./train/subject_train.txt", header = FALSE)
    colnames(training_subjects) <- c("subject_id")
    training_activity <- read.csv("./train/y_train.txt", header = FALSE)
    colnames(training_activity) <- c("activity_id")
    classes <- c(replicate(561, "numeric"))
    training_data <- read.table("./train/X_train.txt", header = FALSE, colClasses = classes)
    labels <- read.delim("./features.txt", sep=" ", header = FALSE)
    colnames(training_data) <- as.vector(labels[[2]])
    training_set <- cbind(training_subjects, training_activity, training_data)
}

# Reads the test data set from the source file and also reads the subject_id and
# activity_ids for the test data set
test_set <- function() {
    test_subjects <- read.csv("./test/subject_test.txt", header = FALSE)
    colnames(test_subjects) <- c("subject_id")
    test_activity <- read.csv("./test/y_test.txt", header = FALSE)
    colnames(test_activity) <- c("activity_id")
    classes <- c(replicate(561, "numeric"))
    test_data <- read.table("./test/X_test.txt", header = FALSE, colClasses = classes)
    labels <- read.delim("./features.txt", sep=" ", header = FALSE)
    colnames(test_data) <- as.vector(labels[[2]])
    test_set <- cbind(test_subjects, test_activity, test_data)
}