setwd("~/Downloads/Amazon_work/Amaggle/CIKMAnalyticCup/git_repo/CIKMAnalytiCup2017/")
library(Rmisc)
library(data.table)
library(stringr)
library(ggplot2)
library(bit64)
library(caTools)
library(xgboost)
library(randomForest)
options(scipen=999)
rm(list=ls(all=TRUE))

source("o02_xgboost_model.R")
source("o01_create_dataset_v3.R")

param_clr <- list("objective" = "reg:linear","eval_metric" = "rmse","nthread" = 8,max.depth = 10,
              verbose=1,eta = 0.05,gamma=0.2,colsample_bytree=0.9, min_child_weight=50)

param_con <- list("objective" = "binary:logistic","eval_metric" = "rmse","nthread" = 8,max.depth = 15,
                  verbose=1,eta = 0.1,gamma=0.2,colsample_bytree=0.9, min_child_weight=50)

xgb_clr = xgb_model(train2_x_clr, train2_y_clr, param_clr, nround=100)
xgb_con = xgb_model(train2_x_con, train2_y_con, param_con, nround=100)

## Make evaluation guess ##
pred_train3_clr = predict(xgb_clr, train3_x_clr)
rmse(pred_train3_clr, train3_y_clr)
# 0.2150666, 0.2147435, 0.2117275 0.2166548 0.2124151 0.2112836 0.2108544
pred_train3_con = predict(xgb_con, train3_x_con)
rmse(pred_train3_con, train3_y_con)
# 0.4218802, 0.4208466, 0.3809649 0.3774201 0.3793716 0.3567688 0.3502863

## Make test prediction ##
sample_pred_test_clr = fread("../data/testing/submission_sample_random/clarity_test.predict")
sample_pred_test_clr$V1 = predict(xgb_clr, test_x_clr)
write.table(sample_pred_test_clr, "../data/testing/submission/clarity_test.predict", row.names=F, col.names=F, quote=F)
#clarity_test: 0.257657
sample_pred_test_con = fread("../data/testing/submission_sample_random/conciseness_test.predict")
sample_pred_test_con$V1 = predict(xgb_con, test_x_con)
write.table(sample_pred_test_con, "../data/testing/submission/conciseness_test.predict", row.names=F, col.names=F, quote=F)
# conciseness_test: 0.435793
# overall_score: 0.346725

# zip -r submission.zip .