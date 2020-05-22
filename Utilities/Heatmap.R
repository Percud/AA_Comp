#Heatmap
library(dplyr)
library(tidyr)

#tidy Res dataframe
Res_hm <- Res %>% select (pub_og_id,og_name,AA,Sauropsida.Mammalia.fold_change,Sauropsida.Actinopterygii.fold_change,Mammalia.Actinopterygii.fold_change) %>% 
                gather(comparisons,FC,"Sauropsida.Mammalia.fold_change","Sauropsida.Actinopterygii.fold_change","Mammalia.Actinopterygii.fold_change", convert=FALSE)  %>% 
                spread(AA,FC) %>%
                unite(pub_og_id_name,pub_og_id,og_name, sep = "_", remove = TRUE)

Res_hmSM <- Res_hm %>% filter (comparisons=="Sauropsida.Mammalia.fold_change")
Res_hmSM_matrix <- as.matrix(Res_hmSM[c(-1,-2)])
row.names(Res_hmSM_matrix) <- Res_hmSM$pub_og_id_name

#create heatmap
hmcol<-colorRampPalette(c("blue","white","red"))(256)
pdf("heatmapSM.pdf", width = 25, height = 10)
heatmap(Res_hmSM_matrix, col=hmcol)

dev.off()
