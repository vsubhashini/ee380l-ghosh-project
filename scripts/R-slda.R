library(tm)
library(topicmodels)
library(lda)
source <- DirSource("/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/patents/patsApps")

patappsCorpus <- Corpus(source, readerControl=list(reader=readPlain))
#patappsCorpus
#A corpus with 1068 text documents
finPatAppsCorpus <- tm_map(patappsCorpus, removeWords, stopwords("english"))
#preprare document term freq
dtm <- DocumentTermMatrix(finPatAppsCorpus)
#prepare in LDA-C format
patAppslda <- dtm2ldaformat(dtm, omit_empty=FALSE)
#get the supervised tech areas
annotation=patapps$V1

patapps.slda <- slda.em(patAppslda, 2, patAppslda$vocab, num.e.iterations=10, num.m.iterations=4, alpha=1.0, eta=0.1, annotation, params, variance=0.25, logistic=TRUE, lambda=1.0, method="sLDA")
