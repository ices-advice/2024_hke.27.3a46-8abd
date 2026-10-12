################################################################################
#  WGBIE northern hake - Standard Graphs table                                 #
#------------------------------------------------------------------------------#
#   Sonia Sanchez (AZTI-Tecnalia)                                              #
#   created:  09/05/2023                                                       #
#   modified:                                                                  #
################################################################################

# report_03_StandardGraphs.R - filling Standard Graphs table and saving it in ICES repository
# ~/report_03_StandardGraphs.R

# Copyright: AZTI, 2023
# Author: Sonia Sanchez (AZTI) (<ssanchez@azti.es>)
#
# Distributed under the terms of the GNU GPLv3

# Based on code from Hans Gerritsen


rm(list = ls()[!ls() %in% c("dtyr","stockcode")])


#==============================================================================
# LIBRARIES                                                                ----
#==============================================================================

# library(r4ss)
# library(ss3om)
# library(dplyr)
# library(tidyr)
# library(ggplot2)
library(icesSAG)


#==============================================================================
# TOKEN                                                                    ----
#==============================================================================

# You can generate a token like this:
# first log in on  https://standardgraphs.ices.dk/manage
# then go to sg.ices.dk/manage/CreateToken.aspx
# paste the token below after SG_PAT=

cat("# Standard Graphs personal access token",
    "SG_PAT=f1687a44-e89e-421d-a7ec-2db6e4e9f29e", # replace with your own token
    sep = "\n",
    file = "~/.Renviron_SG")
options(icesSAG.use_token = TRUE)


#==============================================================================
# WORKING DIRECTORIES                                                      ----
#==============================================================================

save_wd <- file.path("report","SAG")

if(!dir.exists(save_wd)) dir.create(save_wd)


#==============================================================================
# DATA                                                                     ----
#==============================================================================

# stockcode <- 'hke.27.3a46-8abd'

sumTab <- read.csv(file.path("output","advice","summary_table_final.csv"))


# STOCK INFORMATION

# icesSAG:::validNames("stockInfo")

info <- stockInfo( StockCode = stockcode,                    # grep("hke", icesVocab::getCodeList("ICES_StockCode")$Key, value = TRUE)
                   AssessmentYear = dtyr+1, 
                   ContactPerson = 'ssanchez@azti.es', 
                   StockCategory = 1.0, 
                   ModelType = 'AL',                         # icesVocab::getCodeList("AssessmentModelType") 
                   ModelName = 'SS3',                        # icesVocab::getCodeList("AssessmentModelName") 
                   FMGT_lower = 0.147, FMGT = 0.24, FMGT_upper = 0.37, 
                   MSYBtrigger = 78405, FMSY = 0.24, 
                   Blim = 61563, Bpa = 78405, 
                   Flim = 0.73, Fpa = 0.54, 
                   Fage='1-7', RecruitmentAge = 0, 
                   CatchesLandingsUnits = 't', 
                   ConfidenceIntervalDefinition = '95%', #! 95% confidence interval
                   RecruitmentUnits = 'NE3', 
                   StockSizeUnits = 't', 
                   StockSizeDescription = 'Female-only SSB', # icesVocab::getCodeList("StockSizeIndicator") 
                   Purpose = 'Advice'
                  )

info$StockCategory <- 1 

# icesSAG:::validNames("stockFishdata")

fishdata <- stockFishdata( Year = sumTab$year, 
                           Recruitment = sumTab$rec, Low_Recruitment = sumTab$lowerrec, High_Recruitment = sumTab$upperrec, 
                           TBiomass = sumTab$biomass, Low_TBiomass = NA, High_TBiomass = NA, 
                           StockSize = sumTab$ssb, Low_StockSize = sumTab$lowerssb, High_StockSize = sumTab$upperssb,
                           Catches = sumTab$CatObs, Landings = sumTab$LanObs, Discards = sumTab$DisObs, # observed
                           # Landings = sumTab$LanObs, Discards = sumTab$DisEst,                          # obsland and est disc
                           # Catches = sumTab$CatEst, Landings = sumTab$LanEst, Discards = sumTab$DisEst, # estimated by the model
                           FishingPressure = sumTab$f, Low_FishingPressure = sumTab$lowerf, High_FishingPressure = sumTab$upperf
                          )


#==============================================================================
# UPLOAD                                                                   ----
#==============================================================================

key <- icesSAG::uploadStock(info, fishdata)


#==============================================================================
# UPLOAD CHECK                                                            ----
#==============================================================================

findAssessmentKey('hke.27.3a46-8abd', 2024, full = TRUE)

