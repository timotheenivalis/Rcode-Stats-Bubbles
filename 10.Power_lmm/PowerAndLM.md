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

![plot of chunk unnamed-chunk-1](PowerAndLM-figure/unnamed-chunk-1-1.png)

What power depends on
========================================================

**2. Strength of the effect**

![plot of chunk unnamed-chunk-2](PowerAndLM-figure/unnamed-chunk-2-1.png)


What power depends on
========================================================

**3. Unexplained variation**

![plot of chunk unnamed-chunk-3](PowerAndLM-figure/unnamed-chunk-3-1.png)


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

What if unmeasure variation is not just noise?
========================================================
type: section

%# examples where relationship is hidden by covariates / random effects
%# where relationship is over-estimated by pseudo replication

