\name{chr11ChIPseq}
\alias{chr11ChIPseq}
\docType{data}
\title{
ChIP-seq aligned read coverage for 4 samples on a subset of chr11
}
\description{
  A ChIP-seq experiment was performed to locate the genomic positions of
  a histone (H3K4me3) in 2 B cell samples (McGill0091, McGill0322) and
  2 T cell samples (McGill0002, McGill0004). The short sequence reads
  (about 100 base pairs each) were aligned to the hg19 reference genome,
  and the "coverage" in this data set contains
  the total count of aligned reads at each base pair. It also contains
  annotated regions determined by an expert who examined scatterplots of
  the coverage profiles.
}
\usage{data("chr11ChIPseq")}
\format{A named list of 2 data.frames: regions contains annotations
  about which regions contain or do not contain peaks, and coverage
  contains the noisy signal.}
\source{
  H3K4me3_TDH_immune chunk 5 in
  http://cbio.ensmp.fr/~thocking/chip-seq-chunk-db/
  which in turn comes from
  http://epigenomesportal.ca/
}
\examples{
data(chr11ChIPseq)
library(ggplot2)
ann.colors <-
  c(noPeaks="#f6f4bf",
    peakStart="#ffafaf",
    peakEnd="#ff4c4c",
    peaks="#a445ee")

if(interactive() && require(ggplot2)){

ggplot()+
  scale_fill_manual("annotation", values=ann.colors,
                    breaks=names(ann.colors))+
  penaltyLearning::geom_tallrect(aes(xmin=chromStart/1e3, xmax=chromEnd/1e3,
                    fill=annotation),
                data=chr11ChIPseq$regions, alpha=1/2)+
  theme_bw()+
  theme(panel.margin=grid::unit(0, "cm"))+
  facet_grid(sample.id ~ ., scales="free")+
  geom_step(aes(chromStart/1e3, count), data=chr11ChIPseq$coverage)+
  xlab("position on chr11 (kilo base pairs)")

}

}
\keyword{datasets}
