# Get matching Trace21k fields for Shakun proxy data

library(climproxyrecords)
library(ncdf4)
library(tidyverse)

shak.coords <- shakun.metadata[, c("Lon", "Lat")]


nc1 <- nc_open(system.file("extdata", "trace.TS.mon.nc", package = "ecusdata")
               , readunlim = FALSE)

lats <- ncvar_get(nc1, varid = "lat")  
lons <- ncvar_get(nc1, varid = "lon")  
lons <- ifelse(lons > 180, lons - 360, lons)

nc_close(nc1)

t21k.coords <- expand.grid(Lon = lons, Lat = lats)

t21k.ind <- sapply(1:nrow(shak.coords), function(x) {
  which.min(geosphere::distHaversine(shak.coords[x, ], t21k.coords))
})

shak.t21k.coords <- t21k.coords[t21k.ind,]

lons.to.get <- sapply(shak.t21k.coords$Lon, function(x) which(lons == x))
lats.to.get <- sapply(shak.t21k.coords$Lat, function(x) which(lats == x))

coord.inds.to.get <- cbind(lons.to.get, lats.to.get)

filename <-
  system.file("extdata", "trace.TS.mon.nc", package = "ecusdata")
command <- paste("cdo -a remapnn,lon=",
                 shak.t21k.coords$Lon,
                 "/lat=",
                 shak.t21k.coords$Lat,
                 "
                 ",
                 filename,
                 "   ",
                 "temp.nc",
                 sep = "")
system(command)

  temp.nc = open.ncdf("temp.nc") #Read out the data
result <- list()
result$depth <- get.var.ncdf(temp.nc, "DEPTHT")
result$lat <- get.var.ncdf(temp.nc, "lat")
result$lon <- get.var.ncdf(temp.nc, "lon")
result$time <- get.var.ncdf(temp.nc, "TIME_COUNTER")
result$T <- get.var.ncdf(temp.nc, "TEMP")
print(mean(result$T))

# nc1 <- nc_open(system.file("extdata", "trace.TS.mon.nc", package = "ecusdata")
#                , readunlim = FALSE)
# 
# shak.t21k <- apply(coord.inds.to.get[1:2,], 1, function(x) {
#   ncvar_get(nc1, varid = "TS", start = c(x[1], x[2], 1), count = c(1, 1, -1))
# })
# 
# system.time(
# tmp <- ncvar_get(nc1, varid = "TS", start = c(1, 1, 1), count = c(1, 1, -1))
# )
# 
# 
# dates <- ncvar_get(nc1, varid = "date", start = c(1), count = c(-1)) 
# 
# nc_close(nc1)
# 
# dim(K)
# dimnames(K) <- list("lon" = lons, "lat" = lats, "time" = Dtime)
# 
# years <- as.integer(dates / 10000)
# 
# M <- matrix(K, ncol = 12, byrow = TRUE)
# Y <- matrix(years, ncol = 12, byrow = TRUE)[,1]
# 
# plot(M[1,], type = "l", ylim = c(200, 260))
# lines(M[2,])
# lines(M[21000,])
