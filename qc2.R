library(tidyverse)
library(rio)

#load into UKB_DF -> tibble
ukb = as_tibble(ukb_df("ukb34137"))

ukb = import("ukb341372.tsv")
#can be used to find index of any column by name
#match(names(ukb)[grepl("special_diet", names(ukb))], names(ukb))

#filter by people self reporting veg for instance 0 of the survey
#veg1 = ukb3 %>% filter(ukb[,763] == "Vegetarian" | ukb[,764] == "Vegetarian" | ukb[,765] == "Vegetarian" | ukb[,766] == "Vegetarian" | ukb[,767] == "Vegetarian" | ukb[,768] == "Vegetarian")

#filter by major dietary changes
#veg2 = veg1 %>% filter(veg1[,175] == "No")

#Filter by ever taken dietary recall survey
ukb = ukb%>%filter(!is.na(ukb[,618]) | !is.na(ukb[,619]) | !is.na(ukb[,620]) | !is.na(ukb[,621]) | !is.na(ukb[,622]))

#Find first instance of dietary recall taken
ukb3 = mutate(ukb3, "SQW1" = nchar(dayofweek_questionnaire_completed_f20080_0_0) > 0)
ukb3 = mutate(ukb3, "SQW2" = nchar(dayofweek_questionnaire_completed_f20080_1_0) > 0 & !SQW1)
ukb3 = mutate(ukb3, "SQW3" = nchar(dayofweek_questionnaire_completed_f20080_2_0) > 0 & !SQW1 & !SQW2)
ukb3 = mutate(ukb3, "SQW4" = nchar(dayofweek_questionnaire_completed_f20080_3_0) > 0 & !SQW1 & !SQW2 & !SQW3)
ukb3 = mutate(ukb3, "SQW5" = nchar(dayofweek_questionnaire_completed_f20080_4_0) > 0 & !SQW1 & !SQW2 & !SQW3 & !SQW4)

#Get Vegetarians for Instance 0
i = 763
ukbv1 = filter(ukb3, ukb3$SQW1 & (ukb3[,i] == "Vegetarian" | ukb3[,i+1] == "Vegetarian" | ukb3[,i+2] == "Vegetarian" | ukb3[,i+3] == "Vegetarian" | ukb3[,i+4] == "Vegetarian" | ukb3[,i+5] == "Vegetarian" | 
                                    ukb3[,i] == "Vegan" | ukb3[,i+1] == "Vegan" | ukb3[,i+2] == "Vegan" | ukb3[,i+3] == "Vegan" | ukb3[,i+4] == "Vegan" | ukb3[,i+5] == "Vegan"))
#Get Vegetarians for Instance 1
i = 769
ukbv2 = filter(ukb3, ukb3$SQW2 & (ukb3[,i] == "Vegetarian" | ukb3[,i+1] == "Vegetarian" | ukb3[,i+2] == "Vegetarian" | ukb3[,i+3] == "Vegetarian" | ukb3[,i+4] == "Vegetarian" | ukb3[,i+5] == "Vegetarian" | 
                                    ukb3[,i] == "Vegan" | ukb3[,i+1] == "Vegan" | ukb3[,i+2] == "Vegan" | ukb3[,i+3] == "Vegan" | ukb3[,i+4] == "Vegan" | ukb3[,i+5] == "Vegan"))
#Get Vegetarians for Instance 2
i = 775
ukbv3 = filter(ukb3, ukb3$SQW3 & (ukb3[,i] == "Vegetarian" | ukb3[,i+1] == "Vegetarian" | ukb3[,i+2] == "Vegetarian" | ukb3[,i+3] == "Vegetarian" | ukb3[,i+4] == "Vegetarian" | ukb3[,i+5] == "Vegetarian" | 
                                    ukb3[,i] == "Vegan" | ukb3[,i+1] == "Vegan" | ukb3[,i+2] == "Vegan" | ukb3[,i+3] == "Vegan" | ukb3[,i+4] == "Vegan" | ukb3[,i+5] == "Vegan"))
#Get Vegetarians for Instance 3
i = 781
ukbv4 = filter(ukb3, ukb3$SQW4 & (ukb3[,i] == "Vegetarian" | ukb3[,i+1] == "Vegetarian" | ukb3[,i+2] == "Vegetarian" | ukb3[,i+3] == "Vegetarian" | ukb3[,i+4] == "Vegetarian" | ukb3[,i+5] == "Vegetarian" | 
                                    ukb3[,i] == "Vegan" | ukb3[,i+1] == "Vegan" | ukb3[,i+2] == "Vegan" | ukb3[,i+3] == "Vegan" | ukb3[,i+4] == "Vegan" | ukb3[,i+5] == "Vegan"))
#Get Vegetarians for Instance 4
i = 787
ukbv5 = filter(ukb3, ukb3$SQW5 & (ukb3[,i] == "Vegetarian" | ukb3[,i+1] == "Vegetarian" | ukb3[,i+2] == "Vegetarian" | ukb3[,i+3] == "Vegetarian" | ukb3[,i+4] == "Vegetarian" | ukb3[,i+5] == "Vegetarian" | 
                                    ukb3[,i] == "Vegan" | ukb3[,i+1] == "Vegan" | ukb3[,i+2] == "Vegan" | ukb3[,i+3] == "Vegan" | ukb3[,i+4] == "Vegan" | ukb3[,i+5] == "Vegan"))

ukb4 = rbind(ukbv1, ukbv2, ukbv3, ukbv4, ukbv5)
#Mark whose veg and who isn't out of everyone who took the dietary survey
ukb6 = mutate(ukb3, CSRV = eid %in% ukb4$eid)

#j = 4679
for (i in 1:5) {
  col = paste("SQW", i, sep="")
  meatcol = paste("meat_consumers_f103000_", (i-1), "_0", sep="")
  ukbm1 = filter(ukb, ukb[,col] & ukb[,meatcol] == "Yes")
  if (i == 1) {
    ukbm = ukbm1
  } else {
    ukbm = bind_rows(ukbm1, ukbm) 
  }
}
ukb6 = mutate(ukb, ateMeat = eid %in% ukbm$eid)

for (i in 1:5) {
  col = paste("SQW", i, sep="")
  meatcol = paste("fish_consumer_f103140_", (i-1), "_0", sep="")
  ukbm1 = filter(ukb6, ukb6[,col] & ukb6[,meatcol] == "Yes")
  if (i == 1) {
    ukbm = ukbm1
  } else {
    ukbm = rbind(ukbm, ukbm1)
  }
}
ukb7 = mutate(ukb6, ateFish = eid %in% ukbm$eid)


j = 4744
for (i in 1:5) {
  col = paste("SQW", i, sep="")
  ukbf1 = filter(ukb5, ukb5[col] & ukb5[,j+i] == "Yes")
  if (i == 1) {
    ukbf = ukbf1
  } else {
    rbind(ukbf, ukbf1)
  }
}
ukb6 = mutate(ukb6, ateFish = eid %in% ukbf$eid)

export(ukb6, "ukb6.tsv")

#intial SSRV check on columns 115, 118, 121, 124, 127, 130, 133


ukbi = filter(ukb6, ukb6[,115] == "Never" & ukb6[,118] == "Never" & ukb6[,121] == "Never" & ukb6[,124] == "Never" & ukb6[,127] == "Never" & ukb6[,130] == "Never" & ukb6[,133] == "Never")
ukb6 = mutate(ukb6, initVeg = eid %in% ukbi$eid)  
ukb6 = mutate(ukb6, dietChange = ukb6[,175] == "No")  


