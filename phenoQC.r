suppressMessages(library(tidyverse))
suppressMessages(library(ukbtools)) #<3
suppressMessages(library(rio))

#Load dataset
ukb <- as_tibble(import("ukb34Titled.tsv"))

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#Remove withdrawn participants from dataset
withdrawn <-import("w48818_20220222.csv")
#ukb <- ukb[!(ukb$eid %in% withdrawn$V1), ] #Removes 34
ukb = filter(ukb, !(eid %in% withdrawn$V1))

pan <- as_tibble(import("all_pops_non_eur_pruned_within_pop_pc_covs.tsv"))
pan$s <- as.integer(pan$s)

bridge <- as_tibble(import("ukb48818bridge31063.txt"))
colnames(bridge) <- c("IID", "panID")

pan2 <- pan %>% select(s, pop) %>% left_join(bridge, by = c("s" = "panID"))

#--------------------------------------------------------------------------------------------------------------------------------------------------------
#Pheno QC

#Generate a list of participants who pass the following QC criteria:
#1. Genetic ethnicity = Caucasian VIA PAN UKBB
#2. Not an outlier for heterogeneity and missing genotype rate (poor quality genotype)
#3. No Sex chromosome aneuploidy
#4. Self-reported sex matches genetic sex
#5. Do not have high degree of genetic kinship (Ten or more third-degree relatives identified)
#6. Does not appear in "maximum_set_of_unrelated_individuals.MF.pl"

bd_QC <- ukb %>% select(eid, sex_f31_0_0, genetic_sex_f22001_0_0, ethnic_background_f21000_0_0,
                        outliers_for_heterozygosity_or_missing_rate_f22027_0_0, sex_chromosome_aneuploidy_f22019_0_0,
                        genetic_kinship_to_other_participants_f22021_0_0)

colnames(bd_QC) <- c("IID", "Sex", "Genetic_Sex", "Race",
                     "Outliers_for_het_or_missing", "SexchrAneuploidy",
                     "Genetic_kinship")

#1. Genetic ethnicity = Caucasian VIA PAN UKBB
#Join UKB cols with with Pan UKBB
bd_QC <- as_tibble(bd_QC) #502459
bd_QC <- bd_QC %>% inner_join(pan2, by = "IID") #448192

#Filter by Genetic ethnicity = Caucasian VIA PAN UKBB
#bd_QC <- bd_QC[bd_QC$pop == "EUR",] #426880
bd_QC = filter(bd_QC, pop == "EUR")

#2. Not an outlier for heterogeneity and missing genotype rate (poor quality genotype)
bd_QC = bd_QC %>%
    filter(is.na(Outliers_for_het_or_missing) | Outliers_for_het_or_missing != "Yes") #426432

#3. No Sex chromosome aneuploidy
bd_QC = bd_QC %>%
    filter(is.na(SexchrAneuploidy) | SexchrAneuploidy != "Yes") #425853

#4. Self-reported sex matches genetic sex
#If Sex does not equal genetic sex, exclude participant
#bd_QC <- bd_QC[bd_QC$Sex == bd_QC$Genetic_Sex, ] #425682
bd_QC = filter(bd_QC, Sex == Genetic_Sex)

#5. Do not have high degree of genetic kinship (Ten or more third-degree relatives identified)
bd_QC <- bd_QC %>%
    filter(is.na(Genetic_kinship) |
               Genetic_kinship != "Ten or more third-degree relatives identified") #425509
               
#6. Does not appear in "maximum_set_of_unrelated_individuals.MF.pl"
#Filter related file by those in QC
relatives <- read.table("ukb48818_rel_s488282.dat", header=T)

#From maximum_set_of_unrelated_individuals.MF.pl output:
max_unrelated <- read.table("ukb48818_rel_s488282_output.dat")
max_unrelated <- as.integer(unlist(max_unrelated))
bd_QC <- bd_QC %>% filter(!IID %in% max_unrelated) #356979

QCkeepparticipants <- bd_QC %>% select(IID)

export(QCkeepparticipants, "filteredPheno.tsv")

#Start with 502459 participants
#End with 356979 participants, removed 145480
