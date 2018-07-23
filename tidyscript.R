library(data.table)
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI HAR Dataset.zip')){
  download.file(fileurl,'./UCI HAR Dataset.zip', mode = 'wb')
  unzip("UCI HAR Dataset.zip", exdir = getwd())
}
#read in features folder
features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])

#read in datatrain folder
data.train.x <- read.table('./UCI HAR Dataset/train/X_train.txt')
data.train.activity <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
data.train.subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')

#read in datatest folder
data.test.x <- read.table('./UCI HAR Dataset/test/X_test.txt')
data.test.activity <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
data.test.subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

#turn datatrain into dataframe of subject, activity, x
data.train <-  data.frame(data.train.subject, data.train.activity, data.train.x)
names(data.train) <- c(c('subject', 'activity'), features)

#turn datatest into dataframe of subject, activity, x
data.test <-  data.frame(data.test.subject, data.test.activity, data.test.x)
names(data.test) <- c(c('subject', 'activity'), features)

#merge into one dataframe
data.combined <- rbind (data.train, data.test)

#extract only means and stdevs
selectedcols <- grep('mean|stdev', features)
data.selected <- data.combined[,c(1,2,selectedcols +2)]

#read in activity labels
activity.labels <-read.table('./UCI HAR Dataset/activity_labels.txt', header=FALSE)
activity.labels <-as.character(activity.labels[,2])
data.selected$activity <- activity.labels [data.selected$activity]

#replace variables with descriptive names
name.descrip <- names(data.selected)
name.descrip <- gsub("[(][)]", "",name.descrip)
name.descrip <- gsub("^t", "TimeDomain_", name.descrip)
name.descrip <- gsub("^f", "FrequencyDomain_", name.descrip)
name.descrip <- gsub("Acc", "Accelerometer", name.descrip)
name.descrip <- gsub("Gyro", "Gyroscope", name.descrip)
name.descrip <- gsub("Mag", "Magnitude", name.descrip)
name.descrip <- gsub("-mean-", "_Mean_", name.descrip)
name.descrip <- gsub("-std-", "_StandardDeviation_", name.descrip)
name.descrip <- gsub("-", "_", name.descrip)
names(data.selected) <- name.descrip

#create tidy output
data.clean <- aggregate(data.selected[,3:48], by = list(activity = data.selected$activity, subject = data.selected$subject),FUN = mean)
write.table(x = data.clean, file = "data_tidy.txt", row.names = FALSE)