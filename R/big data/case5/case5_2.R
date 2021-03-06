# AmEx Credit Scoring and DEFAULT
# DEFAULT|CARDHLDR ~ AGE+INCOME+OWNRENT+SELFEMPL+ACADMOS, used by Greene's lecture
# setwd("C:/Course16/WISE2016/R")
AmEx<-read.csv("C:/Course16/WISE2016/data/AmEx.csv")
# exclude<-c(1,2,"BANKBOTH","CREDGAS","UNEMP","DRUGSTOR")
# DEFAULT|CARDHLDR=1
AmEx1<-subset(AmEx,CARDHLDR==1,select=-c(1,6,12,17,39:56))
Y<-as.matrix(AmEx1[,"DEFAULT"])
Xs<-as.matrix(AmEx1[,-1])

# for qualitative choice model, package lars can not used
# for LAR, LASSO, and CV-based selection
library(glmnet)
# for linear regression, glm with family=gaussion
# for logit regression, glm with family=binomial
# Default equation conditional to Cardholder
# Ridge Regression
logit1<-glmnet(Xs,Y,family="binomial",alpha=0)
logit1
plot(logit1)
plot(logit1,xvar="lambda")
coef(logit1,s=0.1)  # s=lambda selected

# LASSO for variables selection
logit2<-glmnet(Xs,Y,family="binomial",alpha=1)
logit2
plot(logit2)
plot(logit2,xvar="lambda")

# cross validation to pick lambda: 10-fold CV
logit2.cv <- cv.glmnet(Xs,Y,family="binomial",alpha=1)
plot(logit2.cv)
# pick best lambda
best <- logit2.cv$lambda.min
best   # check log(best)

#coef <- predict(logit2,s=best,type="coef")
logit2.coef<-coef(logit2,s=best)
logit2.coef
logit2.coef[logit2.coef!=0]

# repeated CV method may be used for logit2 model (not run)
# this can take a long time tor run
cv_vector<-rep(0,100)
for(i in 1:100) {
  logit2.cv <- cv.glmnet(Xs, Y, family="binomial", alpha=1)
  cv_vector[i]=logit2.cv$lambda.min
}
median(cv_vector)  # find median value of lambda.min
coef(logit2,s=median(cv_vector))  # s=lambda selected 

