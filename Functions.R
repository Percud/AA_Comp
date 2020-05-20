#convert JSON format in a dataframe function
myParseOrthoFastaNames<-function(x)
{
  regex='^(\\S+)\\s+(\\{.*\\})'    #(id) (def) /def is in JSON format: {...}/
  id<-sub(regex,'\\1',x)         #vector of ids
  def<-sub(regex,'\\2\\',x)  #vector of def (add missing {...})        
  df<-do.call(rbind.data.frame,lapply(def,fromJSON)) #apply fromJSON to def, convert in a dataframe 
  return(data.frame("seq_id"=id, df))
}    

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