
library("RTextTools")
data <- read.delim("/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/clean-cpc-ta4R.txt",sep=",")
dim(data)

cpc1 <- as.vector(apply(as.matrix(data[1], mode="character"),1,paste,"cpc1",sep="",collapse=""))
cpc2 <- as.vector(apply(as.matrix(data[2], mode="character"),1,paste,"cpc2",sep="",collapse=""))
cpc3 <- as.vector(apply(as.matrix(data[3], mode="character"),1,paste,"cpc3",sep="",collapse=""))

training_data <- cbind(data[4], cpc1, cpc2, cpc3)

# [OPTIONAL] SUBSET YOUR DATA TO GET A RANDOM SAMPLE
training_data <- training_data[sample(1:799,size=600,replace=FALSE),]
training_codes <- training_data[1]
training_data <- training_data[-1]

matrix <- create_matrix(training_data, language="english", removeNumbers=FALSE, stemWords=FALSE, removePunctuation=FALSE, weighting=weightTfIdf)

# CREATE A container THAT IS SPLIT INTO A TRAINING SET AND A TESTING SET
# WE WILL BE USING t(training_codes) AS THE CODE COLUMN. WE DEFINE A 400
# ARTICLE TRAINING SET AND A 200 ARTICLE TESTING SET.

container <- create_container(matrix,t(training_codes),trainSize=1:400, testSize=401:600,virgin=FALSE)

# THERE ARE TWO METHODS OF TRAINING AND CLASSIFYING DATA.
# ONE WAY IS TO DO THEM AS A BATCH (SEVERAL ALGORITHMS AT ONCE)
models <- train_models(container, algorithms=c("MAXENT","SVM"))
results <- classify_models(container, models)


##TODO - NEED TO FIX analytics - 17June
# VIEW THE RESULTS BY CREATING ANALYTICS
analytics <- create_analytics(container, results)
#BUGGY ANALYTICS. - Wrote py script for now. 

