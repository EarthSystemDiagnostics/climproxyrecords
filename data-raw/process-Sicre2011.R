# Process MD99_2275 data from Sicre et al 2011

library(tidyverse)

readxl::excel_sheets("data-raw/sicre2011.xlsx")

Sicre2011_MD99_2275 <- readxl::read_excel("data-raw/sicre2011.xlsx",
                                          sheet = "MD99-2275 SST", skip = 2,
                                          col_types = c("numeric", "numeric"),
                                          na = "-") %>% 
  mutate(Core = "MD99-2275", Number = 1, ID.no = "N1",
         ID = "MD99-2275 UK'37", Proxy.type = "UK'37",
         Published.temperature = `T °C`,
         Age.yrs.AD = round(`Age (yrs AD)`),
         Age.yrs.BP = 1950-Age.yrs.AD) %>% 
  select(Core, Number, ID.no, ID, Proxy.type, Published.temperature, Age.yrs.AD, Age.yrs.BP)


Sicre2011_MD99_2275.age.model <- readxl::read_excel("data-raw/sicre2011.xlsx",
                                                    sheet = "MD99-2275 Age-Model", skip = 2,
                                                    #col_types = c("numeric", "numeric"),
                                                    na = "-") %>% 
  mutate(Marine04 = `Marine04 age BP ± 1σ/(14C yr BP)`) %>% 
  separate(`Tephra model age (cal. yr BP)`, c("Tephra.age", "Tephra.error"),
           sep = "±", remove = FALSE, convert = TRUE) %>% 
  separate(Marine04, c("Marine04.age", "Marine04.error"),
           sep = " ", remove = FALSE, convert = TRUE)


## create metadata for MD99_2275

Sicre2011_MD99_2275.metadata <- structure(list(Number = 1, ID.no = "N1", Core = "MD99-2275", Location = "Subpolar North Atlantic", 
               Proxy = "UK'37", Lat = 66.55, Lon = -17.7, Elevation = "-470", 
               Reference = "Sicre et al. 2011", 
               Resolution = 20, Calibration.ref = "", 
               Calibration = "", Foram.sp = "", 
               Ref.14C = "", Notes = "NA_character_", Geo.cluster = "Iceland", 
               Archive.type = "Marine sediment"), .Names = c("Number", "ID.no", 
                                                      "Core", "Location", "Proxy", "Lat", "Lon", "Elevation", "Reference", 
                                                      "Resolution", "Calibration.ref", "Calibration", "Foram.sp", "Ref.14C", 
                                                      "Notes", "Geo.cluster", "Archive.type"), row.names = c(NA, -1L
                                                      ), class = c("tbl_df", "tbl", "data.frame"))


devtools::use_data(Sicre2011_MD99_2275, Sicre2011_MD99_2275.age.model, Sicre2011_MD99_2275.metadata, overwrite = TRUE)


# p <- Sicre2011_MD99_2275 %>%
#   ggplot(aes(x = `Age (yrs AD)`, y = `T °C`)) %>%
#   + geom_line() +
#   geom_point() 
# p

# library(splines)
# p <- Sicre2011_MD99_2275.age.model %>% 
#   ggplot(aes(x = `Tephra.age`, y = `Spliced core depth (cm)`)) %>% 
#   + geom_line() +
#   geom_point() +
#   geom_smooth(method = "lm", formula = y ~ ns(x, 3))
# p
# 
Sicre2011_MD99_2275.age.model %>%
  filter(Tephra.age <= 1000) %>%
lm(`Core depth (cm)`~ Tephra.age, data = .)
