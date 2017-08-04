setwd("~/Downloads/Amazon_work/Amaggle/CIKMAnalyticCup/modelling_data/")
library(Rmisc)
library(data.table)
library(stringr)
library(ggplot2)
library(bit64)
library(caTools)
library(xgboost)
options(scipen=999)

source("../code/utils.R")

## Read training and test files 
train1 = fread("Train1.tsv")
train2 = fread("Train2.tsv")
train3 = fread("Train3.tsv")
test = fread("Test.tsv")

model_train2 = feature_engineering(train2)
model_train3 = feature_engineering(train3)
model_test = feature_engineering(test)

feats = names(model_train2)
train2_x = as.matrix(model_train2)
train2_y_clr = as.integer(train2$clarity)
train2_y_con = as.integer(train2$conciseness)

train3_x = as.matrix(model_train3)
train3_y_clr = as.integer(train3$clarity)
train3_y_con = as.integer(train3$conciseness)

test_x = as.matrix(model_test)

# Add vw feature ##
train2_vw_clr = fread("../vw_feature/model_clr/train2_pred.vw")
train2_x_clr = as.matrix(cbind(train2_x, train2_vw_clr$V1))

train2_vw_con = fread("../vw_feature/model_con/train2_pred.vw")
train2_x_con = as.matrix(cbind(train2_x, train2_vw_con$V1))

train3_vw_clr = fread("../vw_feature/model_clr/train3_pred.vw")
train3_x_clr = as.matrix(cbind(train3_x, train3_vw_clr$V1))

train3_vw_con = fread("../vw_feature/model_con/train3_pred.vw")
train3_x_con = as.matrix(cbind(train3_x, train3_vw_con$V1))

test_vw_clr = fread("../vw_feature/model_clr/test2_pred.vw")
test_x_clr = as.matrix(cbind(test_x, test_vw_clr$V1))

test_vw_con = fread("../vw_feature/model_con/test2_pred.vw")
test_x_con = as.matrix(cbind(test_x, test_vw_con$V1))
