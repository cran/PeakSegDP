\name{chr11first}
\alias{chr11first}
\docType{data}
\title{
Counts of first base of aligned reads
}
\description{
For 4 samples on chr11 (hg19), this data set counts the first base pair of
aligned reads at each genomic position. In contrast, chr11ChIPseq counts
every base pair in each read (and each read is about 100bp, so that
means there is some auto-correlation in chr11ChIPseq, but not in chr11first).
}
\usage{data("chr11first")}
\format{
  A data frame with 23252 observations on the following 4 variables.
  \describe{
    \item{\code{sample.id}}{a factor with levels for each of 4 samples}
    \item{\code{chromStart}}{integer vector: base before, on chr11}
    \item{\code{chromEnd}}{integer vector: last base on chr11}
    \item{\code{count}}{integer: aligned first base read counts}
  }
}
\source{
  H3K4me3_TDH_immune chunk 5 in
  http://cbio.ensmp.fr/~thocking/chip-seq-chunk-db/
  which in turn comes from
  http://epigenomesportal.ca/
}
\examples{
data(chr11ChIPseq)
data(chr11first)
library(ggplot2)
ann.colors <-
  c(noPeaks="#f6f4bf",
    peakStart="#ffafaf",
    peakEnd="#ff4c4c",
    peaks="#a445ee")
both <- list(coverage=chr11ChIPseq$coverage, first=chr11first)
representations <- NULL
one.sample <- "McGill0322"
for(data.type in names(both)){
  one <- subset(both[[data.type]], sample.id==one.sample)
  representations <- rbind(representations, data.frame(data.type, one))
}
one.sample.regions <- subset(
  chr11ChIPseq$regions, sample.id==one.sample)

if(interactive() && require(ggplot2)){

ggplot()+
  scale_fill_manual("annotation", values=ann.colors,
                    breaks=names(ann.colors))+
  penaltyLearning::geom_tallrect(aes(xmin=chromStart/1e3, xmax=chromEnd/1e3,
                    fill=annotation),
                data=one.sample.regions, alpha=1/2)+
  theme_bw()+
  theme(panel.margin=grid::unit(0, "cm"))+
  facet_grid(data.type ~ ., scales="free")+
  geom_step(aes(chromStart/1e3, count), data=representations)+
  xlab("position on chr11 (kilo base pairs)")

}

}
\keyword{datasets}
