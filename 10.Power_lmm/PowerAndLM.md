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

* **Larger sample size** <- you can control
* **Smaller unexplained variability** <- you can sometimes control
* **Real strength of the effect of interest** <- you cannot control
