library(sp)
library(rgeos)

x <- readRDS("../rds/nztm/regc2013.rds")
y <- gSimplify(x, 1000, TRUE)
y <- SpatialPolygonsDataFrame(y, x@data, FALSE)
y <- spTransform(y, CRS("+init=epsg:4326"))
saveRDS(y, "rds/wgs84/regc2013.rds")

x <- readRDS("../rds/nztm/ta2013.rds")
y <- gSimplify(x, 100, TRUE)
y <- SpatialPolygonsDataFrame(y, x@data, FALSE)
y <- spTransform(y, CRS("+init=epsg:4326"))
saveRDS(y, "rds/wgs84/ta2013.rds")
