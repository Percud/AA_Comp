#Plot aa ditribution using ggplot2
#Plot_Orthogroup.R pub_og_id|all [aa]

library(ggplot2)
library(dplyr)
library(gridExtra)
library(grid)

Taxa=c("Actinopterygii","Sauropsida","Mammalia")
aa = c("A","C","D","E","F","G","H","I","K","L","M","N","R","P","Q","S","T","Y","W","V")
args = commandArgs(trailingOnly=TRUE)


fname="AA_Comp_10.csv"
df<-read.csv(fname,  header=TRUE)

og<-args[1]
if (length(args)==2){
  aa<-args[2]
}

if (args[1]!="all"){
  df <- filter(df, pub_og_id==og)
}

x=df[['Classification']]

pdf(file = "aaPlot.pdf", width = 14, height = 10) # defaults to 7 x 7 inches


if (length(aa)==1){ #single plot
  ggplot(df,aes(x=x,y=aa))+geom_boxplot()+scale_x_discrete(name="",limits=Taxa)+ylab(paste("Number of",aa,"in the sequence"))
} else { #multi plot
  pltList<-lapply(aa,function(i){ggplot(df,aes(x=x,y=i))+geom_boxplot()+scale_x_discrete(name="",limits=Taxa)+ylab(paste("Number of",i,"in the sequence"))})
  do.call(grid.arrange, c(pltList, ncol=5))
}

dev.off()






