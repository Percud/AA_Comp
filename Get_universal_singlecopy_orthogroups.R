#Retrieve Orthogroup information and FASTA sequences from orthodp using API
#(see https://www.orthodb.org/orthodb_userguide.html#api)

library(rjson)

#Get from orthodb orthogroups at the vertebrate level (taxid=7742)
#that are present in >90% of species and are single copy in >90% of species 
OGs<-fromJSON(file='https://www.orthodb.org//search?level=7742&universal=0.9&singlecopy=0.9&limit=5000')

Tax=list(id=c(8457,40674,7898),name=c("Sauropsida","Mammalia","Actinopterygii"))

for(OG in OGs$data[1:3]){
  for(i in 1:NROW(Tax$id)){
    URL<-paste("http://www.orthodb.org/fasta?id=",OG,"&species=",Tax$id[i],sep="")
    cat(URL,"\n")
    out<-system2("wget",args=c(" -q -O - ",URL),stdout=TRUE)
    file_name<-paste(Tax$name[i],"fa",sep=".")
    write(out, file=file_name, append=TRUE)
    Sys.sleep(0.1)
  }
}


