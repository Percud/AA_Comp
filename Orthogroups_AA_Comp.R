#Calculate AA composition in orthogropus
#determine significant changes across vertebrate phyla

library(rjson)
library(Biostrings)

Tax=list(id=c(8457,40674,7898),name=c("Sauropsida","Mammalia","Actinopterygii"))

Seq_df<-data.frame() # main dataframe

for(n in Tax$name){
    fname<-paste0("data/",n,"_10.fa")
    seq<-readAAStringSet(fname)
    f<-alphabetFrequency(seq)
   
    df<-data.frame("Classification"=n,myParseOrthoFastaNames(names(seq)),f)
    L<-list(L,df)
}
Seq_df<-do.call(rbind.data.frame,L)
str(Seq_df)

myParseOrthoFastaNames<-function(x)
{
    seq_id<-gsub('^(\\S+).*','\\1',x)            #vector of ids
    seq_def<-gsub('.*(\\{.*\\})','\\1',x)        #vector of def (json format)        
    def_df<-do.call(rbind.data.frame,lapply(seq_def,fromJSON)) #apply fromJSON to seq_def, return a data.frame 
    
    return(data.frame("seq_id"=seq_id,def_df))
}
