##Load patent data
pats <- read.table("/home/vsubhashini/courses/dm/ee380l-ghosh-project/data/pyAnalysisOutput/techAreaTopicDist4R.data",
          sep=",")
library("car")

##jpeg('scatterPlot.jpg')
##scatterplotMatrix(pats[2:6])
##dev.off()

##Plot topic 3 on x axis and topic 4 on y axis
##jpeg('2D-topicCorr-plots.jpg')
##text(pats$V4, pats$V5, pats$V1, cex=0.7, pos=4, col="red")
##dev.off()

##profilePlot function - shows the variation of each of the variables
##        -- not very good on this, because each topic has random correlations with the patents
##  makeProfilePlot <- function(mylist,names)
##  {
##     require(RColorBrewer)
##     # find out how many variables we want to include
##     numvariables <- length(mylist)
##     # choose 'numvariables' random colours
##     colours <- brewer.pal(numvariables,"Set1")
##     # find out the minimum and maximum values of the variables:
##     mymin <- 1e+20
##     mymax <- 1e-20
##     for (i in 1:numvariables)
##     {
##        vectori <- mylist[[i]]
##        mini <- min(vectori)
##        maxi <- max(vectori)
##        if (mini < mymin) { mymin <- mini }
##        if (maxi > mymax) { mymax <- maxi }
##     }
##     # plot the variables
##     for (i in 1:numvariables)
##     {
##        vectori <- mylist[[i]]
##        namei <- names[i]
##        colouri <- colours[i]
##        if (i == 1) { plot(vectori,col=colouri,type="l",ylim=c(mymin,mymax)) }
##        else         { points(vectori, col=colouri,type="l")                                     }
##        lastxval <- length(vectori)
##        lastyval <- vectori[length(vectori)]
##        text((lastxval-10),(lastyval),namei,col="black",cex=0.6)
##     }
##  }

##calling the profile plot function
##library(RColorBrewer)
##names <- c("V2","V3","V4","V5","V6")
##mylist <- list(pats$V2,pats$V3,pats$V4,pats$V5,pats$V6)
##jpeg('profilePlot.jpg')
##makeProfilePlot(mylist,names)
##dev.off()

## Calculate mean correlation for each topic
sapply(pats[2:16],mean)

## Calculate standard deviations for each topic
sapply(pats[2:16],sd)

## Calculate means and variance for each tech Area
## 1-Solar inverter; 2-Solar Mounting/Rack; 3-Solar Monitoring; 4-Site Assessment
patsInvertor <- pats[pats$V1=="1"]
patsMounting <- pats[pats$V1=="2"]
patsMonitorg <- pats[pats$V1=="3"]
patsSiteAsst <- pats[pats$V1=="4"]
## Calculate mean and variance for (each) tech area invertor
sapply(patsInvertor[2:16],mean)
sapply(patsInvertor[2:16],sd)

## A function that prints the means and variances by group for any generic data (when we don't know all the groups)
printMeanAndSdByGroup <- function(variables,groupvariable)
{
     # find the names of the variables
     variablenames <- c(names(groupvariable),names(as.data.frame(variables)))
     # within each group, find the mean of each variable
     groupvariable <- groupvariable[,1] # ensures groupvariable is not a list
     means <- aggregate(as.matrix(variables) ~ groupvariable, FUN = mean)
     names(means) <- variablenames
     print(paste("Means:"))
     print(means)
     # within each group, find the standard deviation of each variable:
     sds <- aggregate(as.matrix(variables) ~ groupvariable, FUN = sd)
     names(sds) <- variablenames
     print(paste("Standard deviations:"))
     print(sds)
     # within each group, find the number of samples:
     samplesizes <- aggregate(as.matrix(variables) ~ groupvariable, FUN = length)
     names(samplesizes) <- variablenames
     print(paste("Sample sizes:"))
     print(samplesizes)
}

## Call the above function to display the means and variances for each tech area
printMeanAndSdByGroup(pats[2:16],pats[1])

## Find correlation between topics 
cor.test(pats$V2, pats$V3)

## Print most highly correlated topics
mosthighlycorrelated <- function(mydataframe,numtoreport)
{
   # find the correlations
   cormatrix <- cor(mydataframe)
   # set the correlations on the diagonal or lower triangle to zero,
   # so they will not be reported as the highest ones:
   diag(cormatrix) <- 0
   cormatrix[lower.tri(cormatrix)] <- 0
   # flatten the matrix into a dataframe for easy sorting
   fm <- as.data.frame(as.table(cormatrix))
   # assign human-friendly names
   names(fm) <- c("First.Variable", "Second.Variable","Correlation")
   # sort and print the top n correlations
   head(fm[order(abs(fm$Correlation),decreasing=T),],n=numtoreport)
}

## run the above function to see which topics are most correlated (print top 10 highest correlations)
## The topics should have very poor correlation because they are meant to be different vectors
mosthighlycorrelated(pats[2:16], 10)

##Standardize variables - so that they are in the 0-1 range
standardisedconcentrations <- as.data.frame(scale(pats[2:16]))

## Do PCA
pats.pca <- prcomp(standardisedconcentrations)

## summarize the principal components' properties
summary(pats.pca)
##print standard devs
pats.pca$sdev

## Plot how many principal components to retain
jpeg('num_pc.jpg')
screeplot(pats.pca, type="lines")
dev.off()

## Weights for the principal components (how does the first principal component weighed w.r.t the 15 topics)
pats.pca$rotation[,1]

## Scatterplots of the principal components
jpeg('pca_scatter.jpg')
plot(pats.pca$x[,1],pats.pca$x[,2]) # make a scatterplot
text(pats.pca$x[,1],pats.pca$x[,2], pats$V1, cex=0.7, pos=4, col="red") # add labels
dev.off()

