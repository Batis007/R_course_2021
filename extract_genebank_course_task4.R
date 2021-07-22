####################################################################
# Eduardo Batista                                                  #
# Project MDR                                                      #
# PhD Program in Biology and Ecology of Global Change BEGC         #
# 10-08-2018                                                       #
####################################################################

library(sp)
library(openxlsx)
library(XML)
library(rentrez)
library(xml2)
library(textutils)
#library(devtools)
#install_github("ropensci/rentrez")

#  define file paths
main_dir <- "C:/Users/Eduardo/OneDrive - Universidade de Aveiro/UA/Advanced courses/Curso_R_2021"
setwd(main_dir)
id = list()
test2 <-
  entrez_search(db = "nucleotide", term = "Diplodia[Organism] AND internal transcribed spacer [All Fields]" , retmax = 20)
ids <- if (test2$count == 0) NA else test2$ids
ids5 <- data.frame(ids)
Diplodia <- ids5

# Null function 
null.to.other <-
  function(x,y=NA){
    if(is.null(x)){
      return(y)
    }
    else{
      return(x)
    }
  }

# Extract data from NCBI info for Diplodia species

test1 = list()
for (i in 1:nrow(Diplodia)) {
  fetch2 <- entrez_fetch(db = "nucleotide", id = Diplodia$ids[i], 
                         rettype = "gbc", retmode="xml", parsed = TRUE)  
  xmltop <- xmlRoot(fetch2)
  numseq <- length(xmltop)
  organism <- rep(NA,numseq)
  accession <- rep("",numseq)
  strain <- rep(NA,numseq)
  host <- rep(NA,numseq) 
  country <- rep(NA,numseq)
  organism <- null.to.other(unlist(lapply(getNodeSet(xmltop,"//INSDSeq/INSDSeq_feature-table/INSDFeature/INSDFeature_quals/INSDQualifier[INSDQualifier_name='organism']/INSDQualifier_value"),xmlValue))[1],NA)
  accession <-  unlist(lapply(getNodeSet(xmltop,"//INSDSeq/INSDSeq_primary-accession"),xmlValue))[1]
  strain <- null.to.other(unlist(lapply(getNodeSet(xmltop,"//INSDSeq/INSDSeq_feature-table/INSDFeature/INSDFeature_quals/INSDQualifier[INSDQualifier_name='strain']/INSDQualifier_value"),xmlValue))[1],NA)
  host <- null.to.other(unlist(lapply(getNodeSet(xmltop,"//INSDSeq/INSDSeq_feature-table/INSDFeature/INSDFeature_quals/INSDQualifier[INSDQualifier_name='host']/INSDQualifier_value"),xmlValue))[1],NA)
  country <- null.to.other(unlist(lapply(getNodeSet(xmltop,"//INSDSeq/INSDSeq_feature-table/INSDFeature/INSDFeature_quals/INSDQualifier[INSDQualifier_name='country']/INSDQualifier_value"),xmlValue))[1],NA)
  test1[[i]] <- data.frame(organism,accession,strain,host,country)
  Diplodia_data = do.call(rbind, test1)
}
Diplodia_data <- unique(Diplodia_data) # remove duplicates

# Save data
setwd(main_dir) #Change working directory
write.xlsx(Diplodia_data, "Diplodia_data.xlsx")

#An example of a cured dataset
# Shiny app 
# https://mdr-bot-cesam-ua.shinyapps.io/bot_database 
# 
# Find more
# https://www.mdpi.com/1999-4907/12/3/313

