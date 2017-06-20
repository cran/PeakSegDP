normalizeDir <- function
### If an input file is a symbolic link to a file that we can read
### (which is in a directory that we can NOT write), we want to
### de-reference the directory (to which we can write) containing the
### input file/link.
(relative.path
### character: input file, possible a relative path to a symbolic
### link.
 ){
  absolute.dir <- normalizePath(dirname(relative.path), mustWork=TRUE)
  file.path(absolute.dir, basename(relative.path))
### absolute path to the symbolic link (not the target of the link).
}
