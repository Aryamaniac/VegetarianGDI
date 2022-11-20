library(tidyverse)
library(rio)
library(ukbtools)

#load into UKB_DF -> tibble -> save for future use as RIO compatible format
#ukb = as_tibble(ukb_df("ukb34137"))
#export(ukb, "ukb341372.tsv")

ukb = as_tibble(import("ukb341372.tsv"))

#Filter by ever taken dietary recall survey
ukb = ukb%>%filter(!is.na(ukb[,618]) | !is.na(ukb[,619]) | !is.na(ukb[,620]) | !is.na(ukb[,621]) | !is.na(ukb[,622]))

#Find first instance of dietary recall taken
ukb = mutate(ukb, "SQW1" = nchar(dayofweek_questionnaire_completed_f20080_0_0) > 0)
ukb = mutate(ukb, "SQW2" = nchar(dayofweek_questionnaire_completed_f20080_1_0) > 0 & !SQW1)
ukb = mutate(ukb, "SQW3" = nchar(dayofweek_questionnaire_completed_f20080_2_0) > 0 & !SQW1 & !SQW2)
ukb = mutate(ukb, "SQW4" = nchar(dayofweek_questionnaire_completed_f20080_3_0) > 0 & !SQW1 & !SQW2 & !SQW3)
ukb = mutate(ukb, "SQW5" = nchar(dayofweek_questionnaire_completed_f20080_4_0) > 0 & !SQW1 & !SQW2 & !SQW3 & !SQW4)

#Get Vegetarians for Instance 0
i = 763
ukbv1 = filter(ukb, ukb$SQW1 & (ukb[,i] == "Vegetarian" | ukb[,i+1] == "Vegetarian" | ukb[,i+2] == "Vegetarian" | ukb[,i+3] == "Vegetarian" | ukb[,i+4] == "Vegetarian" | ukb[,i+5] == "Vegetarian" | 
                                    ukb[,i] == "Vegan" | ukb[,i+1] == "Vegan" | ukb[,i+2] == "Vegan" | ukb[,i+3] == "Vegan" | ukb[,i+4] == "Vegan" | ukb[,i+5] == "Vegan"))
#Get Vegetarians for Instance 1
i = 769
ukbv2 = filter(ukb3, ukb3$SQW2 & (ukb[,i] == "Vegetarian" | ukb[,i+1] == "Vegetarian" | ukb[,i+2] == "Vegetarian" | ukb[,i+3] == "Vegetarian" | ukb[,i+4] == "Vegetarian" | ukb[,i+5] == "Vegetarian" | 
                                    ukb[,i] == "Vegan" | ukb[,i+1] == "Vegan" | ukb[,i+2] == "Vegan" | ukb[,i+3] == "Vegan" | ukb[,i+4] == "Vegan" | ukb[,i+5] == "Vegan"))
#Get Vegetarians for Instance 2
i = 775
ukbv3 = filter(ukb, ukb$SQW3 & (ukb[,i] == "Vegetarian" | ukb[,i+1] == "Vegetarian" | ukb[,i+2] == "Vegetarian" | ukb[,i+3] == "Vegetarian" | ukb[,i+4] == "Vegetarian" | ukb[,i+5] == "Vegetarian" | 
                                    ukb[,i] == "Vegan" | ukb[,i+1] == "Vegan" | ukb[,i+2] == "Vegan" | ukb[,i+3] == "Vegan" | ukb[,i+4] == "Vegan" | ukb[,i+5] == "Vegan"))
#Get Vegetarians for Instance 3
i = 781
ukbv4 = filter(ukb, ukb$SQW4 & (ukb[,i] == "Vegetarian" | ukb[,i+1] == "Vegetarian" | ukb[,i+2] == "Vegetarian" | ukb[,i+3] == "Vegetarian" | ukb[,i+4] == "Vegetarian" | ukb[,i+5] == "Vegetarian" | 
                                    ukb[,i] == "Vegan" | ukb[,i+1] == "Vegan" | ukb[,i+2] == "Vegan" | ukb[,i+3] == "Vegan" | ukb[,i+4] == "Vegan" | ukb[,i+5] == "Vegan"))
#Get Vegetarians for Instance 4
i = 787
ukbv5 = filter(ukb, ukb$SQW5 & (ukb[,i] == "Vegetarian" | ukb[,i+1] == "Vegetarian" | ukb[,i+2] == "Vegetarian" | ukb[,i+3] == "Vegetarian" | ukb[,i+4] == "Vegetarian" | ukb[,i+5] == "Vegetarian" | 
                                    ukb[,i] == "Vegan" | ukb[,i+1] == "Vegan" | ukb[,i+2] == "Vegan" | ukb[,i+3] == "Vegan" | ukb[,i+4] == "Vegan" | ukb[,i+5] == "Vegan"))

ukb4 = rbind(ukbv1, ukbv2, ukbv3, ukbv4, ukbv5)
#Mark whose veg and who isn't out of everyone who took the dietary survey
ukb5 = mutate(ukb, CSRV = eid %in% ukb4$eid)

j = 4679
 for (i in 1:5) {
  col = paste("SQW", i, sep="")
  ukbm1 = filter(ukb5, ukb5[col] & ukb5[,j+i] == "Yes")
  if (i == 1) {
    ukbm = ukbm1
  } else {
    ukbm = rbind(ukbm, ukbm1)
  }
}
ukb6 = mutate(ukb5, ateMeat = eid %in% ukbm$eid)

j = 4744
for (i in 1:5) {
  col = paste("SQW", i, sep="")
  ukbf1 = filter(ukb5, ukb5[col] & ukb5[,j+i] == "Yes")
  if (i == 1) {
    ukbf = ukbf1
  } else {
    ukbf = rbind(ukbf, ukbf1)
  }
}
ukb6 = mutate(ukb6, ateFish = eid %in% ukbf$eid)

#export(ukb6, "ukb6.tsv")

#intial SSRV check on columns 115, 118, 121, 124, 127, 130, 133
ukbi = filter(ukb6, ukb6[,115] == "Never" & ukb6[,118] == "Never" & ukb6[,121] == "Never" & ukb6[,124] == "Never" & ukb6[,127] == "Never" & ukb6[,130] == "Never" & ukb6[,133] == "Never")
ukb6 = mutate(ukb6, initVeg = eid %in% ukbi$eid)  

#Diet consistency check
ukb6 = mutate(ukb6, consistentDiet = ukb6[,175] == "No")  

#Define SSRV
ukb6 = mutate(ukb6, SSRV = CSRV & !ateFish & !ateMeat & consistentDiet & initVeg)

ambigious = filter(ukb6, CSRV & !SSRV)$eid
ukb6 = mutate(ukb6, SSRV = ifelse(eid %in% ambigious, NA, SSRV))

write.csv(ukb6, "filteredFinalVeg.csv", row.names = FALSE, quote = FALSE)


