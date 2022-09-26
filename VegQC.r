#load into UKB_DF -> tibble
ukb = as_tibble(ukb_df("ukb34137"))

#can be used to find index of any column by name
#match(names(ukb)[grepl("special_diet", names(ukb))], names(ukb))

#filter by people self reporting veg for instance 0 of the survey
veg1 = ukb %>% filter(ukb[,763] == "Vegetarian" | ukb[,764] == "Vegetarian" | ukb[,765] == "Vegetarian" | ukb[,766] == "Vegetarian" | ukb[,767] == "Vegetarian" | ukb[,768] == "Vegetarian")

#filter by major dietary changes
veg2 = veg1 %>% filter(veg1[,175] == "No")


ukb = ukb%>%filter(!is.na(ukb[,618]) | !is.na(ukb[,619]) | !is.na(ukb[,620]) | !is.na(ukb[,621]) | !is.na(ukb[,622]))

ukb3 = mutate(ukb3, "SQW1" = nchar(dayofweek_questionnaire_completed_f20080_0_0) > 0)
ukb3 = mutate(ukb3, "SQW2" = nchar(dayofweek_questionnaire_completed_f20080_1_0) > 0 & !SQW1)
ukb3 = mutate(ukb3, "SQW3" = nchar(dayofweek_questionnaire_completed_f20080_2_0) > 0 & !SQW1 & !SQW2)
ukb3 = mutate(ukb3, "SQW4" = nchar(dayofweek_questionnaire_completed_f20080_3_0) > 0 & !SQW1 & !SQW2 & !SQW3)
ukb3 = mutate(ukb3, "SQW5" = nchar(dayofweek_questionnaire_completed_f20080_4_0) > 0 & !SQW1 & !SQW2 & !SQW3 & !SQW4)

