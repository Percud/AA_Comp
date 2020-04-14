#Plot aa ditribution using ggplot2

library(ggplot2)
library(dplyr)

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  args[2] = "C"
}

fname="AA_Comp.csv"

og<-args[1]
aa<-args[2]

df<-read.csv(fname,  header=TRUE)

df_o <- filter(df, pub_og_id==og)

qplot('Classification','C',data=df_o)+geom_boxplot()+geom_jitter()+scale_x_discrete(name="",limits=c("Actinopterygii","Sauropsida","Mammals"))+ylab(paste("Number of",aa,"in the sequence"))
