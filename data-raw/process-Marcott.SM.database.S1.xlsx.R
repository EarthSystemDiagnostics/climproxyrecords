# Read in data from Marcott.SM.database.S1.xlsx
# Andrew Dolman <andrew.dolman@awi.de>
# 2016.12.6

library(plyr)
library(dplyr)
library(tidyr)
library(readxl)

sheet.names <- readxl::excel_sheets("data-raw/Marcott.SM.database.S1.xlsx")

# Read metadata sheet -------------------------------------
# Skip admonishment to cite orinignal authors on first line
# But of course do cite authors!
metadata.raw <- readxl::read_excel("data-raw/Marcott.SM.database.S1.xlsx",
                               "METADATA", skip = 1, na = "-")

nrow.metadata <- nrow(metadata.raw)

# Clean up second row which contained units only for elevation
tmp.names <- names(metadata.raw)
tmp.suffixes <- metadata.raw[1,]
tmp.suffixes[is.na(tmp.suffixes)] <- ""
names(metadata.raw) <- paste0(tmp.names, tmp.suffixes)

metadata.raw2 <- metadata.raw[-1, ] %>%
  # remove empty columns
  .[, apply(., 2, function(x) sum(is.na(x)==FALSE)) != 0] %>%
  # remove empty rows
  .[apply(., 1, function(x) sum(is.na(x)==FALSE)) != 0, ] %>%
  # remove final 3 comment rows
  head(., nrow(.)-3)

metadata.raw3 <- metadata.raw2 %>%
  rename(
    Core.location = `Location / Core`,
    Proxy.type = Proxy,
    Temperature.cali.ref = `Temperature Calibration  / Reference`,
    Lat = `Latitude (°)`,
    Lon = `Longitude (°)`,
    Elevation = `Elevation (m a.s.l.)`,
    Resolution = `Resolution (yr)`,
    Pub.seas.interp = `Published Seasonal Interpretation`
    )

# For Core.location == Agassiz & Renland there are 2 Lon, Lat and Elevation
# values because they have averaged 2 cores at very different locations.
# This prevents type numeric.

# Solution: insert averages in place

metadata.raw3[metadata.raw3$Core.location == "Agassiz & Renland",
              c("Lat", "Lon", "Elevation")] <-
  c(mean(71.3, 81), mean(26.7, -71), mean(1730, 2350))


extra.comments <- tail(metadata.raw, 3)$`Location / Core`

metadata <- metadata.raw3 %>%
  mutate_each(funs(type.convert(as.character(.), as.is = TRUE))) %>%
  mutate(Seasonality.comment = ifelse(
    grepl("**", Pub.seas.interp, fixed = TRUE),
    extra.comments[2],
    ifelse(grepl("*", Pub.seas.interp, fixed = TRUE),
           extra.comments[1], "")
  ))


rm(tmp.names, tmp.suffixes)


devtools::use_data(metadata, overwrite = TRUE)


# Read in raw proxy data -----------------------------------
proxy.names <- sheet.names[5:length(sheet.names)]

# Named list of all sheets
all.proxies <- lapply(proxy.names, function(x){
  readxl::read_excel("data-raw/Marcott.SM.database.S1.xlsx",
                     sheet = x,
                     na = "-")
})
names(all.proxies) <- proxy.names


# Function to tidy each proxy sheet
#' @param prox a read-in sheet containing proxy data from "Marcott.SM.database.S1.xlsx"
#' @param return.type return either the proxy part or the carbon dating part
#'
#' @return a data.frame
Tidy.Proxy <- function(prox, return.type=c("proxy", "carbon")){
  unique.id <- prox[2, 1]

  nms <- names(prox)
  unts <- prox[1, ]

  #proxy.col <- which(nms == "Published Proxy")
  #proxy.type <- unts[4][[1]]

  nms[is.na(nms)] <- ""
  unts[is.na(unts)] <- ""

  # paste names and 1st row "units" together
  # trim leading and trailing whitespace
  new.nms <- trimws(paste0(nms, " ", unts), which = "both")

  # Find duplicate colnames and make unique
  # This will also catch NA and ""
    dupes <- as.logical(duplicated(new.nms) +
                        duplicated(new.nms, fromLast = TRUE))
  new.nms[dupes] <- make.names(new.nms[dupes], unique = TRUE)

  # remove "units" row and replace names with new names
  prox <- prox[-1, ]
  names(prox) <- new.nms

  # remove first three cols which contained unique ID
  prox <- prox[, 3:ncol(prox)]

  # make separate data.frames for proxy data and assocated cabon dating data
  # because they have different lengths
  proxy <- dplyr::select_(prox, .dots=quote(1:`Age model error (yr, 1σ)`))

  carbon <- data.frame(prox[, 9:ncol(prox)],
                       stringsAsFactors = FALSE,
                       check.names = FALSE)


  # remove empty rows
  proxy <- proxy[apply(proxy, 1, function(x) sum(is.na(x)==FALSE)) != 0, ]
  carbon <- carbon[apply(carbon, 1, function(x) sum(is.na(x)==FALSE)) != 0, ]

  result <- switch(match.arg(return.type),
                   proxy = proxy,
                   carbon = carbon)

  return(result)
}


