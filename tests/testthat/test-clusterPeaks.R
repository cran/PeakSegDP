context("clusterPeaks")

unordered <-
  data.frame(chromStart=c(11, 12, 1, 2, 3, 6, 7),
             chromEnd=c(13, 14, 5, 8, 4, 9, 10),
             sample.id=factor(c(1, 2, 1, 2, 3, 4, 5)))

test_that("2 clusters detected in unordered data", {
  clustered <- clusterPeaks(unordered)
  expect_equal(clustered$cluster, c(0,0,0,0,0,1,1))
  expect_true(is.factor(clustered$sample.id))
})

ordered <- unordered[order(unordered$chromStart), ]

test_that("2 clusters detected in ordered data", {
  clustered <- clusterPeaks(ordered)
  expect_equal(clustered$cluster, c(0,0,0,0,0,1,1))
  expect_true(is.factor(clustered$sample.id))
})

test_that("(1, 10] does not overlap (10, 20]", {
  p <- data.frame(chromStart=c(1, 10), chromEnd=c(10, 20))
  cl <- clusterPeaks(p)
  expect_equal(cl$cluster, c(0, 1))
})

test_that("(1, 9] does not overlap (10, 20]", {
  p <- data.frame(chromStart=c(1, 10), chromEnd=c(9, 20))
  cl <- clusterPeaks(p)
  expect_equal(cl$cluster, c(0, 1))
})

test_that("(1, 11] does overlap (10, 20]", {
  p <- data.frame(chromStart=c(1, 10), chromEnd=c(11, 20))
  cl <- clusterPeaks(p)
  expect_equal(cl$cluster, c(0, 0))
})

test_that("(1, 10] does overlap (9, 20]", {
  p <- data.frame(chromStart=c(1, 9), chromEnd=c(10, 20))
  cl <- clusterPeaks(p)
  expect_equal(cl$cluster, c(0, 0))
})

test_that("(1, 10] does not overlap (11, 20]", {
  p <- data.frame(chromStart=c(1, 11), chromEnd=c(10, 20))
  cl <- clusterPeaks(p)
  expect_equal(cl$cluster, c(0, 1))
})

