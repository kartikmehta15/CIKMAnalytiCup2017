feature_engineering = function(data1){
  data1 = create_features(data1)
  data1 = get_numeric_feats(data1)
  return(data1)
}

get_numeric_feats = function(data1){
  factor_cols=c("country","category_lvl_1","category_lvl_2","category_lvl_3","product_type")
  all_cols = c(factor_cols, "numW", "price", "containNum")
  data1[ , factor_cols] <- lapply(data1[ , factor_cols, with=F] , factor)
  data1[ , all_cols] <- lapply(data1[ , all_cols, with=F] , as.numeric)
  data1 = data1[,all_cols,with=F]
  data1[is.na(data1)] = -1
  return(data1)
}

count_words = function(x){
  numwords = str_count(x, '\\w+')
  return(numwords)
}

create_features = function(data){
  data$numW = sapply(data$title, count_words)
  data$containNum = grepl("\\d",data$title)*1
  #featurenames = c("numW", "containNum")
  return(data)
}
