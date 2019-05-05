
# KaggleTitanicModels

![Lifecycle
](https://img.shields.io/badge/lifecycle-experimental-orange.svg?style=flat)
![R
%>%= 3.2.0](https://img.shields.io/badge/R->%3D3.2.0-blue.svg?style=flat)

Entry for the [Titanic: Machine Learning from Disaster](https://www.kaggle.com/c/titanic/) 
competition on [Kaggle](https://www.kaggle.com/).


## Requirements

R version 3.2.0 or higher.  

The [caret](http://topepo.github.io/caret/) package plus dependencies and 
suggestions.

The [rpart](https://cran.r-project.org/web/packages/rpart/index.html) 
package for feature engineering.

The [doParallel](https://cran.r-project.org/web/packages/doParallel/index.html)
package for parallelising training.

To install the required libraries in an R session:
```
install.packages("caret", dependencies = c("Depends", "Suggests"))
install.packages("rpart") # rpart should be installed with above command
install.packages("doParallel")
```


## Feature Engineering

Feature engineering is based on 
[Trevor Stephens' tutorial](https://trevorstephens.com/kaggle-titanic-tutorial/r-part-4-feature-engineering/).


## Modeling

Predictive models are built for most of the 
[caret classification methods](https://topepo.github.io/caret/available-models.html).

Ten fold cross-validation is used with a wide variety of classification methods 
including trees, rules, boosting, bagging, neural networks, linear modeling, 
discriminant analysis, generalised additive modeling, support vector machines, 
random forests, clustering etc.


## Results

Currently 97 classification methods run successfully.  A number of slow
and problematic methods were excluded.

One of the most accurate caret classification methods is avNNet which is one 
of the neural network methods from the venerable
[nnet](https://cran.r-project.org/web/packages/nnet/index.html) package.  
The Survived classes are reasonably balanced so accuracy is an acceptable
performance metric and it's the metric used on the 
[Kaggle leaderboard](https://www.kaggle.com/c/titanic/leaderboard).

Confusion matrix for avNNet method on 10-fold cross-validated training data:
```
Cross-Validated (10 fold) Confusion Matrix

(entries are percentual average cell counts across resamples)

          Reference
Prediction    0    1
         0 55.4  9.3
         1  6.2 29.1

 Accuracy (average) : 0.8452
```

Confusion matrix for avNNet method on Kaggle leaderboard data:
```
      0   1
  0 215  45
  1  52 106

               Accuracy : 0.7679
```

The 20 caret classification methods with highest 10-fold cross-validation 
accuracies for the Titanic competition are included in the table below:

    | method name       | accuracy | kappa  | runtime (secs) |
    |-------------------|----------|--------|----------------|
    | xgbDART           | 0.8452   | 0.6667 | 598.786        |
    | avNNet            | 0.8384   | 0.6475 | 71.991         |
    | wsrf              | 0.8384   | 0.6498 | 123.800        |
    | C5.0              | 0.8373   | 0.6496 | 15.838         |
    | C5.0Cost          | 0.8373   | 0.6496 | 25.714         |
    | deepboost         | 0.8363   | 0.6431 | 208.503        |
    | svmLinear2        | 0.8363   | 0.6475 | 92.594         |
    | svmLinearWeights  | 0.8363   | 0.6475 | 196.161        |
    | svmLinearWeights2 | 0.8362   | 0.6504 | 126.733        |
    | svmPoly           | 0.8351   | 0.6451 | 685.023        |
    | pda               | 0.8340   | 0.6442 | 3.151          |
    | sda               | 0.8340   | 0.6442 | 3.721          |
    | svmLinear         | 0.8340   | 0.6425 | 43.733         |
    | cforest           | 0.8329   | 0.6339 | 158.293        |
    | bagFDAGCV         | 0.8306   | 0.6362 | 144.936        |
    | gbm               | 0.8306   | 0.6354 | 9.717          |
    | nnet              | 0.8306   | 0.6317 | 13.312         |
    | glmnet            | 0.8295   | 0.6352 | 8.829          |
    | regLogistic       | 0.8295   | 0.6356 | 172.626        |
    | glmboost          | 0.8284   | 0.6333 | 10.090         |

Note: The xgbDART method has surprisingly bad performance on the Kaggle
leaderboard.


## Files

These files demonstrate how to build models for most of the supported caret classification methods:

 * [1-load.R](https://github.com/makeyourownmaker/KaggleTitanicModels/blob/master/1-load.R)
   * Literally just loads the data
 * [2-clean.R](https://github.com/makeyourownmaker/KaggleTitanicModels/blob/master/2-clean.R)
   * No cleaning this time!
   * There are quite a few missing values but some imputation is attempted in the feature engineering section
 * [3-feature-engineering.R](https://github.com/makeyourownmaker/KaggleTitanicModels/blob/master/3-feature-engineering.R)
   * Based on [Trevor Stephens' tutorial](https://trevorstephens.com/kaggle-titanic-tutorial/r-part-4-feature-engineering/)
 * [4-build-models.R](https://github.com/makeyourownmaker/KaggleTitanicModels/blob/master/4-build-models.R)
   * Uses 10-fold cross-validation with wide variety of caret classification methods
   * Some problematic and slower methods are excluded
 * [5-submission.R](https://github.com/makeyourownmaker/KaggleTitanicModels/blob/master/5-kaggle-submission.R)
   * Prepare CSV file for Kaggle submission
 * KaggleTitanicModels.RData
   * An R session image containing 97 successfully built classification methods
   * Large (by GitHub standards) file 84 MBs


## Installation/Usage

To install the required libraries in an R session:
```
install.packages("caret", dependencies = c("Depends", "Suggests"))
install.packages("rpart") # rpart should be installed with above command
install.packages("doParallel")
```

The R files can be ran in sequence or the R session image can be loaded.

Clone repository:
```
git clone https://github.com/makeyourownmaker/KaggleTitanicModels
cd KaggleTitanicModels
```

Either run files in sequence in an R session:
```
setwd("KaggleTitanicModels")
source("1-load.R", echo = TRUE)
source("2-clean.R", echo = TRUE)
source("3-feature-engineering.R", echo = TRUE)
source("4-build-models.R", echo = TRUE)
source("5-kaggle-submission.R", echo = TRUE)
```

Or load R session image in an R session:
```
setwd("KaggleTitanicModels")
load("KaggleTitanicModels.RData")
```


## Roadmap

* Fix some of the failing methods
  * Except any methods that depend on rJava
  * Except any methods not on CRAN which includes [mxnet](https://mxnet.apache.org/)
* Improve feature engineering
  * Neural networks and other methods would benefit from scaling and centering
  * Others have looked at adding a Cabin deck variable based on the Cabin column
  * Consider adding interaction terms
  * Additional passenger information is available from the [Encyclopedia Titanica](https://www.encyclopedia-titanica.org/)
* Add more detailed diagnostics for best performing methods
  * Resampling boxplots
  * ROC plots
* Re-order classification methods
  * By accuracy 
  * By run time
  * Or some compromise between the accuracy and run time
    

## Limitations

* Caret method limitations
  * Some of the caret methods only expose a subset of the tuning parameters 
    from the underlying libraries
  * Other caret methods are somewhat limited in the feature interactions they
    support
* I'm not going to build ensembles of models
  * Diminishing returns set in quickly (time would be better spent on feature 
    engineering)
  * [caretEnsemble](https://cran.r-project.org/web/packages/caretEnsemble/) is 
    a great library if your interested in that sort of thing


## Alternatives

* Kaggle Titanic repositories on github
  * [Search](https://github.com/search?q=kaggle+titanic)
  * [kaggle-titanic Topic](https://github.com/topics/kaggle-titanic)
* [Kaggle Titanic kernels on Kaggle](https://www.kaggle.com/c/titanic/kernels)
* [Titanic passenger list from Encyclopedia Titanica](https://www.encyclopedia-titanica.org/titanic-passenger-list/)


## Contributing

Pull requests are welcome.  For major changes, please open an issue first to discuss what you would like to change.


## License
[GPL-2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

