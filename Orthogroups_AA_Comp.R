#Retrieve Orthogroup information and FASTA sequences from OrthoDB using API
#(see https://www.orthodb.org/orthodb_userguide.html#api )

library(rjson)
library(Biostrings)
library(dplyr)
source("Functions.R")


#Calculate AA composition in orthogroups
#determine significant changes across vertebrate groups: Sauropsida, Mammalia, Actinopterygii


Seq_df<-data.frame() # main dataframe
myList<-list()

for(n in Tax$name){
  fname<-paste0("data/",n,".fa")
  seq<-readAAStringSet(fname)
  f<-alphabetFrequency(seq)
  
  df<-data.frame("Classification"=n,myParseOrthoFastaNames(names(seq)),"width"=width(seq),"seq_seq"=seq, f)
  myList[[length(myList)+1]] <- df #add df to myList
  print(paste(n,length(seq),"sequences"))
}
Seq_df<-do.call(rbind.data.frame,myList)
write.csv(Seq_df,"AA_Comp.csv", row.names = FALSE)

#Add median per group (same pub_og_id), Seq.pass (sequences comprised in 20% of the group median), Group.pass (orthogroups with 75% sequences with Seq.pass = TRUE)

Seq_df<-Seq_df%>%group_by(pub_og_id)%>%
  mutate(median_width=median(width), 
         Seq.pass=( abs(width-median_width) <= median_width*0.2 ),
         Group.f=mean(Seq.pass), 
         Group.pass=(Group.f>=0.75) )

#Create a new dataframe (AA_Comp) containing orthogroups with Group.pass>=0.75
AA_Comp<-Seq_df%>%filter(Seq.pass & Group.pass)%>% group_by(Classification)%>%group_by(pub_og_id)%>%filter(n()>=10)

write.csv(AA_Comp, file = "AA_Comp_Gp.csv", row.names=FALSE)

#Create a new dataframe (Res) with the values of pvalue (T-test) and fold change, obtained by pairwise comparisons between the three different classifications

pair_matrix=combn(Tax$name,2)


Res<-data.frame()
myList<-list()

AA = names(AMINO_ACID_CODE[1:20])
for (aa in AA){
  #Calculate pvalues (t-test) and fold change per groups
  print(paste("Calculating",aa))
  df<-AA_Comp %>% 
   group_by(pub_og_id) %>% 
    group_modify(~ cbind(data.frame(AA=aa),
                         pairwise_ttest(.[,aa],.$Classification,pair_matrix),
                         pairwise_Log2FC(.[,aa],.$Classification,pair_matrix)))
 
  
  myList[[length(myList)+1]] <- df
  
}
Res<-do.call(rbind.data.frame,myList)

#correct pvalues for multiple tests
pV<-Res[,grepl("pvalue", names(Res))]
p_adj=matrix(p.adjust(as.vector(as.matrix(pV))),ncol=ncol(pV))
for(i in 1:ncol(pV)){
  Res[ , names(pV)[i] ]<-p_adj[,i]
}

#Add orthogroup description (og_name) after Res[,1] (pub_og_id)                 
Res<-data.frame(Res[,1],
                data.frame(og_name=AA_Comp$og_name[match(Res$pub_og_id,AA_Comp$pub_og_id)]),
                Res[-1])                           

#Limit p-value<=2e-16 and fold change (abs value)>=1.5

Res<-Res%>%mutate(Pvalue.pass= Sauropsida.Mammalia.pvalue<=1e-16 | 
                     Sauropsida.Actinopterygii.pvalue<=1e-16 | 
                     Mammalia.Actinopterygii.pvalue<=1e-16,  
                   FC.pass= abs(Sauropsida.Mammalia.fold_change)>=1 | 
                     abs(Sauropsida.Actinopterygii.fold_change)>=1 | 
                     abs(Mammalia.Actinopterygii.fold_change)>=1)

write.csv(Res, file = "Res.csv", row.names=FALSE)
