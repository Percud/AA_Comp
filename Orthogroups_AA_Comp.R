#Calculate AA composition in orthogropus
#determine significant changes across vertebrate phyla

library(rjson)
library(Biostrings)

Tax=list(id=c(8457,40674,7898),name=c("Sauropsida","Mammalia","Actinopterygii"))

myParseOrthoFastaNames<-function(x)
{
    regex='^(\\S+)\\s+\\{*(.*\\S+)\\}*'    #(id) (def) /def is in JSON format: {...}/
    id<-sub(regex,'\\1',x)         #vector of ids
    def<-sub(regex,'\\{\\2\\}',x)  #vector of def (add missing {...})        
    df<-do.call(rbind.data.frame,lapply(def,fromJSON)) #apply fromJSON to def, convert in a data.frame 
 return(data.frame("seq_id"=id, df))
}    

Seq_df<-data.frame() # main dataframe
myList<-list()

for(n in Tax$name){
    fname<-paste0("data/",n,".fa")
    seq<-readAAStringSet(fname)
    f<-alphabetFrequency(seq)
   
    df<-data.frame("Classification"=n,myParseOrthoFastaNames(names(seq)),"width"=width(seq),"seq_seq"=seq, f)
    myList[[length(myList)+1]] <- df #add df to myList 
}
Seq_df<-do.call(rbind.data.frame,myList)
write.csv(Seq_df,"AA_Comp.csv", row.names = FALSE)


