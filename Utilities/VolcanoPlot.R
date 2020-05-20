library(EnhancedVolcano)
library(Biostrings)
Tax=list(id=c(8457,40674,7898),name=c("Sauropsida","Mammalia","Actinopterygii"))
pvCutoff=1e-16
FCCutoff=1
pair_matrix=combn(Tax$name,2) 

AA = names(AMINO_ACID_CODE[1:20])

for(i in 1:ncol(pair_matrix)){
  m<-c(pair_matrix[1,i],pair_matrix[2,i])
  comp<-paste0(pair_matrix[1,i],".",pair_matrix[2,i])
  pv<-paste0(comp,".pvalue")
  FC<-paste0(comp,".fold_change")
  
  df<-Res%>% filter(.[m[1]]>=10 | .[m[2]]>=10) 
  
  for (aa in AA){  
    dfaa<-df%>%filter(AA==aa)
    title<-paste(comp,aa,sep=".")
    pdf(file=paste0(title,".pdf"), width = 15, height = 10)
    print(EnhancedVolcano(dfaa, lab=dfaa$og_name, x=FC, y=pv, 
                    pCutoff = pvCutoff, FCcutoff = FCCutoff, subtitle=title))
    dev.off()
    
  }
}
