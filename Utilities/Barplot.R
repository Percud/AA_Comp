#Bar plots

library(dplyr)
library(ggplot2)

Tax=list(id=c(8457,40674,7898),name=c("Sauropsida","Mammalia","Actinopterygii"))
pair_matrix=combn(Tax$name,2) 
args=commandArgs(trailingOnly=TRUE)

Res<-read.csv(args[1], header=TRUE)
pvalue.max<-args[2]
FC.min<-args[3]
FC.max<-args[4]

for(i in 1:ncol(pair_matrix)){
  m<-c(pair_matrix[1,i],pair_matrix[2,i])
  pv<-(paste0(pair_matrix[1,i],".",pair_matrix[2,i],".pvalue"))
  FC<-(paste0(pair_matrix[1,i],".",pair_matrix[2,i],".fold_change"))
  
  df<-Res %>% filter(.[m[1]]>=10 | .[m[2]]>=10) %>% 
    filter(.[pv]<=pvalue.max)   %>% 
    group_by(AA) %>% 
    group_modify (~ summarize(.x,up=sum(.[FC]>=FC.min), down=-sum(.[FC]<=FC.max))) %>%
    arrange(desc(up-abs(down)))
  
  #reshape
  df<-reshape(as.data.frame(df), v.names="count", timevar="var",times = c("up","down"), varying= c("up","down"), direction="long")
  
  print(ggplot(df, aes(x=reorder(AA,id) ,y=count,fill=var)) + geom_bar(stat="identity") + ggtitle(paste(pv,"<=",pvalue.max,"\n",FC.max,"<=",FC,">=",FC.min)) +
          xlab("AA") + ylab("Orthogroups count"))
  
  readline(prompt=paste(i,"- Press [enter] to continue"))
}
