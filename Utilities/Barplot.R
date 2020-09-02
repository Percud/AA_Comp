#Bar plots

library(dplyr)
library(ggplot2)

Tax=list(id=c(8457,40674,7898),name=c("Sauropsida","Mammalia","Actinopterygii"))
pair_matrix=combn(Tax$name,2) 

Res<-read.csv("Res.csv", header=TRUE)

for(i in 1:ncol(pair_matrix)){
  m<-c(pair_matrix[1,i],pair_matrix[2,i])
  pv<-(paste0(pair_matrix[1,i],".",pair_matrix[2,i],".pvalue"))
  FC<-(paste0(pair_matrix[1,i],".",pair_matrix[2,i],".fold_change"))
  
  df<-Res %>% filter(.[m[1]]>=10 | .[m[2]]>=10) %>% 
    filter(.[pv]<=1e-16)   %>% 
    group_by(AA) %>% 
    group_modify (~ summarize(.x,up=sum(.[FC]>=1.5), down=-sum(.[FC]<=-1.5))) %>%
    arrange(desc(up-abs(down)))
  
  #reshape
  df<-reshape(as.data.frame(df), v.names="count", timevar="var",times = c("up","down"), varying= c("up","down"), direction="long")
  
  print(ggplot(df, aes(x=reorder(AA,id) ,y=count,fill=var)) + geom_bar(stat="identity") + ggtitle(paste(pv,"<=1e-16","\n","-1<=",FC,">=1")) +
          xlab("AA") + ylab("Orthogroups count"))
  
  readline(prompt=paste(i,"- Press [enter] to continue"))
}
