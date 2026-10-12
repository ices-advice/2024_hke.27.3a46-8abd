################################################################################
#  hke.27.3a46-8abd_assessment : discard data raising                          #
#------------------------------------------------------------------------------#
#   Sonia Sanchez-Maroño (AZTI)                                                #
#   created:  25/04/2023                                                       #
#   modified:                                                                  #
################################################################################

# ss3_previous.R - Load previous assessment files
# ~/*_hke.27.3a46-8abd_assessment/bootstrap/ss3_previous.R

# Copyright: AZTI, 2023
# Author: Sonia Sanchez-Maroño (AZTI) (<ssanchez@azti.es>)
#
# Distributed under the terms of the GNU GPLv3


#==============================================================================
# DATA                                                                     ----
#==============================================================================

dtyr <- 2023
yy   <- substr(dtyr,3,4)

foln   <- "discard_raising"

inp_wd <- file.path("..","..","initial/data/",foln)
# Next year read from previous year data
# lastdat_wd  <- "https://github.com/ices-taf/2023_hke.27.3a46-8abd_assessment/blob/main/bootstrap/data/discard_raising"
lastdat_wd <- paste0("c:/use/GitHub/ICES_taf/",dtyr,"_hke.27.3a46-8abd_assessment/boot/data/discard_raising/dat")


# Create directories

dir.create(file.path("..",foln,"dat"), recursive = TRUE)


# Import historical data files

file.copy(lastdat_wd, file.path("..",foln), recursive = TRUE, copy.date = TRUE)


# Files listing

files   <- dir(inp_wd)
rmdfile <- grep(".Rmd$", files, value = TRUE)


# Copy 

# - data files
for (filen in files[!files %in% rmdfile])
  file.copy(file.path(inp_wd, filen), file.path("..",foln,"dat", gsub("\\.", paste0("_",dtyr,"."), filen)), copy.date = TRUE)


# - code for processing data
file.copy(file.path(inp_wd, rmdfile), file.path("..",foln, rmdfile), copy.date = TRUE)


#==============================================================================
# REMOVE                                                                   ----
#==============================================================================

rm(dtyr, foln, inp_wd, lastdat_wd, files, rmdfile, filen)


#==============================================================================
# SUMMARY                                                                  ----
#==============================================================================

# print(getwd())
rmarkdown::render(file.path(".","aggregate_IC_data_hke_2024.Rmd"), output_format='html_document', clean=TRUE)

