# Selection of noisy data at 25/50% significance in 2 passes of linear regression
# Implementation of the methods described in "A Note on Screening Regression Equations" by David A. Freeman 1983

freedman <- function(n_trials, n = NULL, p = NULL, rho = NULL, orthonormalize = FALSE){
  
  seed <- .Random.seed
  
  # define function for checking whether some inputs are positive whole numbers
  is.positive.whole <- function(x) {
    is.numeric(x) && length(x) == 1 && x > 1 && x %% 1 == 0
  }
  
  # Beginning of revision using ChatGPT to concisely organize the nested if statements
  
  supplied <- c(
    n   = !is.null(n),
    p   = !is.null(p),
    rho = !is.null(rho)
  )
  
  # default case
  if (!any(supplied)) {
    n <- 100L
    p <- 50L
    rho <- p / n
  }
  
  # validate supplied values
  if (supplied["n"] && !is.positive.whole(n))
    stop("Argument n must be a positive integer.")
  
  if (supplied["p"] && !is.positive.whole(p))
    stop("Argument p must be a positive integer.")
  
  if (supplied["rho"] && (rho < 0 || rho > 1))
    stop("Argument rho must be between 0 and 1.")
  
  nsup <- sum(supplied)
  
  if (nsup == 3)
    stop("Argument supplied to n, p, and rho when only 2 out of 3 are needed.")
  
  if (nsup == 1) {
    if (supplied["n"]) {
      p <- round(0.5 * n)
      rho <- p / n
      warning("Argument p defaulted to 0.5 * n")
    } else if (supplied["p"]) {
      n <- 2 * p
      rho <- p / n
      warning("Argument n chosen to be 2 * p")
    } else {
      stop("Argument rho alone is insufficient. Supply to n or p for rho = p/n.")
    }
  }
  
  if (nsup == 2) {
    if (!supplied["rho"]) {
      if (p >= n)
        stop("Argument p must be strictly less than n.")
      rho <- p / n
    } else if (!supplied["n"]) {
      n <- p / rho
      if(n %% 1 != 0){
        warning("Value of n rounded.")
        n <- round(n, digits = 0)
      }
    } else {
      p <- n * rho
      if(p %% 1 != 0){
        warning("Value of p rounded.")
        p <- round(p, digits = 0)
      }
    }
  }
  
  # End of revision
  
  # defining vectors for storing information from simulations
  dl <- vector(mode = "list", length = n_trials) # first pass data set
  nl <- vector(mode = "list", length = n_trials) # second pass data set
  first <- matrix(nrow = n_trials, ncol = 5) # results from first model
  second <- matrix(nrow = n_trials, ncol = 5) # results from second model
  colnames(first) <- c("R2", "F", "P", "25", "5")
  colnames(second) <- c("R2", "F", "P", "25", "5")
  
  for(i in 1:n_trials){
    
    data <- MASS::mvrnorm(n, c(rep(0,p+1)), Sigma = diag(x = 1, nrow = p+1)) # generating data from MV Normal
    if(orthonormalize){ # if orthonormalize
      y <- data[,(p+1)]
      x <- data[,-(p+1)]
      ortho <- qr.Q(qr(x)) # then QR decomp
      data <- cbind(ortho, y)
    }
    colnames(data) <- c(paste0("x", 1:p), "y")
    df <- data.frame(data)
    dl[[i]] <- df # save the data frame
    
    model <- lm(y~.-1, data = df) # run the first pass linear model without an intercept
    # extract and save information
    sum.mod <- summary(model)
    first[i,1] <- sum.mod$r.squared
    first[i,2] <- sum.mod$fstatistic[[1]]
    first[i,3] <- 1-pf(sum.mod$fstatistic[[1]], sum.mod$fstatistic[[2]], sum.mod$fstatistic[[3]])
    first[i,4] <- sum(sum.mod$coefficients[,4]<=0.25)
    first[i,5] <- sum(sum.mod$coefficients[,4]<=0.05)
    
    # create second pass data set
    newdata <- df[,c((1:p)[sum.mod$coefficients[,4]<=0.25],p+1)]
    nl[[i]] <- newdata # save the second data
    # fit second pass model and extract results
    newmodel <- lm(y~.-1, data = newdata)
    newsum <- summary(newmodel)
    second[i,1] <-  newsum$r.squared
    second[i,2] <-  newsum$fstatistic[[1]]
    second[i,3] <-  1-pf(newsum$fstatistic[[1]], newsum$fstatistic[[2]], newsum$fstatistic[[3]])
    second[i,4] <-  sum(newsum$coefficients[,4]<=0.25)
    second[i,5] <-  sum(newsum$coefficients[,4]<=0.05)
    
    
  }
  
  return(list(first.data = dl , second.data = nl, first.output = first, second.output = second))
  
}
