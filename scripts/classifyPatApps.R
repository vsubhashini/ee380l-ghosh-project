#Load patent and application data
patapps <- read.table("/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/pyAnalysisOutput/1kTopicDist4R.data", sep=",")
library("car")

#Do lda based on 15 topic compositions as features
patapps.lda <- lda(patapps$V1 ~ patapps$V2 + patapps$V3 + patapps$V4 + patapps$V5 + patapps$V6 + patapps$V7 +patapps$V8 + patapps$V9 + patapps$V10 + patapps$V11 + patapps$V12 + patapps$V13 +patapps$V14 + patapps$V15 + patapps$V16)

patapps.lda$scaling[,1]

standardisedconcentrations <- as.data.frame(scale(patapps[2:16]))
patapps.lda.values <- predict(patapps.lda, standardisedconcentrations)

##Stacked histogram of LDA values
jpeg('lda1-PA-stackHist.jpg')
ldahist(data = patapps.lda.values$x[,1], g=patapps$V1)
dev.off()
jpeg('lda2-PA-stackHist.jpg')
ldahist(data = patapps.lda.values$x[,2], g=patapps$V1)
dev.off()
jpeg('lda3-PA-stackHist.jpg')
ldahist(data = patapps.lda.values$x[,3], g=patapps$V1)
dev.off()

#scatterplot
jpeg('lda-PatApp-scatter12.jpg')
plot(patapps.lda.values$x[,1],patapps.lda.values$x[,2], pch=19, col=patapps$V1) # make a scatterplot
text(patapps.lda.values$x[,1],patapps.lda.values$x[,2],patapps$V1,pch=19,pos=4,col=patapps$V1) # add labels
dev.off()
jpeg('lda-PatApp-scatter13.jpg')
plot(patapps.lda.values$x[,1],patapps.lda.values$x[,3], pch=19, col=patapps$V1) # make a scatterplot
text(patapps.lda.values$x[,1],patapps.lda.values$x[,3],patapps$V1,pch=19,pos=4,col=patapps$V1) # add labels
dev.off()

## Let's get accuracy of classification if we used these means
confMatrix <- table(patapps$V1, patapps.lda.values$class)

## With uniform priors and cross-validation
patappsCV.lda <- lda(patapps$V1 ~ patapps$V2 + patapps$V3 + patapps$V4 + patapps$V5 + patapps$V6 + patapps$V7 +patapps$V8 + patapps$V9 + patapps$V10 + patapps$V11 + patapps$V12 + patapps$V13 +patapps$V14 + patapps$V15 + patapps$V16, CV=T, prior=rep(1,4)/4)
cvtab <- table(patapps$V1, patappsCV.lda$class)


#Create year-wise plots for convergence observations
patplot <- data.frame(ta=patapps.lda.values[1], l1=patapps.lda.values$x[,1], l2=patapps.lda.values$x[,2], l3=patapps.lda.values$x[,3], yr=patapps$V17, fileyr=patapps$V18)

#2005
jpeg('lda13-2005.jpg')
col2005 <- t(as.numeric(patplot$class[patplot$yr==2005]))
plot(patplot$l1[patplot$yr==2005], patplot$l3[patplot$yr==2005],xlim=c(-4,4), ylim=c(-4,4), pch=19, col=col2005)
text(patplot$l1[patplot$yr==2005], patplot$l3[patplot$yr==2005], pos=4,col=col2005) # add labels
dev.off()


library(ggplot2)

##LDA mis-classification plot
jpeg('misClass-lda.jpg')
LDApredict <- patapps.lda.values$class
TrueTechArea <- data$TA
qplot(patapps.lda.values$x[,1], patapps.lda.values$x[,2], xlim=c(-4,4), ylim=c(-4,4), colour=TrueTechAr, shape=LDApredict, data=data)
dev.off()


##QDA patApps
library(MASS)
patapps.qda <- qda(patapps$V1 ~ patapps$V3 + patapps$V4 + patapps$V5 + patapps$V6 + patapps$V7 +patapps$V8 + patapps$V9 + patapps$V10 + patapps$V11 + patapps$V12 + patapps$V13 +patapps$V14 + patapps$V15 + patapps$V16)

standardisedconcentrationsqda <- as.data.frame(scale(patapps[3:16]))

patapps.qda.values <- predict(patapps.qda, standardisedconcentrationsqda)

qdaTab <- table(patapps$V1, patapps.qda.values$class)
#Misclassified plot
jpeg('misClass-qda.jpg')
QDApredict <- patapps.qda.values$class
qplot(patapps.lda.values$x[,1], patapps.lda.values$x[,2], xlim=c(-4,4), ylim=c(-3,4.5), colour=TrueTechArea, shape=QDApredict, data=data)
dev.off()

##Directly using the names of the classes
data <- read.delim("/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/pyAnalysisOutput/1kTMdist4R.csv",sep="\t")
#LDA with jack knife cross validation
patapplda <- lda(TA ~ ., data, CV=TRUE)
ldaTab <- table(patapplda$class, data$TA)
TrueTechArea <- data$TA
#Misclassified plot
jpeg('misClass-loocv-lda.jpg')
LDApredict <- patapplda$class
qplot(patapps.lda.values$x[,1], patapps.lda.values$x[,2], xlim=c(-4,4), ylim=c(-3,4.5), colour=TrueTechArea, shape=LDApredict, data=data)
dev.off()

##SVM
library(e1071)
patappsvm <- svm(TA ~ ., data)
patappsvm.pred <- predict(patappsvm, data)
svmTab=table(patappsvm.pred, data$TA)
#Misclassification plot:
jpeg('misClass-svm.jpg')
SVMpredict <- patappsvm.pred
qplot(patapps.lda.values$x[,1], patapps.lda.values$x[,2], xlim=c(-4,4), ylim=c(-3,4.5), colour=TrueTechArea, shape=SVMpredict, data=data)
dev.off()

##Neural Net
library(nnet)
patappnet <- nnet(TA ~ ., data, size=1)
patappnet.pred <- predict(patappnet, data, type="class")
nnetTab <- table(patappnet.pred, data$TA)
#Misclassification plot:
jpeg('misClass-nnet.jpg')
NNETpredict <- patappnet.pred
qplot(patapps.lda.values$x[,1], patapps.lda.values$x[,2], xlim=c(-4,4), ylim=c(-3,4.5), colour=TrueTechArea, shape=NNETpredict, data=data)
dev.off()

