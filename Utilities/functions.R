
#add median per group (same pub_og_id)

AA_Comp_10$g_median<-ave(AA_Comp_10$width,AA_Comp_10$pub_og_id,FUN=median)

#sequences comprised in 15% of the group median

AA_Comp_10$Seq.pass<-with(AA_Comp_10, width>=g_median-g_median*0.15 & width<=g_median+g_median*0.15)

#fraction of group genes with Seq.pass = TRUE
AA_Comp_10$Group.pass<-ave(AA_Comp_10$Seq.pass,AA_Comp_10$pub_og_id,FUN=function (x) sum(x)/length(x))

pair_matrix=combn(Tax$name,2) 
#pairwise t.test function   
my.t.test.p.value <- function(...) {
    obj<-try(t.test(...), silent=TRUE)
    if (is(obj, "try-error")) return(NA) else return(obj$p.value)
}
pairwise_ttest<-function(col,g,pair_matrix){
  m<-cbind(col,g)
  r<-apply(pair_matrix,2,function(x) my.t.test.p.value(m[m$g==x[1],1],m[m$g==x[2],1]))
  names(r)=apply(pair_matrix,2,function(x) paste(x[1],x[2],"pvalue",sep="."))
  as.data.frame(t(r))
}

#pairwise fold_change function     
pairwise_Log2FC<-function(col,g,pair_matrix){
  d<-cbind(col,g)
  m<-sapply(unique(factor(pair_matrix)), function(x) mean(d[d$g==x,1]))
  names(m)=unique(factor(pair_matrix))
  p<-apply(pair_matrix,2,function(x) log2(m[x[1]]/m[x[2]]))
  names(p)=apply(pair_matrix,2,function(x) paste(x[1],x[2],"fold_change",sep="."))
  r=cbind(t(m),t(p))
  as.data.frame(r)
}

#Select valid sequences and groups       
AA_Comp_10<-AA_Comp_10 %>% 
   filter(Seq.pass)  %>%
   filter(Group.pass >= 0.8)%>% 
   group_by(pub_og_id)%>%
   filter(n()>=30) # eliminate groups erroneusly parsed

Res<-data.frame()
myList<-list()
                  
AA = c("A","C","D","E","F","G","H","I","K","L","M","N","P","Q","R","S","T","V","W","Y")                 
for (aa in AA){
#Calculate pvalues (t-test) and fold change per groups
  df<-AA_Comp_10 %>% 
   group_by(pub_og_id) %>% 
   group_modify(~ cbind(data.frame(AA=aa),
                        pairwise_ttest(.[,aa],.$Classification,pair_matrix),
                        pairwise_Log2FC(.[,aa],.$Classification,pair_matrix))) %>% 
    
   myList[[length(myList)+1]] <- df
}
Res<-do.call(rbind.data.frame,myList)
                  
#correct pvalues for multiple tests
pV<-Res[,grepl("pvalue", names(Res))]
p_adj=matrix(p.adjust(as.vector(as.matrix(pV))),ncol=ncol(pV))
for(i in ncol(pV)){
  Res[ , names(pV)[i] ]<-p_adj[,i]
}

#Add orthogroup description (og_name) after Res[,1] (pub_og_id)                 
Res<-data.frame(Res[,1],
                data.frame(og_name=AA_Comp_10$og_name[match(Res$pub_og_id,AA_Comp_10$pub_og_id)]),
                Res[-1])                           
                           
