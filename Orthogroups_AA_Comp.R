#Calculate AA composition in orthogropus
#determine significant changes across vertebrate phyla

library(rjson)
library(Biostrings)

Tax=list(id=c(8457,40674,7898),name=c("Sauropsida","Mammalia","Actinopterygii"))

myParseOrthoFastaNames<-function(x)
{
    seq_id<-gsub('^(\\S+).*','\\1',x)            #vector of ids
    seq_def<-gsub('.*(\\{.*\\})','\\1',x)        #vector of def (json format)        
    def_df<-do.call(rbind.data.frame,lapply(seq_def,fromJSON)) #apply fromJSON to seq_def, return a data.frame 
 return(data.frame("seq_id"=seq_id,def_df))
}    

Seq_df<-data.frame() # main dataframe
myList<-list()

for(n in Tax$name){
    fname<-paste0("data/",n,"_10.fa")
    seq<-readAAStringSet(fname)
    f<-alphabetFrequency(seq)
   
    df<-data.frame("Classification"=n,myParseOrthoFastaNames(names(seq)),f)
    myList[[length(myList)+1]] <- list(df)
}
Seq_df<-do.call(rbind.data.frame,myList)
str(Seq_df)


