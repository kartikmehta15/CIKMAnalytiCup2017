xgb_model = function(train1_x, train1_y, param, nround){
  print(paste(names(param),param,collapse=" , "))  ## Print the parameters used for model
  ## Select number of rounds using xgb.cv
  bst_cv = xgb.cv(param=param, data = train1_x, label = train1_y, nrounds=nround,nfold=2,metric=list("rmse"),early_stopping_rounds=5)
  nround_sel = which.min(bst_cv$test.rmse.mean)

  print(paste("Nround Selected is :", nround_sel));
  ## Train final model using number of rounds selected using xgb.cv
  final_model = xgboost(param=param, data = train1_x, label = train1_y, nrounds=nround_sel)
  return(final_model)
}

rmse = function(x,y){
  score = sqrt(sum((x-y)^2)/length(x))
  return(score)
}
