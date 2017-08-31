#pilot data analysis and tentative analysis script for the learning task
setwd("~/Dropbox/SL and WM paper/Revision/Pilot_Data_Revised task/V5")
#required packages
options(scipen=999)
#useful ref: http://bbolker.github.io/mixedmodels-misc/glmmFAQ.html
#convergence problems: https://rstudio-pubs-static.s3.amazonaws.com/33653_57fc7b8e5d484c909b615d8633c01d51.html
#also: https://stats.stackexchange.com/questions/242109/model-failed-to-converge-warning-in-lmer
#and: https://rstudio-pubs-static.s3.amazonaws.com/33653_57fc7b8e5d484c909b615d8633c01d51.html

#library(devtools)
#install_github(repo = "RDDtools", username = "MatthieuStigler", subdir = "RDDtools")
#install.packages("optimx")
library(RDDtools)
library(optimx)
library(lme4)
library(ggplot2)
library(doBy)
library(gridExtra)
library(tidyverse)
library(RColorBrewer)

##########################################################################
breakblock<-c(7,8)
nsets<-5
nblocks<-10
phase1.start<-1
phase1.end<-nsets*(breakblock[1]-1)
phase2.start<-phase1.end+1
phase2.end<-nsets*(breakblock[2])
phase3.start<-phase2.end+1
phase3.end<-nsets*nblocks

phase1.range<-c(phase1.start:phase1.end)
phase2.range<-c(phase2.start:phase2.end)
phase3.range<-c(phase3.start:phase3.end)

#substitute windows for quartz if nonmac
if(.Platform$OS.type=="windows") {
  quartz<-function() windows()
} 
##########################################################################

namelist=c('pilot_01','pilot_02','pilot_03','pilot_04','pilot_05','pilot_06','pilot_07',
           'pilot_08','pilot_09')
nsubs<-length(namelist)
thistype<-c('rand','Adj_D','Adj_P','Non_D')
main.data<-data.frame(ID=factor(), SetInd=integer(), Type=integer(), TargetRT=integer())

##########################################################################

for (i in 1:nsubs){
  
  myname=namelist[i]
  mycsv=paste(myname,".csv",sep="")
  mydata= read.csv(mycsv)  # read csv file 
  #get rid of RTs of inaccurate responses and any RT greater than 3000 ms:replace with NA. 
  Rwdata=mydata
  rawdata=Rwdata[ ,c(1,10,12,26)]
  #in the original analysis the following section will be removed 
  
  #######this bit ensures inaccurate becomes, so not eliminated in next section, and at least RT can be extracted. 
  rawdata$TargetRT[rawdata$Type==19 & rawdata$TargetRT>3000]<-2999
  ##############
  rawdata$TargetRT[rawdata$TargetACC==0]<-NA
  rawdata$TargetRT[rawdata$TargetRT<-199]<-NA #include anticipations up to -200
  rawdata$TargetRT[rawdata$TargetRT>2000]<-2000 
  
  RWdata<-rawdata
  
  #rename the types so median can be taken for each block 
  RWdata$Type[RWdata$Type==1]<- "Adj_D"
  RWdata$Type[RWdata$Type==2]<- "Adj_D"
  
  RWdata$Type[RWdata$Type==3]<- "Adj_P"
  RWdata$Type[RWdata$Type==4]<- "Adj_P"

  RWdata$Type[RWdata$Type==5]<- "Non_D"
  RWdata$Type[RWdata$Type==6]<- "Non_D"

  RWdata$Type[RWdata$Type==7]<- "rand"
  RWdata$Type[RWdata$Type==8]<- "rand"
  
  #RWdata$ID<-substring(RWdata$ID,1,2)
  RWdata$Type<-as.factor(RWdata$Type)
  RWdata$Type<-factor(RWdata$Type,levels=c("rand", "Adj_D", "Adj_P", "Non_D"))
  
  detaildata<- summaryBy(TargetRT ~ SetInd+Type,  data=RWdata,
                         FUN=c(min), na.rm=TRUE)
  #NB only 2 points to consider, so now taking minimum, not median
  # ah, but NB for Adj_Prob there are 4 points...
  
  detaildata$ID<-rep(RWdata$ID[4],length(detaildata[,1]))
  
  names(detaildata)<-c("SetInd", "Type", "TargetRT", "ID")
  
 
  main.data<-rbind(main.data,detaildata) #add to main data file in long form
  
}
##########################################################################

