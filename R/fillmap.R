######################################################################

#' Create maps with SpatialPolygons objects
#'
#' This function offers several options for creating plots with SpatialPolygons objects. This can be a single plot or multiple plots. These multi-plots can have the same legend or individual legends. Additionally, the layout call within this function offers many options for improving the resulting figures.
#' @param map The SpatialPolygon object.
#' @param figtitle The title to be displayed on the map(s). Can be of length 1 or more.
#' @param y The vector or matrix object to be mapped.
#' @param n.col The number of legend levels.
#' @param bk The break specifications defaults to "e" for equal. Other options are "c" to specify your own breaks and "q" for quantile breaks.
#' @param cuts The cuts to be specified when bk="c".
#' @param legendtxt The text to be displayed in the legend (must be NA (which removes the text altogether) or equal length n.col+1). Defaults to "" which creates text based on the cuts. 
#' @param leg.loc The loation for the legend defaults to "bottomright". Can also be given as a list of x,y coordinates
#' @param leg.common Indicates if a common legend is to be used in the multiple plotting setting. Defaults to FALSE.
#' @param lay.m The matrix to be supplied to the layout call. Defaults to matrix(1) for a single plot.
#' @param lay.wid Specifies the widths for the layout call. Defaults to rep.int(1,ncol(lay.m)).
#' @param lay.hei Specifies the heights for the layout call. Defaults to rep.int(1,nrow(lay.m)).
#' @param leg.cex Specifies the font size in the legend. Defaults to 1.5.
#' @param main.cex Specifies the font size for the title. Defaults to 1.5.
#' @param main.line Specifies the line for the title of the plot to appear on. Defaults to -2.
#' @param leg.horiz Indicates if the legend should be horizontal. Defaults to FALSE.
#' @param map.lty Specifies the line type for the plot. Defaults to 1.
#' @keywords disease mapping 
#' @export
#' @examples
#' Sr1 = Polygon(cbind(c(0,0,1,1,0),c(0,1,1,0,0)))
#' Sr2 = Polygon(cbind(c(0,1,1,0,0),c(0,0,-1,-1,0)))
#' Sr3 = Polygon(cbind(c(0,-1,-1,0,0),c(0,0,1,1,0)))
#' Sr4 = Polygon(cbind(c(0,0,-1,-1,0),c(0,-1,-1,0,0)))
#' Sr5 = Polygon(cbind(c(1,1,2,2,1),c(0,1,1,0,0)))
#' Sr6 = Polygon(cbind(c(0,2,2,1,1),c(0,0,-1,-1,0)))
#' Sr7 = Polygon(cbind(c(-1,-1,0,0,-1),c(1,2,2,1,1)))
#' Sr8 = Polygon(cbind(c(-1,-2,-2,-1,-1),c(1,1,2,2,1)))
#' Sr9 = Polygon(cbind(c(0,0,1,1,0),c(1,2,2,1,1)))
#' Sr10 = Polygon(cbind(c(-2,-2,-1,-1,-2),c(-2,-1,-1,-2,-2)))
#' Sr11 = Polygon(cbind(c(-2,-3,-3,-2,-2),c(-2,-2,-1,-1,-2)))
#' Sr12 = Polygon(cbind(c(-1,-1,0,0,-1),c(-2,-1,-1,-2,-2)))
#' Srs1 = Polygons(list(Sr1), "s1")
#' Srs2 = Polygons(list(Sr2), "s2")
#' Srs3 = Polygons(list(Sr3), "s3")
#' Srs4 = Polygons(list(Sr4), "s4")
#' Srs5 = Polygons(list(Sr5), "s5")
#' Srs6 = Polygons(list(Sr6), "s6")
#' Srs7 = Polygons(list(Sr7), "s7")
#' Srs8 = Polygons(list(Sr8), "s8")
#' Srs9 = Polygons(list(Sr9), "s9")
#' Srs10 = Polygons(list(Sr10), "s10")
#' Srs11 = Polygons(list(Sr11), "s11")
#' Srs12 = Polygons(list(Sr12), "s12")
#' SpP = SpatialPolygons(list(Srs1,Srs2,Srs3,Srs4,Srs5,Srs6,Srs7,Srs8,Srs9,
#' 	Srs10,Srs11,Srs12), 1:12)
#' 
#' vmat=matrix(runif(12*3,0,1),nrow=12,ncol=3)
#' par(mai=c(0,0,0,0),mar=c(0.1,0,0,0))
#' fillmaps(SpP,c("","Example 1",""),vmat,n.col=3,bk="c",
#' 	cuts=seq(min(vmat),max(vmat),length=4),main.cex=2,leg.cex=2,
#' 	leg.loc="top",leg.common=T,lay.hei=c(.8,.2),leg.horiz=T,
#' 	lay.m=matrix(c(1,2,3,4,4,4),ncol=3,nrow=2,byrow=T))
#' 


