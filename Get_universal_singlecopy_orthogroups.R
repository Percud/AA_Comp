#Retrieve Orthogroup information and FASTA sequences from orthodp using API
#(see https://www.orthodb.org/orthodb_userguide.html#api)

library(rjson)
library(Biostrings)

#Get from orthodb orthogroups at the vertebrate level (taxid=7742)
#that are present in >90% of species and are single copy in >90% of species 
OGs<-fromJSON(file='https://www.orthodb.org//search?level=7742&universal=0.9&singlecopy=0.9&limit=5000')

Tax=list(id=c(8457,40674,7898),name=c("Sauropsida","Mammalia","Actinopterygii"))

for(OG in OGs$data[1:3]){
  for(i in 1:NROW(Tax$id)){
    url<-paste("http://www.orthodb.org/fasta?id=",OG,"&species=",Tax$id[i],sep="")
    seq<-readAAStringSet(open_input_files(url))
    file_name<-paste(Tax$id[i],"fa",sep=".")
    writeXStringSet(seq, file_name, append=TRUE)
    Sys.sleep(10)
  }
}


