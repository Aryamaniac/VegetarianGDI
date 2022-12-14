library(tidyverse)
library(rio)
library(qqman)

indir = "/scratch/as58810/ProjectFall2022/results"

phenotype = c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")
#pheno = "w3FA_NMR"
#pheno = "w6FA_NMR"

exposures = c("CSRV", "SSRV")
#expo = "CSRV"
#expo = "SSRV"
for (pheno in phenotype) {
for (expo in exposures) {

#Read in data and clean
infile= import(paste("/scratch/as58810/ProjectFall2022/results/", pheno, "/", pheno, expo, "ALL", ".txt", sep=""))
infile<-as_tibble(infile) 
#print("Read data")

#Subset data
infile1<-infile%>%select(RSID, CHR, POS, robust_P_Value_Interaction)
 
#Get qqman format
colnames(infile1)<-c("SNP", "CHR", "BP", "P")

#Post Processing
sigs=filter(infile1, P<5e-8)
sigs = sigs$SNP
#print(sigs)
print("processed")


#Make manhattan plot
plotoutputpath<-paste(indir, "/plot", sep="") 
dir.create(plotoutputpath, showWarnings=FALSE)
plotoutputfile<-paste(plotoutputpath, paste("/", pheno, "x", expo, "man.png", sep=""), sep="") 
png(filename=plotoutputfile, type="cairo", height = 800, width = 1200)
manhattan(infile1, highlight = sigs, main = paste(pheno, " X ", expo, " - GEM", sep=""), suggestiveline = -log10(1e-05), genomewideline = -log10(5e-08), col = c("hotpink", "black"), ylim = c(0, 10))
dev.off()
print(paste("Done with: ", pheno, " x ", expo, sep=""))

}
}