fillmaps<-function(map, figtitle, y , n.col, bk="e", cuts,legendtxt="",
	leg.loc="bottomright",leg.common=F,lay.m=matrix(1),
	lay.wid=rep.int(1, ncol(lay.m)),leg.cex=1.5,main.cex=1.5,main.line=-2,
	lay.hei=rep.int(1, nrow(lay.m)),leg.horiz=F,map.lty=1){

# map can be a SpatialPolygons object from readSPlus for GEOBUGS conversion
# eg geobugs<-readSplus("SC_geobugsSPLus.txt")

#for multiple plots 
if(length(dim(y))>2){print("Cannot handle y of dim > 2")}
else if(length(dim(y))==2 & dim(y)[which(dim(y)!=length(map))]>1){
layout(lay.m,widths=lay.wid,heights=lay.hei)

#legend per plot gen
if (leg.common==F){
for (i in 1:dim(y)[which(dim(y)!=length(map))]){if (
	which(dim(y)!=length(map))==1) {y1=y[i,]} else {y1=y[,i]}

if(bk=="q"){p <- seq(0,1, length=n.col+1)
      br <- round(quantile(y1, probs=p),2)}
if(bk=="e"){br <- round(seq(min(y1), max(y1), length=n.col+1),6)}
if(bk=="c"){if (length(cuts)!= (n.col+1)) {print("Cut off and color categories 
	do not match.\n")
      break}  else {br <- cuts}  }

# 0: dark 1: light light Current shading ranges from darkest to light gray white (to distinguish with lakes).
shading<-gray(rev(0:(n.col-1)/(n.col-1)))
#shading<-hsv(.6,alpha=0:(n.col-1)/(n.col-1))
y1.grp<-findInterval(y1, vec=br, rightmost.closed = TRUE, all.inside = TRUE)
y1.shad<-shading[y1.grp]

plot(map,col=y1.shad,axes=F, lty=map.lty)
title(main=figtitle[i],cex.main=main.cex,line=main.line) 

br<-round(br, 2)
if (is.na(legendtxt[1])){print("No legend specifed")
} else if (legendtxt[1]==""){
 	leg.txt<-paste("[",br[n.col],",",br[n.col+1],"]",sep="")
	for(j in (n.col-1):1){ 
		leg.txt<-append(leg.txt,paste("[",br[j],",",br[j+1],")",sep="")) }
		leg.txt<-rev(leg.txt)
	legend(leg.loc,legend=leg.txt,fill=shading,cex=leg.cex,ncol=1,bty="n",
		horiz=leg.horiz)
} else if (length(legendtxt) != n.col){cat("Length of lengendtxt must equal 
		n.col", "\n")
            break
} else {leg.txt<-legendtxt
	legend(leg.loc,legend=leg.txt,fill=shading,cex=leg.cex,ncol=1,bty="n",
		horiz=leg.horiz)}}
} #close i loop 

#common legend
if (leg.common==T){
for (i in 1:dim(y)[which(dim(y)!=length(map))]){if (
	which(dim(y)!=length(map))==1) {y1=y[i,]} else {y1=y[,i]} 
if(bk=="q"){p <- seq(0,1, length=n.col+1)
      br <- round(quantile(y, probs=p),2)}
if(bk=="e"){br <- round(seq(min(y), max(y), length=n.col+1),6)}
if(bk=="c"){if (length(cuts)!= (n.col+1)) {print("Cut off and color categories 
	do not match.\n")
      break}  else {br <- cuts}  }

# 0: dark 1: light light Current shading ranges from darkest to light gray white (to distinguish with lakes).
shading<-gray(rev(0:(n.col-1)/(n.col-1)))
#shading<-hsv(.6,alpha=0:(n.col-1)/(n.col-1))
y1.grp<-findInterval(y1, vec=br, rightmost.closed = TRUE, all.inside = TRUE)
y1.shad<-shading[y1.grp]

plot(map,col=y1.shad,axes=F, lty=map.lty)
title(main=figtitle[i],cex.main=main.cex,line=main.line) 

}	# close i loop

plot(1, type = "n", axes=FALSE, xlab="", ylab="")
br<-round(br, 2)
if (is.na(legendtxt[1])){print("No legend specifed")
} else if (legendtxt[1]==""){
 	leg.txt<-paste("[",br[n.col],",",br[n.col+1],"]",sep="")
	for(j in (n.col-1):1){ 
		leg.txt<-append(leg.txt,paste("[",br[j],",",br[j+1],")",sep="")) }
		leg.txt<-rev(leg.txt)
	legend(leg.loc,legend=leg.txt,fill=shading,cex=leg.cex,ncol=1,bty="n",
		horiz=leg.horiz)
} else if (length(legendtxt) != n.col){cat("Length of lengendtxt must equal 
		n.col", "\n")
            break
} else {leg.txt<-legendtxt
	legend(leg.loc,legend=leg.txt,fill=shading,cex=leg.cex,ncol=1,bty="n",
		horiz=leg.horiz)}
}}}

##################################################################################

#' Create maps with SpatialPolygons objects
#'
#' This function offers several options for creating plots with SpatialPolygons objects. This can be a single plot or multiple plots. These multi-plots can have the same legend or individual legends. Additionally, the layout call within this function offers many options for improving the resulting figures.
#' @param map The SpatialPolygon object.
#' @param figtitle The title to be displayed on the map(s). Can be of length 1 or more.
#' @param y The vector or matrix object to be mapped.
#' @param n.col The number of legend levels.
#' @param bk The break specifications defaults to "e" for equal. Other options are "c" to specify your own breaks and "q" for quantile breaks.
#' @param cuts The cuts to be specified when bk="c".
#' @param legendtxt The text to be displayed in the legend (must be NA (which removes the text altogether) or equal length n.col+1). Defaults to "" which creates text based on the cuts. 
#' @param leg.loc The loation for the legend defaults to "bottomright". Can also be given as a list of x,y coordinates
#' @param leg.cex Specifies the font size in the legend. Defaults to 1.5.
#' @param main.cex Specifies the font size for the title. Defaults to 1.5.
#' @param main.line Specifies the line for the title of the plot to appear on. Defaults to -2.
#' @param leg.horiz Indicates if the legend should be horizontal. Defaults to FALSE.
#' @param map.lty Specifies the line type for the plot. Defaults to 1.
#' @keywords disease mapping 
#' @export
#' @examples
#' Sr1 = Polygon(cbind(c(0,0,1,1,0),c(0,1,1,0,0)))
#' Sr2 = Polygon(cbind(c(0,1,1,0,0),c(0,0,-1,-1,0)))
#' Sr3 = Polygon(cbind(c(0,-1,-1,0,0),c(0,0,1,1,0)))
#' Sr4 = Polygon(cbind(c(0,0,-1,-1,0),c(0,-1,-1,0,0)))
#' Sr5 = Polygon(cbind(c(1,1,2,2,1),c(0,1,1,0,0)))
#' Sr6 = Polygon(cbind(c(0,2,2,1,1),c(0,0,-1,-1,0)))
#' Sr7 = Polygon(cbind(c(-1,-1,0,0,-1),c(1,2,2,1,1)))
#' Sr8 = Polygon(cbind(c(-1,-2,-2,-1,-1),c(1,1,2,2,1)))
#' Sr9 = Polygon(cbind(c(0,0,1,1,0),c(1,2,2,1,1)))
#' Sr10 = Polygon(cbind(c(-2,-2,-1,-1,-2),c(-2,-1,-1,-2,-2)))
#' Sr11 = Polygon(cbind(c(-2,-3,-3,-2,-2),c(-2,-2,-1,-1,-2)))
#' Sr12 = Polygon(cbind(c(-1,-1,0,0,-1),c(-2,-1,-1,-2,-2)))
#' Srs1 = Polygons(list(Sr1), "s1")
#' Srs2 = Polygons(list(Sr2), "s2")
#' Srs3 = Polygons(list(Sr3), "s3")
#' Srs4 = Polygons(list(Sr4), "s4")
#' Srs5 = Polygons(list(Sr5), "s5")
#' Srs6 = Polygons(list(Sr6), "s6")
#' Srs7 = Polygons(list(Sr7), "s7")
#' Srs8 = Polygons(list(Sr8), "s8")
#' Srs9 = Polygons(list(Sr9), "s9")
#' Srs10 = Polygons(list(Sr10), "s10")
#' Srs11 = Polygons(list(Sr11), "s11")
#' Srs12 = Polygons(list(Sr12), "s12")
#' SpP = SpatialPolygons(list(Srs1,Srs2,Srs3,Srs4,Srs5,Srs6,Srs7,Srs8,Srs9,
#' 	Srs10,Srs11,Srs12), 1:12)
#' 
#' v=as.matrix(runif(12,0,1))
#' fillmap(SpP,"Example 1",v,n.col=3)
#' fillmap(SpP,"Example 2",v,n.col=3,bk="q",leg.loc="left",
#' 	legendtxt=c("low","middle","high"))
#' 


fillmap<-function(map, figtitle, y , n.col, bk="e", cuts,legendtxt="",
	leg.loc="bottomright",leg.cex=1.5,main.cex=1.5,main.line=-2,leg.horiz=F,map.lty=1){

if(bk=="q"){if (min(y)<min(y) | max(y)>max(y)){
	print("The minimum or maximum	values of y fall outside of those for y")
	} else {p <- seq(0,1, length=n.col+1)
      br <- round(quantile(y, probs=p),2)}}
if(bk=="e"){if (min(y)<min(y) | max(y)>max(y)){
	print("The minimum or maximum values of y fall outside of those for y")
	} else {br <- round(seq(min(y), max(y), length=n.col+1),6)}}
if(bk=="c"){if (length(cuts)!= (n.col+1)) {cat("Cut off and color categories 
	do not match. ", "\n")
      break}  else {br <- cuts}  }

# 0: dark 1: light light Current shading ranges from darkest to light gray white (to distinguish with lakes).
shading<-gray(rev(0:(n.col-1)/(n.col-1)))
#shading<-hsv(.6,alpha=0:(n.col-1)/(n.col-1))
y.grp<-findInterval(y, vec=br, rightmost.closed = TRUE, all.inside = TRUE)
y.shad<-shading[y.grp]

plot(map,col=y.shad,axes=F, lty=map.lty)
title(main=figtitle,cex.main=main.cex,line=main.line) 

br<-round(br, 2)

if (is.na(legendtxt[1])){print("No legend specifed")
} else if (legendtxt[1]==""){
 	leg.txt<-paste("[",br[n.col],",",br[n.col+1],"]",sep="")
	for(j in (n.col-1):1){ 
		leg.txt<-append(leg.txt,paste("[",br[j],",",br[j+1],")",sep="")) }
		leg.txt<-rev(leg.txt)
	legend(leg.loc,legend=leg.txt,fill=shading,cex=leg.cex,ncol=1,bty="n",
		horiz=leg.horiz)
} else if (length(legendtxt) != n.col){cat("Length of lengendtxt must equal 
		n.col", "\n")
            break
} else {leg.txt<-legendtxt
	legend(leg.loc,legend=leg.txt,fill=shading,cex=leg.cex,ncol=1,bty="n",
		horiz=leg.horiz)}
}

####################################################################################

#' Assesses spatial random effects, such as those mapped with fillmap.
#'
#' This function offers several options for secondary assessments of spatial random effects.
#' @param u The random effect to be assessed.
#' @param v The second random effect to be assessed such that u + v.
#' @param x The the risk factor for exploration.
#' @param bk The categorization specification for the random effect. Defaults to "quart." Other options are: "quint", "tert", "med", "trend", "user".
#' @param user The user specified categoriation of the random effect.
#' @param graph The INLA graph file neccessary for the secondary assessment.
#' @keywords disease mapping secondary assessment
#' @export
#' @examples
#' Sr1 = Polygon(cbind(c(0,0,1,1,0),c(0,1,1,0,0)))
#' Sr2 = Polygon(cbind(c(0,1,1,0,0),c(0,0,-1,-1,0)))
#' Sr3 = Polygon(cbind(c(0,-1,-1,0,0),c(0,0,1,1,0)))
#' Sr4 = Polygon(cbind(c(0,0,-1,-1,0),c(0,-1,-1,0,0)))
#' Sr5 = Polygon(cbind(c(1,1,2,2,1),c(0,1,1,0,0)))
#' Sr6 = Polygon(cbind(c(0,2,2,1,1),c(0,0,-1,-1,0)))
#' Sr7 = Polygon(cbind(c(-1,-1,0,0,-1),c(1,2,2,1,1)))
#' Sr8 = Polygon(cbind(c(-1,-2,-2,-1,-1),c(1,1,2,2,1)))
#' Sr9 = Polygon(cbind(c(0,0,1,1,0),c(1,2,2,1,1)))
#' Sr10 = Polygon(cbind(c(-2,-2,-1,-1,-2),c(-2,-1,-1,-2,-2)))
#' Sr11 = Polygon(cbind(c(-2,-3,-3,-2,-2),c(-2,-2,-1,-1,-2)))
#' Sr12 = Polygon(cbind(c(-1,-1,0,0,-1),c(-2,-1,-1,-2,-2)))
#' Srs1 = Polygons(list(Sr1), "s1")
#' Srs2 = Polygons(list(Sr2), "s2")
#' Srs3 = Polygons(list(Sr3), "s3")
#' Srs4 = Polygons(list(Sr4), "s4")
#' Srs5 = Polygons(list(Sr5), "s5")
#' Srs6 = Polygons(list(Sr6), "s6")
#' Srs7 = Polygons(list(Sr7), "s7")
#' Srs8 = Polygons(list(Sr8), "s8")
#' Srs9 = Polygons(list(Sr9), "s9")
#' Srs10 = Polygons(list(Sr10), "s10")
#' Srs11 = Polygons(list(Sr11), "s11")
#' Srs12 = Polygons(list(Sr12), "s12")
#' SpP = SpatialPolygons(list(Srs1,Srs2,Srs3,Srs4,Srs5,Srs6,Srs7,Srs8,Srs9,
#' 	Srs10,Srs11,Srs12), 1:12)
#' nb.r <- poly2nb(SpP, queen=F)    
#' mat <- nb2mat(nb.r, style="B",zero.policy=TRUE) # mat is the 0/1 adjacency matrix
#' n.site <- dim(mat)[1]          # n.site: number of areas
#' n.edge <- sum(mat)/2           # n.edge: number of unique pairs
#' nbToInlaGraph(nb.r,graphFile="~\\INLAgraph.dat")
#' 
#' v=as.matrix(runif(12,0,1))
#' x=as.matrix(runif(12,0,1))
#' library(INLA)
#' assessmap(u=v,x=x,graph="~\\INLAgraph.dat")
#' 




assessmap=function(u,v=rep(0,length(u)),x,bk="quart",user,graph){
 
  if (bk=="quart"){
  G=ifelse(u+v<=sort(u+v)[round(length(u)/4)],1,
      ifelse(u+v>sort(u+v)[round(length(u)*3/4)],4,
        ifelse((u+v>sort(u+v)[round(length(u)/4)])&(u+v<=sort(u+v)[round(length(u)/2)]),2,3)))
  }
  else if (bk=="quint"){
    G=ifelse(u+v<=sort(u+v)[round(length(u)/5)],1,
        ifelse(u+v>sort(u+v)[round(length(u)*4/5)],5,
          ifelse((u+v>sort(u+v)[round(length(u)/5)])&(u+v<=sort(u+v)[round(length(u)*2/5)]),2,
            ifelse((u+v>sort(u+v)[round(length(u)*2/5)])&(u+v<=sort(u+v)[round(length(u)*3/5)]),3,4))))
  }
  else if (bk=="tert"){
    G=ifelse(u+v<=sort(u+v)[round(length(u)/3)],1,
             ifelse(u+v>sort(u+v)[round(length(u)*2/3)],3,2))
  }
  else if (bk=="med"){
    G=ifelse(u+v<=sort(u+v)[round(length(u)/2)],1,2)
  }
  else if (bk=="trend"){
    G=u+v
  }
  else if (bk=="user"){
    if (length(user)!=length(u)){
      print("Length of user must be the same as length of u. Quartiles used instead.")
      G=ifelse(u+v<=sort(u+v)[round(length(u)/4)],1,
               ifelse(u+v>sort(u+v)[round(length(u)*3/4)],4,
                      ifelse((u+v>sort(u+v)[round(length(u)/4)])&(u+v<=sort(u+v)[round(length(u)/2)]),2,3)))
    }
    else {G=user}
  }
  else {
    print("User must specify bk= 'med', 'tert', 'quart', 'quint', 'trend', or 'user' for comaprison levels. Quartiles used instead.")
    G=ifelse(u+v<=sort(u+v)[round(length(u)/4)],1,
             ifelse(u+v>sort(u+v)[round(length(u)*3/4)],4,
                    ifelse((u+v>sort(u+v)[round(length(u)/4)])&(u+v<=sort(u+v)[round(length(u)/2)]),2,3)))
  }
 
  if (bk=="trend"){
    id=id2=1:length(u)
    formG=y~1+G+f(id,model="iid",param=c(2,1))+f(id2,model="besag",graph=graph,param=c(2,1),scale.model=TRUE)
    resG<-inla(formG,data=list(y=x,G=G),
               control.fixed     = list(prec.intercept = 1, prec = 1),
               control.inla      = list(strategy = "laplace"))
    result=resG$summary.fixed[-1,c(1,3,5)]
    row.names(result)="Testing the linear trend"
    return(result)
  }
  else {
  id=id2=1:length(u)
  formG=y~1+as.factor(G)+f(id,model="iid",param=c(2,1))+f(id2,model="besag",graph=graph,param=c(2,1),scale.model=TRUE)
  resG<-inla(formG,data=list(y=x,G=G),
           control.fixed     = list(prec.intercept = 1, prec = 1),
           control.inla      = list(strategy = "laplace"))
  result=resG$summary.fixed[-1,c(1,3,5)]
  for (i in 1:(length(table(G))-1)){
    row.names(result)[i]=paste(levels(as.factor(G))[1]," vs. ",levels(as.factor(G))[i+1])
  }
  return(result)
  }
}

########################################################################

#' Create maps with SpatialPolygons objects
#'
#' This function offers several options for creating plots with SpatialPolygons objects. This is for producing a single plot with a continuous coloring. The viridis package is required.
#' @param map The SpatialPolygon object.
#' @param figtitle The title to be displayed on the map(s). Can be of length 1 or more.
#' @param y The vector or matrix object to be mapped.
#' @param leg.loc The loation for the legend defaults to "beside". The other option is "beside".
#' @param leg.cex Specifies the font size in the legend. Defaults to 1.5.
#' @param main.cex Specifies the font size for the title. Defaults to 1.5.
#' @param main.line Specifies the line for the title of the plot to appear on. Defaults to -2.
#' @param map.lty Specifies the line type for the plot. Defaults to 1.
#' @param leg.rnd Specifies the decimals for rounding the legend. Defaults to 0.
#' @param y.scl A vector for scaling the legend. Does not need to be the same length as y.
#' @keywords disease mapping 
#' @export
#' @examples
#' Sr1 = Polygon(cbind(c(0,0,1,1,0),c(0,1,1,0,0)))
#' Sr2 = Polygon(cbind(c(0,1,1,0,0),c(0,0,-1,-1,0)))
#' Sr3 = Polygon(cbind(c(0,-1,-1,0,0),c(0,0,1,1,0)))
#' Sr4 = Polygon(cbind(c(0,0,-1,-1,0),c(0,-1,-1,0,0)))
#' Sr5 = Polygon(cbind(c(1,1,2,2,1),c(0,1,1,0,0)))
#' Sr6 = Polygon(cbind(c(0,2,2,1,1),c(0,0,-1,-1,0)))
#' Sr7 = Polygon(cbind(c(-1,-1,0,0,-1),c(1,2,2,1,1)))
#' Sr8 = Polygon(cbind(c(-1,-2,-2,-1,-1),c(1,1,2,2,1)))
#' Sr9 = Polygon(cbind(c(0,0,1,1,0),c(1,2,2,1,1)))
#' Sr10 = Polygon(cbind(c(-2,-2,-1,-1,-2),c(-2,-1,-1,-2,-2)))
#' Sr11 = Polygon(cbind(c(-2,-3,-3,-2,-2),c(-2,-2,-1,-1,-2)))
#' Sr12 = Polygon(cbind(c(-1,-1,0,0,-1),c(-2,-1,-1,-2,-2)))
#' Srs1 = Polygons(list(Sr1), "s1")
#' Srs2 = Polygons(list(Sr2), "s2")
#' Srs3 = Polygons(list(Sr3), "s3")
#' Srs4 = Polygons(list(Sr4), "s4")
#' Srs5 = Polygons(list(Sr5), "s5")
#' Srs6 = Polygons(list(Sr6), "s6")
#' Srs7 = Polygons(list(Sr7), "s7")
#' Srs8 = Polygons(list(Sr8), "s8")
#' Srs9 = Polygons(list(Sr9), "s9")
#' Srs10 = Polygons(list(Sr10), "s10")
#' Srs11 = Polygons(list(Sr11), "s11")
#' Srs12 = Polygons(list(Sr12), "s12")
#' SpP = SpatialPolygons(list(Srs1,Srs2,Srs3,Srs4,Srs5,Srs6,Srs7,Srs8,Srs9,
#' 	Srs10,Srs11,Srs12), 1:12)
#' 
#' v=as.matrix(runif(12,0,1))
#' fillmap2(SpP,"Example 1",v)
#' 

fillmap2<-function(map, figtitle, y , leg.loc="beside", y.scl=NULL,
                   main.cex=1.5,main.line=0,map.lty=1,leg.rnd=0,
                   leg.cex=1){
  
  # 0: dark 1: light light Current shading ranges from darkest to light gray white (to distinguish with lakes).
  y.uq=sort(unique(c(y,y.scl)))
  cols<-viridis(length(y.uq),direction=-1)
  shading=y
  for (i in 1:length(y)){
    shading[i]<-cols[which(y.uq==y[i])]
  }
  
  par(mar=c(0,0,2,0))
  if (leg.loc=="beside"){
    layout(matrix(1:2,ncol=2),width=c(.8,.2))
  } else 
    if (leg.loc=="below"){
      layout(matrix(1:2,nrow=2),height=c(.6,.4))
    } else (print("leg.loc options are below or beside"))
  
  plot(map,col=shading,axes=F, lty=map.lty)
  title(main=figtitle,cex.main=main.cex,line=main.line) 
  
  par(mar=c(5, 4, 4, 2) + 0.1)
  plot(c(0,2),c(0,1),type = 'n', axes = F,xlab = '', ylab = '', main = '')
  cols.5=cols[seq(1,length(y.uq),length.out=5)]
  lab.5=cols.5
  for (i in 1:5){lab.5[i]=y.uq[which(cols==cols.5[i])[1]]}
  lab.5=round(as.numeric(lab.5),leg.rnd)
  par(mar=c(0,0,0,0))
  if (leg.loc=="beside"){
    legend_image <- as.raster(matrix(cols, ncol=1))
    text(x=1.6, 
         y = seq(0,length(y.uq),length.out=5)/length(y.uq),
         labels = rev(lab.5), cex=leg.cex)
    rasterImage(legend_image, 0, 0, 1,1)
  } else{
    legend_image <- as.raster(matrix(cols, nrow=1))
    text(y=-0.25, 
         x = seq(0,length(y.uq),length.out=5)/(length(y.uq)*.5),
         labels = lab.5, cex=leg.cex)
    rasterImage(legend_image, 0, 0, 2,1)
  }
}

###########