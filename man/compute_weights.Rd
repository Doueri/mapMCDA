% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compute_weights.R
\name{compute_weights}
\alias{compute_weights}
\title{Compute MCDA weights}
\usage{
compute_weights(x)
}
\arguments{
\item{x}{matrix of pair-wise assessment of relative importance of risk
factors.}
}
\value{
numeric vector of weights
}
\description{
Given a square reciprocal-symmetric \emph{ratio} matrix from an Analytic
Hierarchy Process, calculate the vector of weights using the using the
Pairwise Comparison Method (Saaty 1987, Saaty 1996, Malczewski 1999)
}
\examples{
  compute_weights(matrix(1, 5, 5))
}
\references{
Saaty, R. W. (1987). The analytic hierarchy process--what it is and how it
  is used. Mathematical Modelling 9 (3-5), 161-176.

  Saaty, T. L. (1996). Multicriteria decision making : the analytic hierarchy
  process : planning, priority setting, resource allocation. RWS
  Publications.
  
  Malczewski J. GIS and multicriteria decision analysis. Inc New York: John
  Wiley & Sons; 1999.
}
