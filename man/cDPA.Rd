\name{cDPA}
\alias{cDPA}
\title{cDPA}
\description{A constrained dynamic programming algorithm (cDPA) can be used to
compute the best segmentation with respect to the Poisson
likelihood, subject to a constraint on the number of segments, and
the changes which must alternate: up, down, up, down, ...}
\usage{cDPA(count, weight = rep(1, length(count)), maxSegments)}
\arguments{
  \item{count}{Integer vector of count data to segment.}
  \item{weight}{Data weights (normally this is the number of base pairs).}
  \item{maxSegments}{Maximum number of segments to consider.}
}



\author{Toby Dylan Hocking, Guillem Rigaill}




\examples{
fit <- cDPA(c(0, 10, 11, 1), maxSegments=3)
stopifnot(fit$ends[3,4] == 3)
stopifnot(fit$ends[2,3] == 1)
}
