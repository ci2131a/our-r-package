\name{freedman}
\alias{freedman}
\title{freedman simulation function}
\usage{
freedman(n_trials, n = NULL, p = NULL, rho = NULL, orthonormalize = FALSE)
}
\description{

}
\arguments{
  \item{n_trials}{The number of simulation trials to perform}
  \item{n}{The size of the dataset (number of rows)}
  \item{p}{The number of predictor variables to include (X columns)}
  \item{rho}{The value of the correlation coefficient to use (tied to \code{n} and \code{p} such that \code{rho} = \code{p}/\code{n})}
  \item{orthonormalize}{Binary argument whether to orthonormalize the predictor matrix}
}
\examples{
# simple case with defaults
base <- freedman(n_trials = 10)
# simple with orthonormalize
ortho <- freedman(n_trials = 10, orthonormalize = TRUE)
# changing n/p/rho
change_n <- freedman(n_trials = 10, n = 50)
change_n_p <- freedman(n_trials = 10, n = 50, p = 20)
change_n_rho <- freedman(n_trials = 10, n = 50, rho = 0.75)

}
\value{the output of the function}
\details{


}

