library(DECIPHER)
library(msa)
library(odseq)
library(taxizedb)
 
args=commandArgs(trailingOnly=TRUE)

AA_Comp<-read.csv(args[1], header=TRUE)
aa<-args[2]
og_id<-args[3]

max_seq=50
max_id=0.9 #max id in clusters
elim=FALSE #eliminate odd seq
set.seed(100)
 
aln_out<-paste0(og_id,"_aln")
tree_out<-paste0(og_id,"_tree")
 

seq=mySelectSeq(AA_Comp,og_id,TRUE)
#Eliminate seq with 'X' in the sequence
seq<-seq[-grep("X",seq)]
 

mySelectSeq<-function(t,og,pass){
  
  m<-as.matrix(t[which(t$pub_og_id==og & t$Seq.pass==pass),c("seq_seq","seq_id","Classification")])
  s<-AAStringSet(m[,1])
  names(s)<-paste(m[,2],og,m[,3],sep="_")
  
  return(s)
}
 
mySelectClusters<-function(seq,max_id){
  #Clustering with DECIPHER
  inexact <- IdClusters(myXStringSet=seq, method="inexact", cutoff=(1-max_id))
  #One sequence per cluster
  c<-aggregate(rownames(inexact) ~ cluster,inexact,head,1)
  
  return(seq[c[["rownames(inexact)"]]])
}
 

#get species names according to taxonomy
n<-sub("(\\d+).*","\\1",names(seq)) #taxid
g<-sub(".*_(\\S+)","\\1",names(seq))#group
tax<-apply(cbind(n,g),1, function(x) paste(taxid2name(x[1]),x[2]))
 
#change name if taxid is not recognized
tax[grep("NA ",tax)]<-paste(n[grep("NA ",tax)], g[grep("NA ",tax)])
 
#add numbers for unicity
names(seq)<-sapply(1:length(seq), function(i) paste0("X",i," ",tax[i]))
 

#select a non reduntant dataset (id<90%)
seq<-mySelectClusters(seq,max_id)
 

#select max seq
seq<-sample(seq,min(c(max_seq, length(seq)) ))
 
#Align with Clustalo algorithm
seq_aln<-msa(seq)
 
#Eliminate misaligned (outlier) sequences
odd<-odseq(seq_aln, distance_metric = "affine", B = 10000)
if (elim) seq_aln@unmasked<-unmasked(seq_aln)[which(odd==FALSE)]
print(paste("Selected:",min(c(max_seq, length(seq))),"Odds:",sum(odd)))
 
#Remove columns with common gaps
seq_aln@unmasked<-RemoveGaps(unmasked(seq_aln), "common")
 
#Shade aa in the alignment
texcode<-paste("\\shadingmode{functional}",
               paste0("\\funcgroup{",aa,"}","{",aa,"}","{White}{Red}{upper}{up}"),
               "\\shadeallresidues",sep="\n")
 
msaPrettyPrint(seq_aln,output="pdf",
               file=paste0(aln_out,".pdf"),
               alFile=paste0(aln_out,".fasta"),
               showConsensus="none",
               shadingModeArg="rasmol",
               shadingMode="functional",
               furtherCode=texcode,
               askForOverwrite=FALSE)
 
print (paste("written algnments:", paste0(aln_out,".pdf"),paste0(aln_out,".fasta")))
 
################## Tree #####################
library(phangorn)
dm = dist.ml(as.phyDat(seq_aln), model="JTT")
T<-NJ(dm)
#plot(T,"unrooted")
pdf(paste0(tree_out,".pdf"), width = 8.3, height = 11.7)
plot(midpoint(T),main=paste(og_id,"midpoint nj tree"))
dev.off()
print (paste("written tree:", paste0(tree_out,".pdf")))
#############################################
