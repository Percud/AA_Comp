#Plot aa ditribution using ggplot2

library(ggplot2)
library(dplyr)
library(gridExtra)
library(grid)

aa = c("A","C","D","E,","F","G","H","I","K","L","M","N","R","P","Q","S","T","Y","W","V")
args = commandArgs(trailingOnly=TRUE)


fname="AA_Comp.csv"
df<-read.csv(fname,  header=TRUE)

og<-args[1]
if (length(args)==2){
  aa<-args[2]
}

if (args[1]!="all"){
  df <- filter(df, pub_og_id==og)
}

x=df[['Classification']]

if (length(aa)>=2){
  y=df[[aa]]
  qplot(x,y)+geom_boxplot()+geom_jitter()+scale_x_discrete(name="",limits=c("Actinopterygii","Sauropsida","Mammalia"))+ylab(paste("Number of",aa,"in the sequence"))
} else {
  plt_array<-apply(aa,function(i){qplot(x,df[[i]])+geom_boxplot()+geom_jitter()+scale_x_discrete(name="",limits=c("Actinopterygii","Sauropsida","Mammalia"))+ylab(paste("Number of",i,"in the sequence"))})
  grid.arrange(plt_array, ncol=5, top=textGrob("AA", gp=gpar(fontsize=12, font = 2)))
}






