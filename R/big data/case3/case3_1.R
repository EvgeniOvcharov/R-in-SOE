# Walmart Sales
# Data Visualization
#
library(readr)
# Store Dept Date Weekly_Sales IsHoliday: 2010-02-05 ~ 2012-10-26
data1<-read_csv("C:\\Users\\44180\\Documents\\Surface-workandstudy\\soe\\bigdata\\Walmart_train.csv")
data1<-read_csv("D:\\PC-workandstudy\\soe\\bigdata\\data of case3\\Walmart_train.csv")
# Store Type Size
data2<-read_csv("C:\\Users\\44180\\Documents\\Surface-workandstudy\\soe\\bigdata\\Walmart_stores.csv")
data2<-read_csv("D:\\PC-workandstudy\\soe\\bigdata\\data of case3\\Walmart_stores.csv")
# Store Date Temperature Fuel_Price Markdown1-5 CPI Unemplyment IsHoliday
data3<-read_csv("C:\\Users\\44180\\Documents\\Surface-workandstudy\\soe\\bigdata\\Walmart_features.csv")
data3<-read_csv("D:\\PC-workandstudy\\soe\\bigdata\\data of case3\\Walmart_features.csv")
# Store Dept Date IsHoliday: 2012-11-02 ~ 2013-07-26
data4<-read_csv("C:\\Users\\44180\\Documents\\Surface-workandstudy\\soe\\bigdata\\Walmart_test.csv")
data4<-read_csv("D:\\PC-workandstudy\\soe\\bigdata\\data of case3\\Walmart_test.csv")

# training dataset: 2010-02-05 ~ 2012-10-26
train<-merge(data1,merge(data2,data3))
# testing dataset: 2012-11-02 ~ 2013-07-26
test<-merge(data4,merge(data2,data3))

rm(data1,data2,data3,data4)
summary(train)
dim(train)

# Analysis for train data only
# some variables include missing values
train$Date<-as.Date(train$Date)
train$Store<-as.factor(train$Store)
train$Dept<-as.factor(train$Dept)
train$Type<-as.factor(train$Type)

with(train,table(Dept,Store))  # 45 stores with 99 (index) departments
with(train,table(Store,Type))  # 3 types (Store and Type are exclusive)
with(train,table(Dept,Type))

library(ggplot2)
# 99 Depts within 45 Stores which are in 3 types
ggplot(data=train,aes(x=Store,fill=Dept))+geom_bar()
ggplot(data=train,aes(x=Store,fill=Dept))+geom_bar()+facet_grid(Type ~ .)
ggplot(data=train,aes(x=Dept,fill=Type))+geom_bar()+coord_flip()

# Sales<-train(,c("Store","Dept","Weekly_Sales","Type","Size"))
# (Store, Type, Size) is used to identify each store individually
# total sales across 45 stores
Sales_Total<-aggregate(train$Weekly_Sales,
                       by=list(Store=train$Store,Type=train$Type,Size=train$Size),sum)
s0<-labs(title="Walmart Sales by Stores (429 Weeks Total)",y="Sales $")
ggplot(data=Sales_Total,aes(x=Store,y=x,fill=Type))+geom_bar(stat="identity")+s0
ggplot(data=Sales_Total,aes(x=Store,y=I(x/Size),fill=Type))+geom_bar(stat="identity")+s0

# Weekly_Sales trends
# 429 weeks, 3 types of stores (aggregate over 45 stores and 99 departments in each store)
Sales_All<-aggregate(train$Weekly_Sales,
                     by=list(Date=train$Date,Type=train$Type),sum)
# 429 weeks, 3 types of 45 stores (aggregate over 99 departments in each store)
Sales_Store<-aggregate(train$Weekly_Sales,
                       by=list(Store=train$Store,Date=train$Date,Type=train$Type),sum)
# 429 weeks, 3 types of 99 departments (aggregate over 45 stores)
Sales_Dept<-aggregate(train$Weekly_Sales,
                      by=list(Dept=train$Dept,Date=train$Date,Type=train$Type),sum)                       

g0<-labs(title="Walmart Sales Trend",x="Date",y="Weekly Sales")
g1<-ggplot(data=Sales_All,aes(x=Date,y=x)) + geom_line(aes(col=Type)) 
g1+g0
g2<-ggplot(data=Sales_Store,aes(x=Date,y=x)) + geom_line(aes(col=Store))
g2+g0
g2+facet_grid(Type ~ .)+g0
g3<-ggplot(data=Sales_Dept,aes(x=Date,y=x)) + geom_line(aes(col=Dept)) 
g3+g0
g3+facet_grid(Type ~ .)+g0
