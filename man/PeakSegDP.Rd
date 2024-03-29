\name{PeakSegDP}
\alias{PeakSegDP}
\title{PeakSegDP}
\description{Compute the PeakSeg model on a data.frame of \code{compressed} sequence
reads.}
\usage{PeakSegDP(compressed, 
    maxPeaks)}
\arguments{
  \item{compressed}{data.frame with columns chromStart, chromEnd, count.}
  \item{maxPeaks}{maximum number of peaks to consider.}
}



\author{Toby Dylan Hocking, Guillem Rigaill}




\examples{
library(PeakSegDP)
data(chr11ChIPseq, envir=environment())
one <- subset(chr11ChIPseq$coverage, sample.id=="McGill0002")[10000:12000,]
fit <- PeakSegDP(one, 3L)

if(interactive() && require(ggplot2)){

  ggplot()+
    geom_step(aes(chromStart/1e3, count), data=one)+
    geom_segment(aes(chromStart/1e3, mean,
                     xend=chromEnd/1e3, yend=mean),
                 data=fit$segments, color="green")+
    geom_segment(aes(chromStart/1e3, 0,
                     xend=chromEnd/1e3, yend=0),
                 data=subset(fit$segments, status=="peak"),
                 size=3, color="deepskyblue")+
    theme_bw()+
    theme(panel.margin=grid::unit(0, "cm"))+
    facet_grid(peaks ~ ., scales="free", labeller=function(df){
      s <- ifelse(df$peaks==1, "", "s")
      df$peaks <- paste0(df$peaks, " peak", s)
      df
    })

}

}
