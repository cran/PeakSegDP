\name{chromProblems}
\alias{chromProblems}
\title{chromProblems}
\description{Divide a chromosome into a set of overlapping segmentation
problems.}
\usage{chromProblems(chrom, first.chromStart, last.chromEnd, 
    bases.per.problem)}
\arguments{
  \item{chrom}{character chromosome name.}
  \item{first.chromStart}{Base before the first base on this chromosome.}
  \item{last.chromEnd}{Last base on this chromosome.}
  \item{bases.per.problem}{How many bases in each segmentation problem?}
}

\value{data.frame with columns chromStart, peakStart, peakEnd, chromEnd,
problem.name.}

\author{Toby Dylan Hocking, Guillem Rigaill}





