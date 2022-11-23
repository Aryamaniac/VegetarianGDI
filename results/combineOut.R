library(tidyverse)
library(rio)

phenotype = c("w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")

exposure = c("CSRV", "SSRV")
#expo = "CSRV" 
#expo = "SSRV"
for (pheno in phenotype) {
for (expo in exposure) {

setwd(paste("/scratch/as58810/ProjectFall2022/results/", pheno, "/", sep = ""))
start = as_tibble(import(paste(pheno, "x", expo, "-chr", "1", ".txt", sep = "")))

for (i in 2:22) {
	add = as_tibble(import(paste(pheno, "x", expo, "-chr", i, ".txt", sep = ""))) 
	start = rbind(start, add)
}

export(start, paste(pheno, expo, "ALL", ".txt", sep = ""))
print(paste("Done with: ", pheno, " x ", expo, sep=""))
}
}