#add coeffs for reg discontinuity, just for learning/random phases
lmsummarycoefs<-data.frame(matrix(NA,24,nrow=nsubs))#initialise matrix
for (i in 1:nsubs){
startcol<- -5 #set so that this will append columns to right place (Historical)
for (mytype in 1:4){
  mytemp<-filter(main.data,ID==namelist[i],Type==thistype[mytype],SetInd<41)
  # using the RDDtools package
  RDD.temp<-RDDdata(y=mytemp$TargetRT,x=mytemp$SetInd,cutpoint=31)
  reg_para <- RDDreg_lm(RDDobject = RDD.temp, order = 1) #this is just linear: for higher order can increase
  startcol<-startcol+6
  endcol<-startcol+3
  lmsummarycoefs[i,startcol:endcol]<-reg_para$coefficients
  st<-summary(reg_para)[[4]]
  myt<-st[2,3]#t-value corresponding to difference in slope for two phases
  lmsummarycoefs[i,endcol+1]<-myt
  myp<-summary(reg_para)$coefficients[2,4]#sig of slope diff for the two phases
  lmsummarycoefs[i,endcol+2]<-myp
  colnames(lmsummarycoefs)[startcol:endcol]<-paste0(thistype[mytype],'.',names(reg_para$coefficients))
  colnames(lmsummarycoefs)[endcol+1]<-paste0(thistype[mytype],'_t.diff')
  colnames(lmsummarycoefs)[endcol+2]<-paste0(thistype[mytype],'_p.diff')
 }
}
write.csv(lmsummarycoefs, file = "lm_discont_coeffs_linear.csv")
shortbit<-select(lmsummarycoefs,5,6,11,12,17,18,23,24) #just cols for t-values and p
rownames(shortbit)<-namelist
shortbit
#can view shortbit to see which participants show which effects
#####################################################################################
main.data$ID <- as.factor(main.data$ID)
main.data$log_TargetRT<-log(main.data$TargetRT+200) #to allow for anticipatory responses
main.data<-data.frame(main.data)

#####################################################################################
#Plot overall data
summarytable<-summaryBy(TargetRT~SetInd+Type,data=main.data,FUN=c(mean),na.rm=TRUE)

ggplot(summarytable,aes(x = SetInd, y = TargetRT.mean,color=Type))  +
  geom_line()

#####################################################################################
#Plot individual data
png(filename="Indivdata.png",width = 1000, height = 400)
#quartz(width=12,height=3)
ggplot(main.data, aes(x = SetInd, y = TargetRT,color=Type)) + 
  geom_line(alpha=0.75) + 
  geom_vline(aes(xintercept = 30), color = 'grey', size = 1, linetype = 'dashed') + 
  geom_vline(aes(xintercept = 40), color = 'grey', size = 1, linetype = 'dashed') +
   theme_bw()+facet_grid(~ID)+ scale_fill_brewer(palette="Set1")+
  theme(legend.position = "top",strip.text=element_text(size=12),axis.text=element_text(size=12),axis.title=element_text(size=12,face="bold"))
dev.off()
#####################################################################################

#create new variables
main.data$phase1<-ifelse(main.data$SetInd %in% phase1.range,1,0)
main.data$phase2<-ifelse(main.data$SetInd %in% phase2.range,1,0) #block where seq broken
main.data$phase3<-ifelse(main.data$SetInd %in% phase3.range,1,0) #block where seq restored

main.data$p123<-as.factor(main.data$phase1+2*main.data$phase2+3*main.data$phase3)
levels(main.data$p123)<-c('Learn','Break','Final')
main.data$p123<-factor(main.data$p123,levels=c("Break","Learn","Final"))#reorder factor levels

main.data$allb<-main.data$SetInd_c
w<-which(main.data$p123=='Break')
main.data$allb[w]<-main.data$b2[w]
w2<-which(main.data$p123=='Final')
main.data$allb[w2]<-main.data$b3[w2]



main.data$SetInd_c<-scale(main.data$SetInd) #? to centre this variable

# bp1=unique(main.data$SetInd_c)[30] #cutpoint 1 - original values - I think wrong - see below, shld be == not []
# bp2=unique(main.data$SetInd_c)[40] #cutpoint 2

myseq<-scale(seq(1,nblocks*nsets))
bp1<-myseq[phase2.start]-.01 #cutpoint1 on centred set index, nudged down so won't exclude sets with exact match of value
bp2<-myseq[phase3.start]-.01 #cutpoint2 on centred set index

#functions to determine if value x is in phase1, phase2 or phase3
#So this ignores values for sets not in this phase (sets to zero), but has all other phases scaled
#so that they show increment across phase
b1make <- function(x, bp1) ifelse(x < bp1, bp1 + x, 0) #NB altered by DB from bp1-x
b2make <- function(x, bp1, bp2) ifelse(x >= bp1 & x < bp2, x - bp1, 0)
b3make <- function(x, bp2) ifelse(x < bp2, 0, x - bp2)

