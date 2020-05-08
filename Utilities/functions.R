library(dplyr)

#add median per group (same pub_og_id)

AA_Comp_10$g_median<-ave(AA_Comp_10$width,AA_Comp_10$pub_og_id,FUN=median)

#sequences comprised in 15% of the group median

AA_Comp_10$Seq.pass<-with(AA_Comp_10, width>=g_median-g_median*0.15 & width<=g_median+g_median*0.15)

#fraction of group genes with Seq.pass = TRUE
AA_Comp_10$Group.pass<-ave(AA_Comp_10$Seq.pass,AA_Comp_10$pub_og_id,FUN=function (x) sum(x)/length(x))

#add median per group (same pub_og_id), Seq.pass (sequences comprised in 15% of the group median), Group.pass (orthogroups with 80% sequences with Seq.pass = TRUE)
                           
AA%>%group_by(pub_og_id)%>%
     mutate(median_width=median(width), 
            Seq.pass=( abs(width-median_width) <= median_width*0.2 ),
            Group.f=mean(Seq.pass), 
            Group.pass=(Group.f>=0.75) )
                           
pair_matrix=combn(Tax$name,2) 
#pairwise t.test function   
my.t.test.p.value <- function(...) {
    obj<-try(t.test(...), silent=TRUE)
    if (is(obj, "try-error")) return(NA) else return(obj$p.value)
}
pairwise_ttest<-function(col,g,pair_matrix){
  r<-apply(pair_matrix,2,function(x) my.t.test.p.value(col[g==x[1]],col[g==x[2]]))
  names(r)<-apply(pair_matrix,2,function(x) paste(x[1],x[2],"pvalue",sep="."))
  return(t(r))
}

#pairwise fold_change function     
pairwise_Log2FC<-function(col,g,pair_matrix){
  m<-sapply(unique(factor(pair_matrix)), function(x) mean(col[g==x]))
  names(m)<-unique(factor(pair_matrix))
  f<-apply(pair_matrix,2,function(x) log2(m[x[1]]/m[x[2]]))
  names(f)<-apply(pair_matrix,2,function(x) paste(x[1],x[2],"fold_change",sep="."))
  r<-cbind(t(m),t(f))
  return(r)
}

#Select valid sequences and groups       
AA_Comp_10<-AA_Comp_10 %>% 
   filter(Seq.pass)  %>%
   filter(Group.pass >= 0.8)%>% 
   group_by(pub_og_id)%>%
   filter(n()>=30) # eliminate groups erroneusly parsed

Res<-data.frame()
myList<-list()
                  
AA = names(AMINO_ACID_CODE[1:20])                 
for (aa in AA){
#Calculate pvalues (t-test) and fold change per groups
  df<-AA_Comp_10 %>% 
      group_by(pub_og_id) %>% 
      group_map(~ cbind(.y,AA=aa,
                  pairwise_ttest(.[[aa]],.[["Classification"]],pair_matrix),
                  pairwise_Log2FC(.[[aa]],.[["Classification"]],pair_matrix))) 
    
    myList=c(myList , l) #apped l to the list
    
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
Res<-cbind(Res[1],
           og_name=AAComp$og_name[match(Res$pub_og_id,AAComp$pub_og_id)],
           Res[-1])                           
                           
