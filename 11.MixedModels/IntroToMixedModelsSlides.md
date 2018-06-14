<style>
.section {
    color: black;
    background: #E9E8E8;
    position: fixed;
    text-align:center;
    width:100%;
}
</style>
<style>
.small-code pre code {
  font-size: 1em;
}
</style>
Introduction to linear mixed models
========================================================
author: timotheenivalis.github.io
date: June 15 2018
autosize: true
font-family: 'Helvetica'

Example: hidden relationships
========================================================
class: small-code


```r
thorns <- read.table(file = "thorndata.txt", header=TRUE)
```


```r
plot(thorns$response, x=thorns$predictor, ylab = "Herbivory load", xlab= "Thorn density")
abline(lm(response~ predictor, data=thorns), lwd=5, col="gray")#this is a shortcut to draw a regression line
```

![plot of chunk unnamed-chunk-2](IntroToMixedModelsSlides-figure/unnamed-chunk-2-1.png)


Example: hidden relationships
========================================================
class: small-code


```r
lmthorns <- lm(response~ predictor, data=thorns)
summary(lmthorns)
```

```

Call:
lm(formula = response ~ predictor, data = thorns)

Residuals:
     Min       1Q   Median       3Q      Max 
-2.11617 -0.51831  0.08215  0.54349  1.51932 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   3.2564     0.2854   11.41  < 2e-16 ***
predictor     0.2524     0.0717    3.52 0.000657 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.7252 on 98 degrees of freedom
Multiple R-squared:  0.1122,	Adjusted R-squared:  0.1032 
F-statistic: 12.39 on 1 and 98 DF,  p-value: 0.0006566
```

Example: hidden relationships
========================================================


```r
plot(lmthorns, which=1)
```

![plot of chunk unnamed-chunk-4](IntroToMixedModelsSlides-figure/unnamed-chunk-4-1.png)

Example: hidden relationships
========================================================
class: small-code
*Simpson's paradox*


```r
plot(thorns$predictor, thorns$response, col=thorns$block, ylab = "Herbivory load", xlab= "Thorn density")
abline(lm(response~ predictor, data=thorns), lwd=5, col="gray")
```

![plot of chunk unnamed-chunk-5](IntroToMixedModelsSlides-figure/unnamed-chunk-5-1.png)

Example: hidden relationships
========================================================
class: small-code

Fixed-effect correction

```r
summary(lm(response~ predictor + as.factor(block), data=thorns))
```

```

Call:
lm(formula = response ~ predictor + as.factor(block), data = thorns)

Residuals:
     Min       1Q   Median       3Q      Max 
-1.68769 -0.28889  0.04982  0.24924  1.39683 

Coefficients:
                  Estimate Std. Error t value Pr(>|t|)    
(Intercept)         6.0471     0.3872  15.617  < 2e-16 ***
predictor          -0.9752     0.1414  -6.899 6.02e-10 ***
as.factor(block)2   0.9400     0.1762   5.334 6.62e-07 ***
as.factor(block)3   1.9958     0.2147   9.295 5.80e-15 ***
as.factor(block)4   2.9706     0.2812  10.562  < 2e-16 ***
as.factor(block)5   3.7674     0.4219   8.929 3.48e-14 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.4875 on 94 degrees of freedom
Multiple R-squared:  0.6151,	Adjusted R-squared:  0.5947 
F-statistic: 30.05 on 5 and 94 DF,  p-value: < 2.2e-16
```

Example: hidden relationships
========================================================
class: small-code


```r
library(lme4)
thornLMM <- lmer(response ~ predictor + (1|block), data = thorns)
summary(thornLMM)
```

```
Linear mixed model fit by REML ['lmerMod']
Formula: response ~ predictor + (1 | block)
   Data: thorns

REML criterion at convergence: 165.3

Scaled residuals: 
    Min      1Q  Median      3Q     Max 
-3.4884 -0.6059  0.1091  0.5234  2.8735 

Random effects:
 Groups   Name        Variance Std.Dev.
 block    (Intercept) 2.129    1.4590  
 Residual             0.238    0.4878  
Number of obs: 100, groups:  block, 5

Fixed effects:
            Estimate Std. Error t value
(Intercept)   7.7652     0.8441   9.199
predictor    -0.9189     0.1385  -6.633

Correlation of Fixed Effects:
          (Intr)
predictor -0.632
```


