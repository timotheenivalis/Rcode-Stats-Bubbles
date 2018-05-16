##################################################################################
##### Structural Equation Models with Lavaan ####

#Libraries
library(lavaan)
library(semPlot)
#library(devtools)
#install_github("jslefche/piecewiseSEM@2.0")
library(piecewiseSEM)
library(nlme)
library(lme4)

# Import data
df<-read.csv("C:/Users/u5498338/Dropbox/SEM Workshop in R/Keeley_rawdata_select4.csv")

#Investigate the data, what are we dealing with here?



########## Run the SEM #########################
### 1. Specify the model ###



### 2. Fit the model ###



### 3. Extract results ###


#Don't necesarily need to do this now, just so you have the code!
#Often nice to put these into data frames, especially if you are looping through many species.
#Get the path coefficients and errors. Combine non-standardized and standardized
estimates<-parameterEstimates(fit)
standardized<- standardizedSolution(fit)
colnames(standardized)[colnames(standardized) == 'se'] <- 'se.std'
colnames(standardized)[colnames(standardized) == 'z'] <- 'z.std'
colnames(standardized)[colnames(standardized) == 'pvalue'] <- 'pvalue.std'
temporary<-merge(estimates, standardized, by = c("lhs", "op",  "rhs"))

#Extract Model fit
modelfit<- data.frame(fitMeasures(fit, c("chisq","df","pvalue", "cfi", "rmsea", "aic","bic", "bic2")))
modelfit2<-as.data.frame(t(modelfit))

#Get the r2 values
rsquare<-data.frame(inspect(fit, "rsquare"))
rsquare2<-as.data.frame(t(rsquare))

#AIC value
AIC(fit)

### 4. Plot ###
semPaths(fit, whatLabels = "par", layout= "spring")
#plot the relationships, check they look ok






########################################################################################################
########################################################################################################
#### Let's try a bigger model! ###
#Upload
df2<- read.csv("C:/Users/u5498338/Dropbox/SEM Workshop in R/Laydate data.csv")

#Centre temperature
df2$Tempcntre<- df2$Temperature-(mean(df2$Temperature, na.rm=T))

### 1. Specify the model ###



### 2. Fit the model ###
fit<- sem(model, data=df2, fixed.x=FALSE)


### 3. Extract results ###
summary(fit, rsq=T, fit.measures=TRUE)





########################################################################################################
########################################################################################################
####### Piecewise SEM ###########
#Upload
df3 <-  read.csv("C:/Users/u5498338/Dropbox/SEM Workshop in R/mass data.csv")

#Fix up dataset
df3$Tempcnt <- df3$Temp - mean(df3$Temp,na.rm=T)

#Run the model
modelList = psem(
  ### Population
  lme(Pop ~ pcnt  + Tempcnt, 
      random = list(Species = pdDiag(~ Tempcnt +pcnt), Site = pdDiag(~ Tempcnt +pcnt)), 
      na.action=na.exclude,
      weights = varFixed(~ 1/(sqrt(PopWt))),
      data=df3),
  ### Reproduction
  glmer(pcnt ~ BMpcnt + Tempcnt +  (1|Species/Site) +  (0 + BMpcnt|Species/Site) + (0+Tempcnt|Species/Site), 
        family = binomial(link = "logit"),
        data = df3),
  ### Body mass
  lme(BMpcnt ~ Tempcnt, 
      random = list(Species = pdDiag(~ Tempcnt), Site = pdDiag(~ Tempcnt)), 
      na.action=na.exclude, 
      data=df3)
)#End List

#Extract the output
result<-summary(modelList)
Fisher.c<-result$Cstat
result$IC
result$R2
coefs<-coefs(modelList, intercept = T)

#Look at variance and std dev explained for each random slope and intercept
VarCorr(modelList[[1]]) #Population
VarCorr(modelList[[2]]) #Reproduction
VarCorr(modelList[[3]]) #Body Mass

### Save random slopes and intercept estimates
#Pop
popSlopesSpecies<-data.frame(modelList[[1]]$coefficients$random$Species)
popSlopesSpecies$Species<-row.names(popSlopesSpecies)
popSlopesSite<-data.frame(modelList[[1]]$coefficients$random$Site)
popSlopesSite$SpeciesSite<-row.names(popSlopesSite)

#RS
ranef(modelList[[2]])[1]
ranef(modelList[[2]])[2]
#BM
modelList[[3]]$coefficients$random$Species
modelList[[3]]$coefficients$random$Site
##################################################
