#Calculate AA composition in orthogropus
#determine significant changes across vertebrate phyla

library(rjson)
library(Biostrings)

Tax=list(id=c(8457,40674,7898),name=c("Sauropsida","Mammalia","Actinopterygii"))

myParseOrthoFasta<-function(x)
{
    seq_id<-gsub('^(\\S+).*','\\1',names(x))            #vector of ids
    seq_def<-gsub('.*(\\{.*\\})','\\1',names(x))        #vector of def (json format)        
    df<-do.call(rbind.data.frame,lapply(seq_def,fromJSON)) #apply fromJSON to seq_def, return a data.frame 
 return(data.frame("seq_id"=seq_id,df,"width"=with(x),"seq_seq"=x))
}    

Seq_df<-data.frame() # main dataframe
myList<-list()

for(n in Tax$name){
    fname<-paste0("data/",n,"_10.fa")
    seq<-readAAStringSet(fname)
    f<-alphabetFrequency(seq)
   
    df<-data.frame("Classification"=n,myParseOrthoFasta(seq),f)
    myList[[length(myList)+1]] <- df #add df to myList 
}
Seq_df<-do.call(rbind.data.frame,myList)
write.csv(Seq_df,"AA_Comp.csv", row.names = FALSE)


