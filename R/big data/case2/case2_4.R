# TOTAL WEEKLY SALES OF IMPORT AND DOMESTIC NON VQA RED & WHITE TABLE WINE 
# WITHIN MUNICIPALITY OF VANCOUVER IN UNITS AND LITRES
# FROM WEEK ENDING APRIL 4, 2009 TO WEEK ENDING MAY 28, 2011
# Fast Read from CSV file: read_csv
# install.packages("readr")
# 
# Data Analysis
# library(readr) 
# wine<-read_csv("http://web.pdx.edu/~crkl/ec510/data/Vancouver_Non_VQA_Sls_Apr1toMay31.csv",na="NA")
# wine<-read_csv("C:/Course16/EC510/data/Vancouver_Non_VQA_Sls_Apr1toMay31.csv",na="NA")
# wine<-read_excel("C:/Course16/EC510/data/Vancouver_Non_VQA_Sls_Apr1toMay31.xlsx",sheet=2)
library(readr) 
# wine<-read_csv("http://web.pdx.edu/~crkl/WISE2016/data/Vancouver_Non_VQA_Sls_Apr1toMay31.csv",na="NA")
wine<-read_csv("C:/Course16/WISE2016/data/Vancouver_Non_VQA_Sls_Apr1toMay31.csv",na="NA")
dim(wine)
names(wine)
summary(wine)

wine$where<-wine$`Store Category Sub Name`    # import from ...
wine$what<-factor(wine$`Store Category Minor Name`)   # Red or White
wine$loc<-factor(wine$`Bottled Location Code`)
wine$price<-wine$`Current Display Price`
wine$price_level<-cut(wine$price,breaks=c(-Inf,50,100,1000,Inf),labels=c("Low","Medium","High","Expensive"))
wine$quantity<-wine$`Total Weekly Selling Unit`

# alc<-wine$`Alcohol Percent`
# sweet<-wine$`Product Sweetness Code`
# age<-wine$`Julian Week No`
# import<-factor(wine$`Domestic/Import Indicator`)

# using table, xtabs, aov
# xtabs(~ where + what,data=wine)
t1<-with(wine,table(where,what))
t1
summary(t1)

# price analysis
t2<-with(wine,table(where,price_level))
t2
summary(t2)

t3<-with(wine,table(what,price_level))
t3
summary(t3)

# xtabs(~ where + price_level + what,data=wine)
t4<-with(wine,table(where,price_level,what))
t4
summary(t4)

# analysis of variance with category variables
a1<-aov(price~what,data=wine)
a1
summary(a1)

a2<-aov(price~where,data=wine)
a2
summary(a2)

a3<-aov(price~where+what,data=wine)
a3
summary(a3)

# same as anova from lm fit
m1<-lm(price~where+what,data=wine)
summary(m1)
anova(m1)

# demand analysis
m2<-lm(quantity~price,data=wine)
summary(m2)
m3<-lm(log(quantity)~log(price),data=wine,subset=(quantity>0))
summary(m3)
m4<-update(m3, . ~ . + loc+`Alcohol Percent`+`Julian Week No`)
summary(m4)
anova(m3,m4)

# subsets of data may be analyzed similarly
# varsel<-c("what","where","quantity","price","price_level")
# wine100<-subset(wine,price<100 & quantity>0,varsel) # not including returned 

