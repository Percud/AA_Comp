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

for a in aa{
  df[[a]]<-df[[a]]/df$width*100 #percentage
}

x=df[['Classification']]

pdf(file = "aaPlot.pdf", width = 15, height = 10) # defaults to 7 x 7 inches

#geom_violin(fill="gray")+stat_summary(fun.data="mean_cl_boot", colour="red", size=1)+theme_classic()


if (length(aa)==1){ #single plot
  qplot(x,df[[aa]],geom="blank")+scale_x_discrete(name="",limits=Taxa)+ylab(paste("Number of",aa,"in the sequence"))+
  geom_boxplot(outlier.shape = NA) + geom_jitter(width = 0.2)
} else { #multi plot
  pltList<-lapply(aa,function(i){qplot(x,df[[i]],geom="blank")+scale_x_discrete(name="",limits=Taxa)+ylab(paste("Number of",i,"in the sequence"))+
  #geom_boxplot(outlier.shape = NA) + geom_jitter(width = 0.2)
  geom_boxplot(outlier.shape = NA)+ ylim(0,100)})
  do.call(grid.arrange, c(pltList, ncol=5))
}
warnings()
dev.off()






