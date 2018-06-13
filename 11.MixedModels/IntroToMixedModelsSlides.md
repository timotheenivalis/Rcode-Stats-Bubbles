<style>
.section {
    color: black;
    background: #E9E8E8;
    position: fixed;
    text-align:center;
    width:100%;
}
</style>
Introduction to linear mixed models
========================================================
author: Timothée Bonnet
date: June 15 2018
autosize: true
font-family: 'Helvetica'

Example: hidden relationships
========================================================


Exercise: more hidden relationships
========================================================
type: prompt

What are random effects?
========================================================
type: section

Residuals and random effects
========================================================



Assumed variance-covariance matrix of the process that generates the residuals

|     | obs1| obs2| obs3| obs4| obs5|
|:----|----:|----:|----:|----:|----:|
|obs1 |    1|    0|    0|    0|    0|
|obs2 |    0|    1|    0|    0|    0|
|obs3 |    0|    0|    1|    0|    0|
|obs4 |    0|    0|    0|    1|    0|
|obs5 |    0|    0|    0|    0|    1|

*residuals are perfectly correlated with themselves, and independent of each-other*


Residuals and random effects
========================================================



If multiple measurements:

|     |     |obs1 |obs2 |obs3 |obs4 |obs5 |
|:----|:----|:----|:----|:----|:----|:----|
|     |     |ind1 |ind1 |ind2 |ind2 |ind3 |
|obs1 |ind1 |1    |1    |0    |0    |0    |
|obs2 |ind1 |1    |1    |0    |0    |0    |
|obs3 |ind2 |0    |0    |1    |1    |0    |
|obs4 |ind2 |0    |0    |1    |1    |0    |
|obs5 |ind3 |0    |0    |0    |0    |1    |

*among individuals, residuals are correlated with each-other*

Residuals and random effects: split the matrix to decompose the variance
========================================================
left: 35%


**Individual var-cov**

|     | ind1| ind2| ind3|
|:----|----:|----:|----:|
|ind1 |    1|    0|    0|
|ind2 |    0|    1|    0|
|ind3 |    0|    0|    1|
***
**Residual var-cov**



|     | obs1| obs2| obs3| obs4| obs5|
|:----|----:|----:|----:|----:|----:|
|obs1 |    1|    0|    0|    0|    0|
|obs2 |    0|    1|    0|    0|    0|
|obs3 |    0|    0|    1|    0|    0|
|obs4 |    0|    0|    0|    1|    0|
|obs5 |    0|    0|    0|    0|    1|


NB: phylogenies, spatial correlation, time-series, genetic similarity...
========================================================

...are mixed models with correlations across random effect levels (individuals, species, locations...)



|     |     |obs1 |obs2 |obs3 |obs4  |obs5  |
|:----|:----|:----|:----|:----|:-----|:-----|
|     |     |ind1 |ind1 |ind2 |ind3  |ind4  |
|obs1 |ind1 |1    |1    |0.25 |0     |0.01  |
|obs2 |ind1 |1    |1    |0    |0     |0     |
|obs3 |ind2 |0.25 |0    |1    |0     |0     |
|obs4 |ind3 |0    |0    |0    |1     |0.125 |
|obs5 |ind4 |0.01 |0    |0    |0.125 |1     |

Correlations represent **(co-)variation that is unexplained**, but is **related to a biological process**


Residuals and random effects
========================================================

$$
y_{ij} = \mu + \beta x_{ij} + u_i + \epsilon_{ij}
$$

with, residuals $\epsilon_{ij}\sim Normal(0,V_R)$ and individual random effect $u_{i}\sim Normal(0,V_I)$.


Variance components
========================================================



Testing random effects significance
========================================================
type: section

A variance cannot be negative
========================================================



Exercise
========================================================
type: prompt

Beyond the random intercept
========================================================
type: section

Random interactions, random slopes...
========================================================


Package demonstration
========================================================
type: section

Data
========================================================
type: prompt

Load data to experiment with various packages



```r
dat <- read.table(file = "datforpackagecomp.txt", header=TRUE)
```

The simulated variance among individual is 0.6.
The simulated effect of the predictor on the response is 0.2

lme4
========================================================

```r
library(lme4)
```


```r
mlme4 <- lmer(response ~ 1 + predictor + (1|individual), data=dat)
summary(mlme4)
```

glmmTMB
========================================================

```r
install.packages("glmmTMB")
```

```r
library(glmmTMB)
```


```r
mglmmtmb <- glmmTMB(response ~ 1 + predictor + (1|individual), data=dat)
summary(mglmmtmb)


MCMCglmm
========================================================
```

```r
install.packages("MCMCglmm")
```

```r
library(MCMCglmm)
```


```r
mmcmcglmm <- MCMCglmm(fixed = response ~ 1 + predictor,
                      random =  ~individual, data=dat)
summary(mmcmcglmm)
```

brms
========================================================

```r
install.packages("brms")
install.packages("shinystan")
```

```r
library(brms)
library(shinystan)
```


```r
mbrms <- brm(formula = response ~ 1 + predictor + (1|individual), data=dat)
summary(mbrms)
plot(mbrms)
launch_shinystan(mbrms)
```

INLA
========================================================

```r
install.packages("INLA", repos=c(getOption("repos"), INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)
```


```r
library(INLA)
```


```r
inla
```

Summary (based on personal exp.)
=======================================================



|Package      |Framework |Speed     |Flexibility |Syntax   |Doc              |
|:------------|:---------|:---------|:-----------|:--------|:----------------|
|**lme4**     |ML        |fast      |-           |lme4     |good             |
|**glmmTMB**  |ML        |fast+     |+           |lme4     |low              |
|**MCMCglmm** |Bayes     |very slow |++          |+/- lme4 |medium+ (formal) |
|**brms**     |Bayes     |slow      |+++         |lme4     |medium (blogs)   |
|**INLA**     |Bayes     |fast-     |++          |diff     |low              |




|Package      |Post_treatment        |Whims |Structure |
|:------------|:---------------------|:-----|:---------|
|**lme4**     |difficult             |few   |S4        |
|**glmmTMB**  |difficult             |some- |S3        |
|**MCMCglmm** |easy but manual       |few   |S3        |
|**brms**     |easy(?) and automated |some  |S3        |
|**INLA**     |medium and manual     |some+ |S3        |




Exercise: Compare the speed of the different packages
====================================================
type: prompt

And let me know what you find!

Hint:

```r
system.time()
```

Essential resources
====================================================

Ben Bolker FAQ:
http://bbolker.github.io/mixedmodels-misc/glmmFAQ.html
http://glmm.wikidot.com/start

Subscribe to mailing-list:
https://stat.ethz.ch/mailman/listinfo/r-sig-mixed-models

MCMCglmm:
https://cran.r-project.org/web/packages/MCMCglmm/vignettes/CourseNotes.pdf

brms:
https://paul-buerkner.github.io/blog/brms-blogposts/
