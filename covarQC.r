library(tidyverse)
library(rio)

ukb = as_tibble(import("vegFinal.tsv"))


ukb = rename(ukb, sex = sex_f31_0_0)
ukb = rename(ukb, townsend = townsend_deprivation_index_at_recruitment_f189_0_0)
ukb = rename(ukb, genoBatch = genotype_measurement_batch_f22000_0_0)
ukb = rename(ukb, alcoholFreq = "frequency_of_drinking_alcohol_f20414_0_0")
ukb = rename(ukb, age = age_when_attended_assessment_centre_f21003_0_0)
ukb = mutate(ukb, age2 = age * age)

for i in 1:10 {
on = paste("genetic_principal_components_f22009_0_", i, sep = "")
nn = paste("PCA", i, sep = "")
ukb = rename(ukb, !!as.name(nn) = !!as.name(on))
}



