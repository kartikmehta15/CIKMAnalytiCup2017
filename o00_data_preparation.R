setwd("~/Downloads/Amazon_work/Amaggle/CIKMAnalyticCup/data/")
library(Rmisc)
library(data.table)
library(stringr)
library(ggplot2)
library(bit64)
library(caTools)
library(xgboost)
options(scipen=999)

## Read training and test files
train = fread("training/data_train.tsv")
names(train) = c("country","sku_id","title","category_lvl_1","category_lvl_2","category_lvl_3","short_description","price","product_type")
label1 = fread("training/clarity_train.labels")
names(label1) = "clarity"
label2 = fread("training/conciseness_train.labels")
names(label2) = "conciseness"
traindata = data.frame(cbind(train,label1,label2))

## Split training into two sets ##
set.seed(1)
rand1 = runif(nrow(traindata))
train1 = traindata[rand1<=0.4,]
train2 = traindata[rand1>0.4 & rand1<=0.8,]
train3 = traindata[rand1>0.8,]

## Read validation and test data ##
valdata = fread("validation/data_valid.csv")
testdata = fread("testing/data_test.tsv")
valdata= data.frame(valdata)
testdata = data.frame(testdata)
names(valdata) = c("country","sku_id","title","category_lvl_1","category_lvl_2","category_lvl_3","short_description","price","product_type")
names(testdata) = c("country","sku_id","title","category_lvl_1","category_lvl_2","category_lvl_3","short_description","price","product_type")

train1$short_description = gsub("\t", "", train1$short_description)
train2$short_description = gsub("\t", "", train2$short_description)
train3$short_description = gsub("\t", "", train3$short_description)
valdata$short_description = gsub("\t", "", valdata$short_description)
testdata$short_description = gsub("\t", "", testdata$short_description)

write.table(train1, "../modelling_data/Train1.tsv", sep="\t", row.names=F, quote=F)
write.table(train2, "../modelling_data/Train2.tsv", sep="\t", row.names=F, quote=F)
write.table(train3, "../modelling_data/Train3.tsv", sep="\t", row.names=F, quote=F)
write.table(valdata, "../modelling_data/Val.tsv", sep="\t", row.names=F, quote=F)
write.table(testdata, "../modelling_data/Test.tsv", sep="\t", row.names=F, quote=F)
