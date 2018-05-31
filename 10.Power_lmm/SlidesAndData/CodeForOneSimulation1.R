nbindg1 <- 20 #number of individuals in group 1
nbindg2 <- 20 #number of individuals in group 2 
diffgroup <- 0 # difference between the two groups (here no difference!)
obsperind <- 10 # number of repeated measurements
measurementerror <- 0.1 # how much the repeated measurements of one individual vary


indvalues <- rnorm(n = nbindg1 + nbindg2, mean = c(rep(0, times=nbindg1), rep(diffgroup,times=nbindg2)), sd=1) # the true individual values 

#individual data, with a bit of noise around the true values
inddata <- data.frame(group= c(rep(1, times=nbindg1), rep(2,times=nbindg2)),
                      individual=1:(nbindg1+nbindg2))
inddata$value <- rnorm(n=nrow(inddata), mean=0, sd=measurementerror) +
  indvalues[inddata$individual]

#repeated data, with a bit of noise around the true values
dat <- data.frame(group= c(rep(1, times=nbindg1*obsperind), rep(2,times=nbindg2*obsperind)),
                  individual = rep(1:(nbindg1+nbindg2), each=obsperind) )

dat$value <- rnorm(n = nrow(dat), mean = 0, sd = measurementerror) + 
  indvalues[dat$individual]