# Process all proxies -----------------------------

# Exclude proxy "GeoB 6518-1 (MBT)" which seems to have duplicated temperature and no raw proxy data
excl <- which(proxy.names=="GeoB 6518-1 (MBT)")

proxies.1 <- plyr::ldply(all.proxies[-68], Tidy.Proxy, return.type = "proxy",
                         .id = "Core.location") %>%
  gather(`Proxy type`, `Proxy value`,
         starts_with("Published Proxy"),
         starts_with("Published Temperature Foram"),
         starts_with("Published Temperature Diatom")) %>%
  filter(complete.cases(`Proxy value`)) %>%
  mutate(`Proxy type` = gsub("Published Proxy ", "", `Proxy type`),
         `Proxy type` = gsub("Published Temperature ", "", `Proxy type`)) %>%
  tbl_df() %>%
  # Next line removes empty columns
  .[, apply(., 2, function(x) sum(is.na(x)==FALSE)) != 0] %>%
  # Fix types
  # as.is = TRUE keeps character strings rather than converting to factors
  mutate_each(funs(type.convert(as.character(.), as.is = TRUE))) %>%
  # gather different depth types
  gather(`Proxy depth type`, `Proxy depth (cm)`,
         starts_with("Proxy depth")) %>%
  filter(complete.cases(`Proxy depth (cm)`))


# gather different age model types
# this has to be done separately because there are entries with no Age estimate
# at all that we still want to keep
proxies.2 <- proxies.1 %>%
  gather(`Age type`, `Age (yr BP)`,
       `Marine09 age (yr BP)`, `IntCal09 age (yr BP)`, `SHCal04 age (yr BP)`) %>%
  filter(complete.cases(`Age (yr BP)`)) %>%
  left_join(proxies.1, .) %>%
  select(-`Marine09 age (yr BP)`, -`IntCal09 age (yr BP)`, -`SHCal04 age (yr BP)`)


# Tidy names and create glossary -------------------

tmp.nms.1 <- gsub(" ", ".", names(proxies.2))
tmp.nms <- sapply(strsplit(tmp.nms.1, ".(", fixed = TRUE), function(x) head(x, 1))
proxies.3 <- proxies.2
names(proxies.3) <- tmp.nms

proxies <- proxies.3 %>%
  rename(Published.temperature = Published.Temperature) %>%
  mutate(ID = paste0(Core.location, " ", Proxy.type)) %>%
  select(ID, Core.location, Proxy.type, Proxy.value, Published.temperature,
         Proxy.depth.type, Proxy.depth, Published.age, everything())

# proxy.glossary <- data.frame(Variable.name = names(proxies), Long.name = names(proxies.2))
# write.csv(proxy.glossary, "data-raw/proxy.glossary.csv", row.names = FALSE)

devtools::use_data(proxies, overwrite = TRUE)


# Process all carbon dating data ------------------

dating <- plyr::ldply(all.proxies, Tidy.Proxy, return.type = "carbon",
                      .id = "Core.location") %>%
  tbl_df() %>%
  # Next line remove all columns with no non NA entries
  .[, apply(., 2, function(x) sum(is.na(x)==FALSE)) != 0]


devtools::use_data(dating, overwrite = TRUE)

rm(proxies, proxies.1, proxies.2, proxies.3, dating, metadata)
