
g_median = function(T, seq_id) {

  gene<-T[which(T$seq_id == seq_id),]
  #data.frame of sequence widths for the same Classification and pub_og_id as seq_id
  widths<-T[which(T$Classification == gene$Classification & T$pub_og_id == gene$pub_og_id), "width"]
  
return(median(widths[['withd']]))
}
  
