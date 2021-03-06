

data = read.csv("C://Users/Stefan Stefanov/Documents/coursera/practical machine learning/project/data/training/pml-training.csv")
library(caret)
drops <- c("X",
"user_name",
"raw_timestamp_part_1",
"raw_timestamp_part_2",
"cvtd_timestamp",
"new_window",
"kurtosis_roll_belt",
"kurtosis_picth_belt",
"kurtosis_yaw_belt",
"skewness_roll_belt",
"skewness_roll_belt.1",
"skewness_yaw_belt",
"max_roll_belt",
"max_picth_belt",
"max_yaw_belt",
"min_roll_belt",
"min_pitch_belt",
"min_yaw_belt",
"amplitude_roll_belt",
"amplitude_pitch_belt",
"amplitude_yaw_belt",
"var_total_accel_belt",
"avg_roll_belt",
"stddev_roll_belt",
"var_roll_belt",
"avg_pitch_belt",
"stddev_pitch_belt",
"var_pitch_belt",
"avg_yaw_belt",
"stddev_yaw_belt",
"var_yaw_belt",
"var_accel_arm",
"avg_roll_arm",
"stddev_roll_arm",
"var_roll_arm",
"avg_pitch_arm",
"stddev_pitch_arm",
"var_pitch_arm",
"avg_yaw_arm",
"stddev_yaw_arm",
"var_yaw_arm",
"kurtosis_roll_arm",
"kurtosis_picth_arm",
"kurtosis_yaw_arm",
"skewness_roll_arm",
"skewness_pitch_arm",
"skewness_yaw_arm",
"max_roll_arm",
"max_picth_arm",
"max_yaw_arm",
"min_roll_arm",
"min_pitch_arm",
"min_yaw_arm",
"amplitude_roll_arm",
"amplitude_pitch_arm",
"amplitude_yaw_arm",
"kurtosis_roll_dumbbell",
"kurtosis_picth_dumbbell",
"kurtosis_yaw_dumbbell",
"skewness_roll_dumbbell",
"skewness_pitch_dumbbell",
"skewness_yaw_dumbbell",
"max_roll_dumbbell",
"max_picth_dumbbell",
"max_yaw_dumbbell",
"min_roll_dumbbell",
"min_pitch_dumbbell",
"min_yaw_dumbbell",
"amplitude_roll_dumbbell",
"amplitude_pitch_dumbbell",
"amplitude_yaw_dumbbell",
"var_accel_dumbbell",
"avg_roll_dumbbell",
"stddev_roll_dumbbell",
"var_roll_dumbbell",
"avg_pitch_dumbbell",
"stddev_pitch_dumbbell",
"var_pitch_dumbbell",
"avg_yaw_dumbbell",
"stddev_yaw_dumbbell",
"var_yaw_dumbbell",
"kurtosis_roll_forearm",
"kurtosis_picth_forearm",
"kurtosis_yaw_forearm",
"skewness_roll_forearm",
"skewness_pitch_forearm",
"skewness_yaw_forearm",
"max_roll_forearm",
"max_picth_forearm",
"max_yaw_forearm",
"min_roll_forearm",
"min_pitch_forearm",
"min_yaw_forearm",
"amplitude_roll_forearm",
"amplitude_pitch_forearm",
"amplitude_yaw_forearm",
"var_accel_forearm",
"avg_roll_forearm",
"stddev_roll_forearm",
"var_roll_forearm",
"avg_pitch_forearm",
"stddev_pitch_forearm",
"var_pitch_forearm",
"avg_yaw_forearm",
"stddev_yaw_forearm",
"var_yaw_forearm")
data_clean <- data[,!(names(data) %in% drops)]

#Check to see if the clean data does indeed have fewer columns
dim(data)
dim(data_clean)
any(is.na(data_clean))

nzv <- nearZeroVar(data_clean, saveMetrics=TRUE)
nzv1<- nzv[nzv$freqRatio >2,]	
keeps <- rownames(nzv1)
keeps <- c(keeps,"classe")
clean_data <- data[keeps]
dim(clean_data)
summary(clean_data)
#modFit <- train(classe~.,data=clean_data,method="rf")

#Divide the trainig data in training and testing to check how well the model performs
inTrain <- createDataPartition(y=clean_data$classe,p=0.8,list=FALSE)
training<- clean_data[inTrain,]
testing <- clean_data[-inTrain,]
modFit1  <- train(classe~.,data=training,method="rf")
a1<-confusionMatrix(testing$classe,predict(modFit1,testing))
a1
a2<-confusionMatrix(training$classe,predict(modFit1,training))
a2
 
# This just computes the accuracy (even though it is reported by the confusionMatrix command)
var1<-dim(testing)
sum(diag(a1$table))/var1[1]

#############################################################################
## Use PCA to reduce dimensionality and see if accuracy can be improved
inTrain <- createDataPartition(y=data_clean$classe,p=0.8,list=FALSE)
training<- clean_data[inTrain,]
testing <- clean_data[-inTrain,]
modFit2  <- train(classe~.,data=training,method="rf",preProcess="pca",thresh=0.9)
a3<-confusionMatrix(testing$classe,predict(modFit2,testing)) 
a3
a4<-confusionMatrix(training$classe,predict(modFit2,training))
a4
# Test to see what the dimensionality is when pca is used
#preProcValues <- preProcess(data_clean[,-54],method="pca",thresh=0.9)
#preProcValues

##############################################################################
#Apply model fits to actual testing data
testing_data = read.csv("C://Users/Stefan Stefanov/Documents/coursera/practical machine learning/project/data/testing/pml-testing.csv")
pred1 <- predict(modFit1,testing_data)
pred2 <- predict(modFit2,testing_data)
#Check differences
x11 <- pred1==pred2
x11

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}
# set working directory with setwd() and write files
#setwd(".../coursera/practical machine learning/project/answers")
#pml_write_files(pred1)