Example: hidden relationships
========================================================
class: small-code
![plot of chunk unnamed-chunk-8](IntroToMixedModelsSlides-figure/unnamed-chunk-8-1.png)

Exercise: more hidden relationships
========================================================
type: prompt

Load the data _thornsmanylocations.txt_

Compare **lm()** and **lmer()** corrections for block.



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

Residuals and random effects
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


Random effects are cool because:
* More efficient than estimating many independent fixed effects
* Avoid distration from many coefficients and p-values
* Test effect of grouping variable as one parameter
* Variance components biologically interesting (e.g. repeatability $V_I/(V_I+V_R)$)


Testing random effects significance
========================================================
type: section

Likelihood Ratio Test (LRT)
========================================================
class: small-code

Comparison of two nested models. Ratio of likelihood $\sim \chi^2$


```r
thornLMM <- lmer(response ~ predictor + (1|block), data = thorns)
thornLM <- lm(response ~ predictor, data = thorns)
anova(thornLMM, thornLM) # the mixed model MUST GO FIRST
```

```
Data: thorns
Models:
thornLM: response ~ predictor
thornLMM: response ~ predictor + (1 | block)
         Df    AIC    BIC   logLik deviance  Chisq Chi Df Pr(>Chisq)    
thornLM   3 223.50 231.31 -108.749   217.50                             
thornLMM  4 172.05 182.47  -82.027   164.05 53.445      1   2.66e-13 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```



Exercise: LRT p-value distribution
========================================================
type: prompt

One simulation with a random effect that has no effect

```r
set.seed(1234)
RandomVariance <- 0
sampsize <- 200
x <- rnorm(sampsize,mean = 4, sd=0.25)
nbblocks <- 50
block <- sample(x = 1:nbblocks, size = sampsize, replace = TRUE)
blockvalues <- rnorm(n = nbblocks, mean = 0, sd = sqrt(RandomVariance))
y <- 8 - x + blockvalues[block] + rnorm(sampsize,0,1)
dat <- data.frame(response = y, predictor = x, block=block)
```


```r
lm0 <- lm(response ~ 1 + predictor, data=dat)
lmm0 <- lmer(response ~ 1 + predictor + (1|block), data=dat )
(LRT0 <- anova(lmm0, lm0)) #mixed model must come first!
LRT0$`Pr(>Chisq)`[2] # the p-value
```

Exercise: LRT p-value distribution
========================================================
type: prompt

**Replicate the simulations to obtain the distribution of p-values under the null-model of no variance**




A variance cannot be negative
========================================================
incremental: TRUE


```r
confint(lmm0) #Confidence interval
```

LRT are two sided tests / count one parameter per random effect
A random effect is half a parameter / to be tested with one-side tests

**Divide the p-values by two**

Same problem with AIC/BIC: count only half a parameter per random effect
**Remove one IC point per random effect**

NB: it is more complicated with random interactions; but the rule is to count half a parameter by variance parameter

Test / remove non-significant random effects?
========================================================
incremental: true

**Test ?**

* Yes if effect of interest
* Maybe if only a nuisance parameter

**Remove ?**

* Probably should keep if part of exp. design
* Doesn't matter much if non-significant
* Maybe remove if too many variables in exploratory analyses

Beyond the random intercept
========================================================
type: section

Random interactions, random slopes...
========================================================

![plot of chunk unnamed-chunk-24](IntroToMixedModelsSlides-figure/unnamed-chunk-24-1.png)

Random interactions, random slopes...
========================================================

![plot of chunk unnamed-chunk-25](IntroToMixedModelsSlides-figure/unnamed-chunk-25-1.png)

Random interactions, random slopes...
========================================================

"Random interaction" predictor:block = "random slope" = "random regression"

```r
lmer(response ~ 1 + predictor + (1+predictor|block), data=thorns)
```

Blocks allowed to differ in intercept and slopes

Fits 2 variances and 1 covariance



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
