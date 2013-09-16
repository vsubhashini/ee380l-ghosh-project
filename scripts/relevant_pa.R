
#Using TM package

library("tm")
candidates <- c("unwanted", "relevant")
pathname <- "/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/patents/full10kList/relatedPatApps"
options(stringsAsFactors=FALSE)
#clean Text
cleanCorpus <- function(corpus) {
  corpus.tmp <- tm_map(corpus, removePunctuation)
  corpus.tmp <- tm_map(corpus.tmp, stripWhitespace)
  corpus.tmp <- tm_map(corpus.tmp, tolower)
  corpus.tmp <- tm_map(corpus.tmp, removeWords, stopwords("english"))
  corpus.tmp <- tm_map(corpus.tmp, removeNumbers)
  return(corpus.tmp)
}

#Build document-term matrix

generateDTM <- function(cand, path) {
 pat.Dir <- sprintf("%s/%s", path, cand)
 #pat.cor <- Corpus(DirSource(directory = pat.Dir, encoding = "ANSI"))
 pat.cor <- Corpus(DirSource(pat.Dir), readerControl = list(language = "en_US"))
 pat.cor.cl <- cleanCorpus(pat.cor)
 pat.dtm <- DocumentTermMatrix(pat.cor.cl)
 
 pat.dtm <- removeSparseTerms(pat.dtm, 0.3)
 result <- list(name = cand, dtm = pat.dtm)
}

dtm <- lapply(candidates, generateDTM, path = pathname)

#attach name

bindCandidateToDTM <- function(dtm) {
  pat.mat <- data.matrix(dtm[["dtm"]])
  pat.df <- as.data.frame(pat.mat, stringsAsFactors=FALSE)
  pat.df <- cbind(pat.df, rep(dtm[["name"]], nrow(pat.df)))
  colnames(pat.df)[ncol(pat.df)] <- "targetcandidate"
  return(pat.df)
}
candDTM <- lapply(dtm, bindCandidateToDTM)

# Stack

dtm.stack <- do.call(rbind.fill, candDTM)
dtm.stack[is.na(dtm.stack)] <- 0

#hold-out
train.idx <- sample(nrow(dtm.stack), ceiling(nrow(dtm.stack)*0.7))
test.idx <- (1:nrow(dtm.stack)) [- train.idx]

# model - kNN
dtm.cand <- dtm.stack[, "targetcandidate"]
dtm.stack.nl <- dtm.stack[, !colnames(dtm.stack) %in% "targetcandidate"]

knn.pred <- knn(dtm.stack.nl[train.idx, ], dtm.stack.nl[test.idx, ], dtm.cand[train.idx])

#accuracy

conf.mat <- table("Predictions"=knn.pred, Actual=dtm.cand[test.idx])

(accuracy <- sum(diag(conf.mat)) / length(test.idx) * 100)

#SVM
svmModel <- svm(as.factor(targetcandidate) ~ ., data=dtm.stack[train.idx, ])
pat.svmpred <- predict(svmModel)
confmat.svm <- table("Prediction"=pat.svmpred, "Actual"=dtm.cand[train.idx])
confmat.svm

#predicting on test data
pattest.svmpred <- predict(svmModel, dtm.stack.nl[test.idx, ])
confmat.svm <- table("Prediction"=pattest.svmpred, "Actual"=dtm.cand[test.idx])
confmat.svm
#          Actual
#Prediction relevant unwanted
#  relevant      260        0
#  unwanted       37     1545

#########################TDM - not necessary

#build term-document-matrix TDM

generateTDM <- function(cand, path) {
 pat.Dir <- sprintf("%s/%s", path, cand)
 #pat.cor <- Corpus(DirSource(directory = pat.Dir, encoding = "ANSI"))
 pat.cor <- Corpus(DirSource(pat.Dir), readerControl = list(language = "en_US"))
 pat.cor.cl <- cleanCorpus(pat.cor)
 pat.tdm <- TermDocumentMatrix(pat.cor.cl)
 #pat.dtm <- DocumentTermMatrix(pat.cor.cl)
 
 pat.tdm <- removeSparseTerms(pat.tdm, 0.6)
 #pat.dtm <- removeSparseTerms(pat.dtm, 0.2)
 result <- list(name = cand, tdm = pat.tdm)
}

tdm <- lapply(candidates, generateTDM, path = pathname)

#attach name

bindCandidateToTDM <- function(tdm) {
  pat.mat <- t(data.matrix(tdm[["tdm"]]))
  pat.df <- as.data.frame(pat.mat, stringsAsFactors=FALSE)
  pat.df <- cbind(pat.df, rep(tdm[["name"]], nrow(pat.df)))
  colnames(pat.df)[ncol(pat.df)] <- "targetcandidate"
  return(pat.df)
}

candTDM <- lapply(tdm, bindCandidateToTDM)

# Stack

tdm.stack <- do.call(rbind.fill, candTDM)
tdm.stack[is.na(tdm.stack)] <- 0

#hold-out
train.idx <- sample(nrow(tdm.stack), ceiling(nrow(tdm.stack)*0.7))
test.idx <- (1:nrow(tdm.stack)) [- train.idx]

# model - kNN
tdm.cand <- tdm.stack[, "targetcandidate"]
tdm.stack.nl <- tdm.stack[, !colnames(tdm.stack) %in% "targetcandidate"]

knn.pred <- knn(tdm.stack.nl[train.idx, ], tdm.stack.nl[test.idx, ], tdm.cand[train.idx])

#accuracy

conf.mat <- table("Predictions"=knn.pred, Actual=tdm.cand[test.idx])

(accuracy <- sum(diag(conf.mat)) / length(test.idx) * 100)

#SVM
svmModel <- svm(as.factor(targetcandidate) ~ ., data=tdm.stack[train.idx, ])
pat.svmpred <- predict(svmModel)
confmat.svm <- table("Prediction"=pat.svmpred, "Actual"=tdm.cand[train.idx])
confmat.svm

#predicting on test data
pattest.svmpred <- predict(svmModel, tdm.stack.nl[test.idx, ])
confmat.svm <- table("Prediction"=pattest.svmpred, "Actual"=tdm.cand[test.idx])
 confmat.svm
#          Actual
#Prediction relevant unwanted
#  relevant      234        0
#  unwanted       49     1559

###DTM part continuous try with lower sparse removal
