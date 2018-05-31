Statistical Power and Mixed Effect Models
========================================================
author: Timothée Bonnet
date: June 1st 2018
autosize: true
font-family: 'Helvetica'




What is power?
========================================================
incremental: true

<div align="center">
<img src="PowerAndLM-figure/fig1.jpg" width=700 height=437>
</div>

Probability to detect an effect **that exists for real**

= 1 - false negative rate (type II error)


Why should you think about statistical power?
========================================================
incremental: true

**Low power means:**
* **Statistical tests non-significant whether an effect exists or not**
* **Your results will be inconclusive**
* **Data collection and analyses are wasted** (_maybe not completely, there is a twist later on_)

**High power means:**
* **Test probably significant when an effect exists**
* **Test rarely significant when an effect does not exist**
* **You learn something about the world**

Think about power early and late
====================================
type: alert

**BEFORE planning experiment or data collection:**
* Can I get enough data to answer my question? Is it worth it?
* How to improve my chances of detecting an effect **if it exists**?

But also AFTER doing an analysis:
* Is this non-significant result due to a lack of power or to the absence of an effect?
* What is the maximal likely value of the effect? Is it still important biologically?


What power depends on
========================================================

**1. Sample size**

![plot of chunk unnamed-chunk-2](PowerAndLM-figure/unnamed-chunk-2-1.png)

What power depends on
========================================================

**2. Strength of the effect**

![plot of chunk unnamed-chunk-3](PowerAndLM-figure/unnamed-chunk-3-1.png)


What power depends on
========================================================

**3. Unexplained variation**

![plot of chunk unnamed-chunk-4](PowerAndLM-figure/unnamed-chunk-4-1.png)


Statistical power increases with
========================================================
type: prompt
incremental: true

* **Larger sample size** <- you can control
* **Smaller unexplained variability** <- you can sometimes control
* **Real strength of the effect of interest** <- you cannot control

We can estimate statistical power
========================================================
type: prompt
incremental: true

If we know or assume:
* A sample size
* Explained and unexplained sources of variation
* A real strength of the effect

Exercise 1: power calculated by sample size
========================================================

See file tempPA

We assume we know the data variability. How many samples to find a difference of 0.5?

Simple solution for simple cases: pwr package
========================================================

```r
library(pwr)
p40 <- pwr.t.test(n = 40, d = 0.5/1 )
p40$power
```

```
[1] 0.5981469
```

```r
p143 <- pwr.t.test(n = 143, d = 0.5/1 )
p143$power
```

```
[1] 0.9878887
```


Exercise 2: power calculated by sample size and effect size
========================================================
incremental: true

Try several values between zero and one for the assumed effect size in the simulations (pwr is allowed)

 Show how power varies with sample size and effect size



You did the experiment with a sample size 100 and did not find a significant result.
Let's assume a value less than 0.7 is biologically unimportant. Can you conclude something?

What if a value of 0.1 is still biologically important?

**Post-hoc power analysis**

What if unmeasure variation is not random?
========================================================
type: section

What is really the sample size?
========================================================

We have assumed observations to be **independent** in our simulations

Corresponds to an assumption of linear models

What if they are not?

A silly example 
=======================================================
incremental: true

Does size differ between people with a hair bun and people with a crest?

Only 2 individuals individuals => we take 50 measurements of each person

_t-test of the difference, p<0.0001..._

**In reality, the data contain no information because the measurements are perfectly dependent: Effective sample size is 2, question has 2 parameters.**

More realistic examples
=======================================================
incremental: true

Two bird populations, one supplemented with food. Measure reproductive success within populations, test the effect of food on reproduction.
Effective sample size?

**2, for 2 parameters => no information, no power**

300 mass measurements of 50 individuals. Does mass impact on lifetime reproductive success?
Effective sample size?

**50, for 2 parameters => some information / power**

More realistic examples
=======================================================
incremental: true

?

* Inference about individuals with multiple measurements of same individuals
* Inference about spatial variation with several measurements per site
* Inference about trait co-evolution within a phylogeny
* ...

Solution: model the correlation between observations
=======================================================

* With fixed effects for grouping factors
* or With a random effect in a mixed model

** package lme4 **

Exercise
=======================================================



* Load RepeatedMeasurements.csv (10 measurements per individual) and IndividualMeasurements.csv (1 measurement per individual)
* Do the two groups differ? (use lm() and lmer() to test the difference)



Non-independance can also hide or reverse an effect
========================================================
type: subsection

Example: thorns and herbivory
============================================

Does a defensive tissue (thorns) reduce herbivory on a plant species?

<img src="PowerAndLM-figure/thorns.jpg" height="300" />


Collected data in 5 locations to reach large sample size

Example: thorns and herbivory
============================================

<img src="PowerAndLM-figure/unnamed-chunk-8-1.png" title="plot of chunk unnamed-chunk-8" alt="plot of chunk unnamed-chunk-8" width="0.8*\textwidth" />


Example: thorns and herbivory
============================================


```r
summary(lm(y~ x))
```

```

Call:
lm(formula = y ~ x)

Residuals:
     Min       1Q   Median       3Q      Max 
-1.73696 -0.59086  0.01651  0.50495  2.37736 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  3.91598    0.27035  14.485   <2e-16 ***
x            0.06498    0.06718   0.967    0.336    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.7554 on 98 degrees of freedom
Multiple R-squared:  0.009457,	Adjusted R-squared:  -0.0006511 
F-statistic: 0.9356 on 1 and 98 DF,  p-value: 0.3358
```

What is wrong?

Example: thorns and herbivory
============================================

<img src="PowerAndLM-figure/unnamed-chunk-10-1.png" title="plot of chunk unnamed-chunk-10" alt="plot of chunk unnamed-chunk-10" width="0.8*\textwidth" />

**Simpson's paradox**

Example: thorns and herbivory
============================================

```r
library(lme4)
summary(lmer(y~ x + (1|block)))
```

```
Linear mixed model fit by REML ['lmerMod']
Formula: y ~ x + (1 | block)

REML criterion at convergence: -6

Scaled residuals: 
    Min      1Q  Median      3Q     Max 
-3.4740 -0.6403  0.0745  0.5321  2.9025 

Random effects:
 Groups   Name        Variance Std.Dev.
 block    (Intercept) 2.36630  1.5383  
 Residual             0.03789  0.1947  
Number of obs: 100, groups:  block, 5

Fixed effects:
            Estimate Std. Error t value
(Intercept)  7.93789    0.70059   11.33
x           -0.97592    0.03393  -28.76

Correlation of Fixed Effects:
  (Intr)
x -0.187
```


<img src="PowerAndLM-figure/unnamed-chunk-12-1.png" title="plot of chunk unnamed-chunk-12" alt="plot of chunk unnamed-chunk-12" width="0.8*\textwidth" />