#compute log RT
main.data$log_TargetRT_2<-main.data$log_TargetRT
#add b1, b2, b3 to main.data rather than computing during regression
#(also helps understand these functions by seeing how they relate to set)
main.data$b1<-b1make(main.data$SetInd_c,bp1)
main.data$b2<-b2make(main.data$SetInd_c,bp1,bp2)
main.data$b3<-b3make(main.data$SetInd_c,bp2)

 # Bolker advice on fixed/random:
 #'Treating factors with small numbers of levels as random will in the best case 
 # lead to very small and/or imprecise estimates of random effects'
 # Which would mean that phase should NOT be regarded as random effect

 mod.2e <- lmer(TargetRT ~ Type*p123  #nb will automatically do main effects as well
                 +(0+b1*Type+b2*Type+b3*Type|ID), data = main.data,
                 REML = TRUE,control = lmerControl(optimizer = "optimx", 
                                                   calc.derivs = TRUE, optCtrl = list(method = "nlminb")))

 #There are warning about convergence failure. But the parameters make sense and are stable regardless
 # of method - i have tried NM and BFGS. So I think OK (see also quote below from stackexchange)
 mod.2esum<-summary(mod.2e)$coefficients 
 my.ranef2e<-ranef(mod.2e) #random effects
 write.csv(my.ranef2e[1], file = "mod.2e_rande_effects.csv")
 write.csv(mod.2esum,file="mod.2e.fixed.coeffs.csv")
 
 #save objects for use in power program
 saveRDS(mod.2e, "mod.2e.rds")
 saveRDS(main.data,"maindata2.rds")



 #https://stats.stackexchange.com/questions/110004/how-scared-should-we-be-about-convergence-warnings-in-lme4
 #'if two optimizers give the same parameters, but different diagnostics -- 
 #and those parameters make real world sense -- then I would be inclined to trust the parameter values. 
 #The difficulty could lie with the diagnostics, which are not fool-proof'. 
 
##########################################################################################  
  #regression diagnostics
 quartz()
#  png(filename="merplot2.png")
grid.arrange(  
plot(mod.2e,type=c("p","smooth")),

plot(mod.2e,sqrt(abs(resid(.)))~fitted(.),
                  type=c("p","smooth"),ylab=expression(sqrt(abs(resid)))),

plot(mod.2e,resid(.,type="pearson")~SetInd_c, type=c("p","smooth")))
#dev.off()

quartz()
#png(filename="merplot3.png")
qqnorm(resid(mod.2e))
qqline(resid(mod.2e)) # shape due to using whole numbers 1:40.

hist(resid(mod.2e),100)
#dev.off()
###########################################################################################

 
 
 ##########################################################################################
 #Create table for prediction - modified by DB to have phase as factor
startdat<-select(main.data,ID,Type,SetInd,SetInd_c,p123,b1,b2,b3)
startdat$SetInd<-as.integer(startdat$SetInd)
newdat1d<-startdat[startdat$SetInd<31,]
newdat2d<-startdat[startdat$SetInd>30,]
newdat2d<-newdat2d[newdat2d$SetInd<41,]
newdat3d<-startdat[startdat$SetInd>40,]

 #plots for lmer
#NB - these illustrate why slope alone is not a good index of learning; see case of Yaling;
# she learned Det_Adj in first block, and then stayed flat - so learning indicated more by
# overall difference from random than by slope

png(filename="fittedplot.mod.2e.png", width=1000,height=300)
 #quartz(width=10,height=3)
 ggplot(main.data, aes(x = SetInd_c, y = TargetRT,color=Type)) + 
   geom_point(alpha=0.35) + 
   geom_vline(aes(xintercept = bp1), color = 'grey', size = 1, linetype = 'dashed') + 
   geom_vline(aes(xintercept = bp2), color = 'grey', size = 1, linetype = 'dashed') +
   geom_line(data=newdat1d,aes(y=predict(mod.2e,newdata=newdat1d)),size = .75)+
   geom_line(data=newdat2d,aes(y=predict(mod.2e,newdata=newdat2d)),size = .75)+
   geom_line(data=newdat3d,aes(y=predict(mod.2e,newdata=newdat3d)),size = .75)+
   theme_bw()+facet_grid(~ID)+ scale_fill_brewer(palette="Set1")+
   theme(legend.position = "top",strip.text=element_text(size=12),axis.text=element_text(size=12),axis.title=element_text(size=12,face="bold"))
 dev.off()
 
 #RDD bits - just playing with these
# https://github.com/MatthieuStigler/RDDtools
 # mytemp<-filter(main.data,Type=='Adj_D',SetInd<41)
 # 
 # RDD.AdjD<-RDDdata(y=mytemp$TargetRT,x=mytemp$SetInd,cutpoint=31,)
 # summary(RDD.AdjD)
 # plot(RDD.AdjD)
 # reg_para <- RDDreg_lm(RDDobject = RDD.AdjD, order = 4)
 # reg_para
 # plot(reg_para)
 # #simple local regression, using the Imbens and Kalyanaraman 2012 bandwidth:
 # bw_ik <- RDDbw_IK(RDD.AdjD)
 # reg_nonpara <- RDDreg_np(RDDobject = RDD.AdjD, bw = bw_ik)
 # print(reg_nonpara)
 # plot(reg_nonpara)
 # plotPlacebo(reg_nonpara)
 # 
 # firstbit<-filter(main.data,SetInd<41)
 # RDD.all<-RDDdata(y=firstbit$TargetRT,x=firstbit$SetInd,covar=firstbit$Type,cutpoint=31)
 # covarTest_mean(RDD.all, bw = 0.3)
 
