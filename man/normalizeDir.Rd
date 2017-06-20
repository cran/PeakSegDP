\name{normalizeDir}
\alias{normalizeDir}
\title{normalizeDir}
\description{If an input file is a symbolic link to a file that we can read
(which is in a directory that we can NOT write), we want to
de-reference the directory (to which we can write) containing the
input file/link.}
\usage{normalizeDir(relative.path)}
\arguments{
  \item{relative.path}{character: input file, possible a relative path to a symbolic
link.}
}

\value{absolute path to the symbolic link (not the target of the link).}

\author{Toby Dylan Hocking, Guillem Rigaill}





