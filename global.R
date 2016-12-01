library(data.table)
library(leaflet)
library(gstat)
library(sp)
library(rgeos)
library(raster)
library(rgdal)

mb <- readRDS("rds/wgs84/mb2013.centroids.rds")

ta <- readRDS("rds/ta2013.rds")
rc <- readRDS("rds/regc2013.rds")[regc2013!='99']
tarc <- readRDS("rds/tarc.rds")
mbrc <- readRDS("rds/mbrc.rds")
mbta <- readRDS("rds/mbta.rds")

ta2013 <- readRDS("rds/wgs84/ta2013.rds")
regc2013 <- readRDS("rds/wgs84/regc2013.rds")

rc.list <- as.list(rc[,regc2013])
names(rc.list) <- rc[, paste0("(", regc2013, ") ", regc2013_name)]
