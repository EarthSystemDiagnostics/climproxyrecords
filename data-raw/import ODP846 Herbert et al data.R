# import ODP846

library(tidyverse)

herbert.ODP846.temperature <- read_tsv("data-raw/ODP846.txt", skip = 1) %>% 
  separate(`Depth            Age        SST`, c("Depth", "Age", "SST"), sep = "[ \t]+", convert = T) %>% 
  mutate(Core = "ODP846", Number = 1, ID.no = "N1",
         ID = "ODP846 UK'37", Proxy.type = "UK'37",
         Published.temperature = SST,
         Age.kyrs.BP = Age,
         Age.yrs.BP = round(Age*1000),
         Depth.m = Depth) %>% 
  select(Core, Number, ID.no, ID, Proxy.type, Published.temperature, Age.kyrs.BP, Age.yrs.BP, Depth.m)




## create metadata for ODP846

herbert.ODP846.metadata <- structure(list(Number = 1, ID.no = "N1", Core = "ODP846", Location = "East Pacific", 
                                               Proxy = "UK'37", Lat = -3.096, Lon = -90.82, Elevation = "-3296", 
                                               Reference = "Herbert et al. 2010", 
                                               Resolution = "", Calibration.ref = "", 
                                               Calibration = "", Foram.sp = "", 
                                               Ref.14C = "", Notes = "", Geo.cluster = "", 
                                               Archive.type = "Marine sediment"), .Names = c("Number", "ID.no", 
                                                                                             "Core", "Location", "Proxy", "Lat", "Lon", "Elevation", "Reference", 
                                                                                             "Resolution", "Calibration.ref", "Calibration", "Foram.sp", "Ref.14C", 
                                                                                             "Notes", "Geo.cluster", "Archive.type"), row.names = c(NA, -1L
                                                                                             ), class = c("tbl_df", "tbl", "data.frame"))


devtools::use_data(herbert.ODP846.temperature, herbert.ODP846.metadata, overwrite = TRUE)

