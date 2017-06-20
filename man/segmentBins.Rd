\name{segmentBins}
\alias{segmentBins}
\title{segmentBins}
\description{Run binSum and PeakSegDP on a chromosome subset.}
\usage{segmentBins(compressed, bin.chromStart, bin.size, n.bins = 2000L, 
    maxPeaks = 9L)}
\arguments{
  \item{compressed}{data.frame with columns chromStart, chromEnd, count of coverage on
one chromosome.}
  \item{bin.chromStart}{integer: chromStart of first bin.}
  \item{bin.size}{integer: bases per bin.}
  \item{n.bins}{integer: number of bins.}
  \item{maxPeaks}{integer: maximum number of peaks in segmentation model.}
}

\value{List of features, bins, modelSelection, fit, and timings.}

\author{Toby Dylan Hocking, Guillem Rigaill}





