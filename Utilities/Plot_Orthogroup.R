#Plot aa ditribution using ggplot2

library(ggplot2)

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  args[2] = "C"
}

fname<-arg[1]
aa<-arg[2]




