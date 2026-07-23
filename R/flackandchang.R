
# 
# Based on methods described in "Frequency of Selecting Noise Variables in Subset Regression Analysis: A Simulation Study" by Flack and Chang (1987)


flackandchang <- function(n_trials, n = 10, p = 10, rho = 0){
  
  if(p<2){
    stop("Need at least 2 predictors")
  }
  
  m <- diag(p)
  v <- vector(mode = "list", length = p-1)
  for(i in 1:(p-1)){
    v[[i]] <- rho^(seq(from=1, to = p-i))
  }
  b <- unlist(v)
  m[lower.tri(m)] <- b
  m <- t(m)
  m[lower.tri(m)] <- b
  m.2 <- cbind(c(0.5,0.5, rep(0,p-2)), m)
  m.3 <- rbind(c(1,0.5,0.5,rep(0,p-2)), m.2)
  
  coef.matrix <- matrix(nrow = n_trials, ncol = p)
  #coef.matrix <- matrix(nrow = n_trials, ncol = p+1) # ncol = p
  colnames(coef.matrix) <- paste0("x", 1:p)
  #colnames(coef.matrix) <- c("Intercept", paste0("x", 1:p)) # paste0("x", 1:p)
  
  summary.matrix <- matrix(nrow = n_trials, ncol = 1)
  colnames(summary.matrix) <- "R-Squared"
  
  pval.matrix <- matrix(nrow = n_trials, ncol = p)
  #pval.matrix <- matrix(nrow = n_trials, ncol = p+1) # ncol = p
  colnames(pval.matrix) <- paste0("x", 1:p)
  #colnames(pval.matrix) <- c("Intercept", paste0("x", 1:p)) 
  
  
  for(i in 1:n_trials){
    yx <- MASS::mvrnorm(n = (p+1), mu = rep(0,p+1), Sigma = m.3)
    df <- data.frame(yx)
    colnames(df) <- c("y", paste0("x", 1:p))
  
    model <- lm(y~.-1, data = df) # run the linear model without an intercept  
    #model <- lm(y~., data = df)  # or with an intercept
    coef.matrix[i,] <- model$coefficients # extract and save coefficients
    model.summary <- summary(model)
    summary.matrix[i,1] <- model.summary$r.squared
    pval.matrix[i,] <- model.summary$coefficients[,4]
  }
  
  return(list(coefficients = coef.matrix, r.squared = summary.matrix, p.values = pval.matrix, df = df, model = model, summary = model.summary))

}


test1 <- flackandchang(10)


test3 <- flackandchang(1000, n = 50)

hist(test3$coefficients[,4])
summary(test3$coefficients[,4])
colnames(test3$coefficients)
hist(test3$r.squared)
summary(test3$r.squared)



test4 <- flackandchang(1,50)

summary(test4$coefficients[,1])

test4$df

plot(test4$df[,2], test4$df[,1])
plot(test4$df[,3], test4$df[,1])
plot(test4$df[,4], test4$df[,1])


cor(test4$df[,2], test4$df[,1])
cor(test4$df[,3], test4$df[,1])
cor(test4$df[,4], test4$df[,1])

cor(test4$df)

test4$model
test4$summary






