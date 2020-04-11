#Retrieve Orthogroup information and FASTA sequences from orthodp using API
#(see https://www.orthodb.org/orthodb_userguide.html#api)

library(rjson)

#Get from orthodb orthogroups at the vertebrate level (taxid=7742)
#that are present in >90% of species and are single copy in >90% of species 
OGs<-fromJSON(file='https://www.orthodb.org//search?level=7742&universal=0.9&singlecopy=0.9&limit=5000')

for(OG in OGs$data[1:10]){
  #Sauropsida - taxid:8457   
  url=paste("http://www.orthodb.org/fasta?id=",OG,"&species=","8457",sep="")
  seq<-readAAStringSet(open_input_files(url)
  writeXStringSet(x, "Sauropsida.fa", append=TRUE)
  #Mammalia - taxid:40674 
  url=paste("http://www.orthodb.org/fasta?id=",OG,"&species=","40674",sep="")
  seq<-readAAStringSet(open_input_files(url)
  writeXStringSet(x, "Mammalia.fa", append=TRUE)
  #Actinopterygii - taxid:7898 
  url=paste("http://www.orthodb.org/fasta?id=",OG,"&species=","7898",sep="")
  seq<-readAAStringSet(open_input_files(url)
  writeXStringSet(x, "Fishes.fa", append=TRUE) 
}


