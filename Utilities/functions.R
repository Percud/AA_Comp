
#add median per group (same pub_og_id)

AA_Comp_10$g_median<-ave(AA_Comp_10$width,AA_Comp_10$pub_og_id,FUN=median)

#sequences comprised in 15% of the group median

AA_Comp_10$Seq.pass<-with(AA_Comp_10, width>=g_median-g_median*0.15 & width<=g_median+g_median*0.15)

#fraction of group genes with Seq.pass = TRUE
AA_Comp_10$Group.pass<-ave(AA_Comp_10$Seq.pass,AA_Comp_10$pub_og_id,FUN=function (x) sum(x)/length(x))

#pairwise test
pairwise=combn(Tax$name,2)                           
format_ttest <- function (x){
  p=x[['p.value']]
  m<-apply(pairwise , 2 , function (x) p[x[1],x[2]])
  names(m)<-apply(pairwise , 2, function (x) paste(x[1],x[2],'pvalue',sep="."))
  return(as.data.frame(t(m)))
}
for aa in c("A","C"){  
t<-AA_Comp_10 %>% 
   filter(Seq.pass)  %>%
   filter(Group.pass >= 0.8)  %>% 
   group_by(pub_og_id) %>% 
   do(format_ttest(pairwise.t.test(.[[aa]],.[["Classification"]],p.adjust.method='none'))) %>%
   mutate(.,AA=aa)
}
                           
#correct pvalues for multiple tests
pV<-AA_Comp_10[,grepl("pvalue", names(AA_Comp_10))]
AA_Comp_10[, names(pV)]<-matrix(p.adjust(as.vector(as.matrix(pV))),ncol=ncol(pV))

                           
                           
