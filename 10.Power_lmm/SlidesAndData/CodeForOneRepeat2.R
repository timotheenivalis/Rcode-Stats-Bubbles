#########################################
set.seed(123)

nobs <- 1000
indnb <- 30
indvalues <- rnorm(n = indnb)
indobs <- sample(x = 1:indnb, size = nobs, replace = TRUE)
slope = 0.1

predictor <- rnorm(nobs)

response <- predictor * slope + indvalues[indobs] + rnorm(nobs)

coefficients(summary(lm(response ~ predictor)))[2,3]
coefficients(summary(lmer(response ~ predictor + (1|indobs))))[2,3]