## To see the means for each principal component:
printMeanAndSdByGroup(standardisedconcentrations, pats[1])
## Should be able to notice that pc-1 can separate group 2 (Mounting/rack) from 1,3,4
## Check if 1 (Invertor) and 3 (Monitoring) can be separated by pc-2


## Do LDA
library("MASS")                                                # load the MASS package
pats.lda <- lda(pats$V1 ~ pats$V2 + pats$V3 + pats$V4 + pats$V5 + pats$V6 + pats$V7 +pats$V8 + pats$V9 + pats$V10 + pats$V11 + pats$V12 + pats$V13 +pats$V14 + pats$V15 + pats$V16)

## Describes the discriminant function (plane as a weighted combination of the other columns)
pats.lda
pats.lda$scaling[,1]

## Calculate separations achieved by the discriminant function
calcWithinGroupsVariance <- function(variable,groupvariable)
{
   # find out how many values the group variable can take
   groupvariable2 <- as.factor(groupvariable[[1]])
   levels <- levels(groupvariable2)
   numlevels <- length(levels)
   # get the mean and standard deviation for each group:
   numtotal <- 0
   denomtotal <- 0
   for (i in 1:numlevels)
   {
      leveli <- levels[i]
      levelidata <- variable[groupvariable==leveli,]
      levelilength <- length(levelidata)
      # get the standard deviation for group i:
      sdi <- sd(levelidata)
      numi <- (levelilength - 1)*(sdi * sdi)
      denomi <- levelilength
      numtotal <- numtotal + numi
      denomtotal <- denomtotal + denomi
   }
   # calculate the within-groups variance
   Vw <- numtotal / (denomtotal - numlevels)
   return(Vw)
}

calcBetweenGroupsVariance <- function(variable,groupvariable)
{
   # find out how many values the group variable can take
   groupvariable2 <- as.factor(groupvariable[[1]])
   levels <- levels(groupvariable2)
   numlevels <- length(levels)
   # calculate the overall grand mean:
   grandmean <- mean(variable)
   # get the mean and standard deviation for each group:
   numtotal <- 0
   denomtotal <- 0
   for (i in 1:numlevels)
   {
      leveli <- levels[i]
      levelidata <- variable[groupvariable==leveli,]
      levelilength <- length(levelidata)
      # get the mean and standard deviation for group i:
      meani <- mean(levelidata)
      sdi <- sd(levelidata)
      numi <- levelilength * ((meani - grandmean)^2)
      denomi <- levelilength
      numtotal <- numtotal + numi
      denomtotal <- denomtotal + denomi
   }
   # calculate the between-groups variance
   Vb <- numtotal / (numlevels - 1)
   Vb <- Vb[[1]]
   return(Vb)
}

calcSeparations <- function(variables,groupvariable)
{
   # find out how many variables we have
   variables <- as.data.frame(variables)
   numvariables <- length(variables)
   # find the variable names
   variablenames <- colnames(variables)
   # calculate the separation for each variable
   for (i in 1:numvariables)
   {
      variablei <- variables[i]
      variablename <- variablenames[i]
      Vw <- calcWithinGroupsVariance(variablei, groupvariable)
      Vb <- calcBetweenGroupsVariance(variablei, groupvariable)
      sep <- Vb/Vw
      print(paste("variable",variablename,"Vw=",Vw,"Vb=",Vb,"separation=",sep))
   }
}

## calcSeparations not working
pats.lda.values <- predict(pats.lda, standardisedconcentrations)
##calcSeparations(pats.lda.values$x,pats[1])

##Stacked histogram of LDA values
##jpeg('lda1-stackHist.jpg')
ldahist(data = pats.lda.values$x[,1], g=pats$V1)
##dev.off()
##jpeg('lda2-stackHist.jpg')
ldahist(data = pats.lda.values$x[,2], g=pats$V1)
##dev.off()
##jpeg('lda3-stackHist.jpg')
ldahist(data = pats.lda.values$x[,3], g=pats$V1)
##dev.off()

##Scatterplot of Discriminant Functions
## Seems like discriminants 1 and 3 are effective in separating the data
jpeg('lda13-scatterplot.jpg')
plot(pats.lda.values$x[,1],pats.lda.values$x[,3]) # make a scatterplot
text(pats.lda.values$x[,1],pats.lda.values$x[,3],pats$V1,cex=0.7,pos=4,col="red") # add labels
dev.off()

## Let's get accuracy of classification if we used these means
confMatrix <- table(pats$V1, pats.lda.values$class)
confMatrix

## With uniform priors:
patsUni.lda <- lda(pats$V1 ~ pats$V2 + pats$V3 + pats$V4 + pats$V5 + pats$V6 + pats$V7 +pats$V8 + pats$V9 + pats$V10 + pats$V11 + pats$V12 + pats$V13 +pats$V14 + pats$V15 + pats$V16, prior=rep(1,4)/4)
standardisedconcentrations <- as.data.frame(scale(pats[2:16]))
patsUni.lda.values <- predict(patsUni.lda, standardisedconcentrations)
ct_UniPrior <- table(pats$V1, patsUni.lda.values$class)                                                                              >ct_UniPrior

## With uniform priors and cross-validation
patsCV.lda <- lda(pats$V1 ~ pats$V2 + pats$V3 + pats$V4 + pats$V5 + pats$V6 + pats$V7 +pats$V8 + pats$V9 + pats$V10 + pats$V11 + pats$V12 + pats$V13 +pats$V14 + pats$V15 + pats$V16, CV=T, prior=rep(1,4)/4)
cv_tab <- table(pats$V1, patsCV.lda$class)
cv_tab
