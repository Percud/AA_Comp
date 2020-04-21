
#add median per group (same Classification & pub_og_id)

AA_Comp_10$g_median<-ave(AA_Comp_10$width,AA_Comp_10$pub_og_id,FUN=median)

#sequences comprised in 15% of the group median

AA_Comp_10$Seq.pass<-with(AA_Comp_10, width>=g_median-g_median*0.15 &width<=g_median+g_median*0.15)

#fraction of group genes with Seq.pass = TRUE
AA_Comp_10$Group.pass<-ave(AA_Comp_10$Seq.pass,AA_Comp_10$pub_og_id,FUN=function (x) sum(x)/length(x))
