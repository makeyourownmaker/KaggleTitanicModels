
# Install caret and all of it's dependencies:
#install.packages('caret', dependencies = c("Depends", "Suggests"))

library(caret)


# Get all model names for classification
m <- unique(modelLookup()[modelLookup()$forClass, "model"])
length(m)

# Remove slow/failing classification methods
removeModels <- c("AdaBag","AdaBoost.M1","bam","pda2","dwdRadial","rbf",
                  "dwdLinear","dwdPoly","gaussprLinear","gaussprPoly",
                  "rFerns","sddaLDA","smda","sddaQDA","xgbLinear","xgbTree",
                  "AdaBag","FH.GBML","ORFsvm","ownn","vbmpRadial","SLAVE",
                  "ORFlog","GFS.GCCL","ORFpls","snn","bagEarth","ORFridge",
                  "rmda","awnb","awtan","manb","nbDiscrete","nbSearch",
                  "ordinalNet","blackboost","tan","tanSearch","randomGLM",
                  "Rborist","FRBCS.W","FRBCS.CHI","evtree","bstTree",
                  "bagEarthGCV","bagFDA","rrlda","rfRules","rpartScore",
                  "adaptDA","CHAID","sparsediscrim","elmNN","FCNN4R",
                  "mxnet","PRIM","adaboost","RRF","amdai","chaid","dda",
                  "elm","hdrda","mlpSGD","msaenet","mxnetAdam","rlda")

m <- m[!m %in% removeModels]
length(m)
m

# Pre-load all packages (only partially works due to dependency issues etc)
suppressPackageStartupMessages(ll <- lapply(m, require, character.only = TRUE))

# Show which libraries are loaded  
sessionInfo()


###################################################################################################
# X and Y for train function
Y <- train$Survived
X <- subset(train, select=-c(Survived))


# This function actually calls caret::train
trainCall <- function(i) {
  cat("----------------------------------------------------\n");
  cat(date(), "\n", i, "\n")
  set.seed(123)

  return(
  tryCatch(t2 <- train(y=as.factor(Y), x=X, (i), trControl = trainControl(method = "cv")),
	       error = function(e) NULL)
  )
}


###################################################################################################
# Register parallel front-end
library(doParallel)
cl <- makeCluster(detectCores())
registerDoParallel(cl)

# Use lapply to run training, required for try/catch error function to work
# Will probably run for an hour or two
# Add slow/failing methods to removeModels list above
# Check periodically for install dependency messages
system.time(t3 <- lapply(m, trainCall)) # Approx. 1 hour on old dual core laptop


# Stop cluster and register sequntial front end
stopCluster(cl)
registerDoSEQ()


###################################################################################################

# Remove NULL values, we only allow succesful methods
t4 <- t3[!sapply(t3, is.null)]
length(t3)
length(t4)


# Create training performance summary
trainSummary <- function(t4) {
  MAX <- length(t4);
  x1 <- character(MAX) # Method
  x2 <- numeric(MAX)   # Accuracy
  x3 <- numeric(MAX)   # Kappa
  x4 <- numeric(MAX)   # Run time (secs)
  x5 <- character(MAX) # Long model name
   
  for (i in 1:MAX) {
      x1[i] <- t4[[i]]$method
      x2[i] <- as.numeric(round(getTrainPerf(t4[[i]])$TrainAccuracy, 4))
      x3[i] <- as.numeric(round(getTrainPerf(t4[[i]])$TrainKappa, 4))
      x4[i] <- as.numeric(t4[[i]]$times$everything[3])
      x5[i] <- t4[[i]]$modelInfo$label
  }
  
  df1 <- data.frame(x1, x2, x3, x4, x5, stringsAsFactors=FALSE)
  colnames(df1) <- c("method", "accuracy", "kappa", "runtime", "longname")

  return(df1)
}

df1 <- trainSummary(t4)

head(df1[order(-df1$accuracy),], 20)
head(df1[order(-df1$kappa),], 20)
head(df1[order(df1$runtime),], 20)

# Row numbers from df1 can be used to index individual method training results
xgbDART.rownum <- as.numeric(rownames(df1[df1$method == "xgbDART",]))
confusionMatrix(t4[[xgbDART.rownum]])

xgbDART.fit <- t4[[xgbDART.rownum]]$finalModel

