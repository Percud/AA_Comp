
library(rjson)

#Get from orthodb orthogroups at the vertebrate level (taxid=7742)
#that are present in >90% of species and are single copy in >90% of species 
OGs<-fromJSON(file='https://www.orthodb.org//search?level=7742&universal=0.9&singlecopy=0.9&limit=5000')


