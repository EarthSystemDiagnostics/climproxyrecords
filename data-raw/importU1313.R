# import U1313

# Naafs, Bernhard David A; Hefter, Jens; Acton, Gary D; Haug, Gerald H;
# Martinez-Garcia, Alfredo; Pancost, Richard D; Stein, Ruediger (2012):
# Concentrations and accumulation rates of biomarkers and SSTs at IODP Site
# 306-U1313. PANGAEA, https://doi.org/10.1594/PANGAEA.757946, 

# In supplement to:
# Naafs, BDA et al. (2012): Strengthening of North American dust sources during
# the late Pliocene (2.7 Ma). Earth and Planetary Science Letters, 317-318,
# 8-19, https://doi.org/10.1016/j.epsl.2011.11.026


library(tidyverse)

naafs.U1313.temperature.raw <- read_tsv("data-raw/306-U1313_acc_rate_alkane.tab", skip = 24) 

naafs.U1313.temperature <- naafs.U1313.temperature.raw %>% 
  mutate(Core = "U1313", Number = 1, ID.no = "N1",
         ID = "U1313 UK'37", Proxy.type = "UK'37",
         Published.temperature = `SST (1-12) [°C]`,
         Age.kyrs.BP = `Age [ka BP]`,
         Age.yrs.BP = round(Age.kyrs.BP*1000),
         Depth.m = `Depth [m]`,
         Sed.acc.rate.cm.kyr = `Sed rate [cm/ka]`,
         Sed.acc.rate.m.yr = Sed.acc.rate.cm.kyr / 1e+05) %>% 
  filter(complete.cases(Published.temperature)) %>% 
  select(Core, Number, ID.no, ID, Proxy.type, Published.temperature, Age.kyrs.BP, Age.yrs.BP, Depth.m, Sed.acc.rate.m.yr)




## create metadata

naafs.U1313.metadata <- structure(list(Number = 1, ID.no = "N1", Core = "U1313", Location = "North Atlantic", 
                                          Proxy = "UK'37", Lat = 40.00, Lon = -32.95, Elevation = "-3426.0", 
                                          Reference = "Naafs et al. 2012", 
                                          Resolution = "", Calibration.ref = "", 
                                          Calibration = "", Foram.sp = "", 
                                          Ref.14C = "", Notes = "", Geo.cluster = "", 
                                          Archive.type = "Marine sediment"), .Names = c("Number", "ID.no", 
                                                                                        "Core", "Location", "Proxy", "Lat", "Lon", "Elevation", "Reference", 
                                                                                        "Resolution", "Calibration.ref", "Calibration", "Foram.sp", "Ref.14C", 
                                                                                        "Notes", "Geo.cluster", "Archive.type"), row.names = c(NA, -1L
                                                                                        ), class = c("tbl_df", "tbl", "data.frame"))


devtools::use_data(naafs.U1313.temperature, naafs.U1313.metadata, overwrite = TRUE)

