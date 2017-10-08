# funcion residual.stats (Andy Field, Jeremy Miles, and Z.F., 2012. Discovering statistics using R, SAGE Publications)
residual.stats<-function(matrix){
  residuals<-as.matrix(matrix[upper.tri(matrix)])
  large.resid<-abs(residuals) > 0.05
  numberLargeResids<-sum(large.resid)
  propLargeResid<-numberLargeResids/nrow(residuals)
  rmsr<-sqrt(mean(residuals^2))
  
  cat("Root means squared residual = ", rmsr, "\n")
  cat("Number of absolute residuals > 0.05 = ", numberLargeResids, "\n")
  cat("Proportion of absolute residuals > 0.05 = ", propLargeResid, "\n")
  hist(residuals)
}
