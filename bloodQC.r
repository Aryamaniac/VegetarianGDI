library(rio)
library(tidyverse)

blood = as_tibble(import("ukb48364.tsv"))
ukb = as_tibble(import("vegFinal.tsv"))

nmr = blood %>% select(f.eid, f.23444.0.0, f.23451.0.0, f.23445.0.0, f.23452.0.0, f.23459.0.0, f.23450.0.0, f.23457.0.0, f.23449.0.0, f.23456.0.0, f.23446.0.0, f.23453.0.0, f.23447.0.0, f.23454.0.0, f.23458.0.0)

colnames(nmr)<-c("eid",
		"w3FA_NMR","w3FA_NMR_TFAP",
		"w6FA_NMR", "w6FA_NMR_TFAP",
		"w6_w3_ratio_NMR",
		"DHA_NMR","DHA_NMR_TFAP",
		"LA_NMR","LA_NMR_TFAP",
		"PUFA_NMR","PUFA_NMR_TFAP",
		"MUFA_NMR", "MUFA_NMR_TFAP",
		"PUFA_MUFA_ratio_NMR")

nmr2 = filter(nmr, eid %in% ukb$eid)

pheno = as_tibble(merge(ukb, nmr2, by="eid"))

export(pheno, "vegFinal.tsv")



