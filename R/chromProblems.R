chromProblems <- function
### Divide a chromosome into a set of overlapping segmentation
### problems.
(chrom,
### character chromosome name.
 first.chromStart,
### Base before the first base on this chromosome.
 last.chromEnd,
### Last base on this chromosome.
 bases.per.problem
### How many bases in each segmentation problem?
 ){
  stopifnot(is.character(chrom))
  stopifnot(is.integer(first.chromStart))
  stopifnot(is.integer(last.chromEnd))
  stopifnot(is.integer(bases.per.problem))
  stopifnot(length(chrom)==1)
  stopifnot(length(first.chromStart)==1)
  stopifnot(length(last.chromEnd)==1)
  stopifnot(length(bases.per.problem)==1)
  problemEnd <-
    as.integer(seq(0, last.chromEnd, by=bases.per.problem/2)[-(1:3)])
  if(length(problemEnd) == 0){
    problemEnd <- peakEnd <- last.chromEnd
    problemStart <- peakStart <- first.chromStart
    problems <- 
      data.frame(chrom,
                 chromStart=problemStart,
                 peakStart,
                 peakEnd,
                 chromEnd=problemEnd)
  }else{
    problemStart <- as.integer(problemEnd-bases.per.problem)
    peakStart <- as.integer(problemStart + bases.per.problem/4)
    peakEnd <- as.integer(problemEnd - bases.per.problem/4)
    problems <- 
      data.frame(chrom,
                 chromStart=as.integer(c(0,
                   problemStart, problemEnd[length(problemEnd)-1])),
                 peakStart=as.integer(c(0,
                   peakStart, peakEnd[length(peakEnd)])),
                 peakEnd=as.integer(c(peakStart[1], peakEnd, last.chromEnd)),
                 chromEnd=as.integer(c(bases.per.problem,
                   problemEnd, last.chromEnd)))
  }
  problems$problem.name <- 
    with(problems, sprintf("%s:%09d-%09d", chrom, chromStart, chromEnd))
  problem.before <- problems$chromEnd < first.chromStart
  problems[!problem.before, ]
### data.frame with columns chromStart, peakStart, peakEnd, chromEnd,
### problem.name.
}
