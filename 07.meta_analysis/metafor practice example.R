#this document describes some of the basic functions in the package 'metafor'
#we will use the data and steps described in Viechtbauer 2010 (Journal of Statistical software)
#this paper, as well as many other helpful analysis examples are available on the metafor website
#http://www.metafor-project.org/doku.php/metafor

#the first step is to install and load the metafor package
install.packages("metafor")
library("metafor")

#we are going to be using some data pre-loaded into the package
data("dat.bcg", package = "metafor")
#let's have a look at our data...
print(dat.bcg, row.names = FALSE)
#each row are the results of one study which tested the effectiveness of a particular vacine against tuberculosis
# tpos/tneg = the number of vaccinated subjects that were tubercolosis positive/negative
# cpos/cpos = the number of control (non-vaccinated) subjects that were tubercolosis positive/negative
# ablat = absolute latitude of the study location (in degrees)
# alloc = treatment allocation method for the particular study

#We must choose a standarized effect size to transform our results into for meta-analysis
#in this case, we will work with the log relative risk as the effect size
# values can be obtained with this command:
dat <- escalc(measure = "RR", ai = tpos, bi = tneg, ci = cpos, di = cneg, 
              data = dat.bcg, append = TRUE)

#lets take a look at our transformed data...
print(dat[,-c(4:7)], row.names = FALSE)
# yi = the effect size for each study calculated as a relative risk
#values below 0 indicate a lower infection risk for the vaccinated group
# vi = the variance for each effect size

#Now we are ready to fit a random-effects model!
#the default model in metafor is a random effects (rather than fixed effects) model
#this is what we want
res <- rma(yi, vi, data = dat)
res

#let's tease apart this output..
# k = the number of studies 
# REML = restricted maximum-likelihood estimator
# REML is the model of inference used, it describes the particular
#     statistical parameters used in caluclating the meta-analytic mean effect
#REML is the default, and most popular inference method as it is able to deal
#     with random-effects and mixed-effects models 
#there are other parameters of inference you can specify to use in metafor 
#     e.g the ML (maximum likelihood) estimator
#     (and some you can't such as Bayesian inference)
#for today we will just stick with REML

#skipping to the bottom of the results "model results"
#we have here something that looks similar to the output of a linear regression model
#the "estimate" is the meta-analytic mean of our 13 studies 
# estimate = the average log relative risk of tuberculosis infection when vaccinated

# pval = the likelyhood that the meta-analytic mean is 0:
#     this tells us the vaccine has a significant effect in treating tuberculosis

#What's going on at the top of the output though?
#these heterogenity statistics are used to interpret how 
#     similar or different the true effect between studies is
# tau^2 = amount of variability caused by differences between studies
# I^2 = the proportion of total variability caused by differences 
#     within studies (rather than variation within studies)
#H^2 = ratio of total amount of variability in the observed outcomes to the 
        #amount of sampling variability
        # if tau^2 = 0, H^2 would equal 1
# Q is a test statistic testing if studies have different true means from one another

# these results indicate considerable heterogeneity amongst studies
#however - always be cautious when interpreting hetergeneity tests!

###mixed-effect model
#okay, so now we know that there is heterogeneity in effect between studies
#we can use a mixed effect model to test what factor(s) are causing this heterogenity
#maybe the effectiveness of the vaccine is dependent on study location
#       "increased abundance of non-pathogenic environmental mycobacteria closer
#         to the equator may provide a natural protection from tuberculosis"
#additionally, maybe effectiveness of the vaccine has changed over time
#we can test the influence of location (laditude) and time using 
#       a mixed effect model, where these factors are added as moderator terms
# ablat = latitude at which the study was performed 
# year = year of the study
res_mixedeffect <- rma(yi, vi, mods = ~ ablat + year, data = dat)
res_mixedeffect

#let's unpack the new terms

# R^2 = (0.31 -0.11)/0.31 = 65%
#       R^2 indicates that 65% of the heterogenity between studies can be
#       accounted for by the two moderator terms (time and laditude)

# QE (test for residual heterogenity) is significant, suggesting that other
#     moderators not considered in the model are influncing the vaccine effectiveness

#QM (test or moderators) tests H0: B1 = B2 = 0 (the "omnibus" test)
#     the significance of QM indicates that the effect of at least one of the
#     moderator terms is significant

#model results
# latitude has a significant influence on the effect of the vaccine
#     one degree increase in absolute latitude corresponds to a change of 
#     -0.028 units of average log relative risk of the vaccine
#there's no effect of year on the effectiveness of the vaccine



####mixed model - categorical moderator
#perhaps the design type of a study influences the effect?
#the design is a categorical variable (random, alternate, or systematic)
#to test the influence of these categories, we must first create 'dummy variables'

dat$a.random <- ifelse(dat$alloc == "random", 1, 0)
dat$a.alternate <- ifelse(dat$alloc == "alternate", 1, 0)
dat$a.systematic <- ifelse(dat$alloc == "systematic", 1, 0)

#now, we can add the study design (alloc) as a moderator
res_design<-rma(yi, vi, mods = ~ factor(alloc) - 1, data = dat)
res_design

#how do we interpret the following:
# tests for heterogeneity
# test of moderators
# the model results
