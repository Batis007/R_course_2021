####################################################################
# Eduardo Batista                                                  #
# Project MDR                                                      #
# PhD Program in Biology and Ecology of Global Change BEGC         #
# 04-11-2017                                                       #
####################################################################

#Install packages 
#install.packages(c("sp","raster","dismo","rgdal","maptools","rworldmap"))

#Load the installed packages
library(sp)
library(raster)
library(dismo)
library(rgdal)
library(maptools)
library(rworldmap)
#library(tidyverse)
#  define file paths
main_dir <- "C:/Users/Eduardo/OneDrive - Universidade de Aveiro/UA/Advanced courses/Curso_R_2021"
setwd(main_dir)
#   Working with occurrence data - GBIF----
help(gbif) # check the gbif function and download data for Diplodia 
data <- gbif(genus = 'Diplodia', geo = TRUE)
colnames(data)
head(data)
#Organize the data set by location and remove duplicas + NA cells ----

pointsdatasp <- data.frame(lon = data$lon,lat = data$lat, species =data$species)
pointsdatasp <- pointsdatasp[complete.cases(pointsdatasp),] # remove NA cells
pointsdatasp <- unique(pointsdatasp)

#Extract the associated host by species and countries ----
data_host <-
  data.frame(
    sp = data$species,
    host = data$associatedTaxa,
    country = data$country
  )
data_host <- data_host[complete.cases(data_host), ] # remove NA cells
data_host <- unique(data_host)


#Plot WorldMapa with data points ----
data(wrld_simpl)
plot(wrld_simpl,
     main = "Records of Diplodia spp.",
     axes = TRUE,
     col = "light yellow")
# restore the box around the map 
box()

# add the points
points(pointsdatasp$lon, pointsdatasp$lat, col='orange', pch=20, cex=0.75)
# plot points again to add a border, for better visibility 
points(pointsdatasp$lon, pointsdatasp$lat, col='red', cex=0.75)

#Homework make a new map with what you learn from Rafael Felix ----

################### TASK2 ----
#Extract from Bioclim data for each record
# make pointsdatasp spatial
points <- data.frame(lon = pointsdatasp$lon, lat = pointsdatasp$lat)
coordinates(points) <- ~lon + lat

# get the worldclim data----
worldclim <- raster::getData('worldclim', var='bio', res=2.5)
rp_wc <- extract(worldclim, points)
# Combine pointsdatasp with rp_wc in a new file rp_wc1
rp_wc1 <- cbind(pointsdatasp,rp_wc)
# Check the NA values for modeling----
rp_wc1 <- rp_wc1[complete.cases(rp_wc1), ] # remove NA cells

#Analyse max, min and mean annual temperature for Diplodia spp.----
max(rp_wc1$bio1)
mean(rp_wc1$bio1)
rp_wc1$bio1 <- rp_wc1$bio1/10
#Plot annual temperature and occurrence location for Diplodia spp.----
plot(worldclim$bio1)
#Plot WorldMap with data points
plot(worldclim$bio1, main = "Records of Diplodia spp.", axes=TRUE)
points(
  pointsdatasp$lon,
  pointsdatasp$lat,
  col = 'orange',
  pch = 20,
  cex = 0.75
)
# restore the box around the map
box()
# add the points
points(pointsdatasp$lon, pointsdatasp$lat, col='orange', pch=20, cex=0.75)
# plot points again to add a border, for better visibility 
points(pointsdatasp$lon, pointsdatasp$lat, col='red', cex=0.75)

#Save files----
#setwd(output)
dev.copy(jpeg,filename="worldmapplot.jpeg");
dev.off ()
write.csv(data, file = "data.csv")
write.csv(pointsdatasp, file = "pointsdatasp.csv")
write.csv(rp_wc1, file = "rp_wc1.csv")
