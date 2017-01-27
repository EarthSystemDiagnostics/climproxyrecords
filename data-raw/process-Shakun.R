# Read in data from nature10915-s2.xls, supplementary data to Shakun et al (2012)
# Andrew Dolman <andrew.dolman@awi.de>
# 2016.12.09

library(plyr)
library(dplyr)
library(tidyr)
library(readxl)

sheet.names <- readxl::excel_sheets("data-raw/nature10915-s2.xls")

# Read metadata sheet -------------------------------------
# Skip admonishment to cite original authors on first line
# But of course do cite authors!
metadata.raw <- readxl::read_excel("data-raw/nature10915-s2.xls",
                                   "METADATA")

metadata.raw2 <- metadata.raw %>%
  # remove empty columns
  .[, apply(., 2, function(x) sum(is.na(x)==FALSE)) != 0] %>%
  # remove empty rows
  .[apply(., 1, function(x) sum(is.na(x)==FALSE)) != 0, ] 

metadata.raw3 <- metadata.raw2 %>%
  rename(
    Number = `#`,
    Calibration.ref = `Calibration reference`,
    Lat = `Lat (°)`,
    Lon = `Lon (°)`,
    Elevation = `Elev/Depth (m)`,
    Resolution = `Resolution (yr)`,
    Foram.sp = `Foram species`,
    Ref.14C = `Additional 14C reference`
    ) %>% 
  mutate(ID.no = paste0("N", Number)) %>% 
  # strip leading and trailing whitespace from strings
  mutate_if(is.character, trimws, which = "both")
  

# Correct errors or other idiosyncratic aspects ---------------


# Read extra metadata ---------------

extra.meta <- read.csv("data-raw/shakun-extra-metadata.csv", sep=";",
                       stringsAsFactors = FALSE) %>% 
  mutate(ID.no = paste0("N", Number))

shakun.metadata <- left_join(metadata.raw3, extra.meta) %>% 
  select(Number, ID.no, everything())
devtools::use_data(shakun.metadata, overwrite = TRUE)
 
# Read in raw proxy data -----------------------------------
proxy.names <- sheet.names[4:length(sheet.names)]

# Named list of all sheets
all.proxies <- lapply(proxy.names, function(x){
  readxl::read_excel("data-raw/nature10915-s2.xls",
                     sheet = x,
                     na = "-")
})
names(all.proxies) <- proxy.names

#length(all.proxies)

# Correct individual sheets --------------

# "PL07-39PC" has the estimated age in place of depth
# correct values extracted from the supplementary data of original publication
# Lea at al 2003 "Lea.SOM.final.pdf"
PL07.corrections <- read.csv("data-raw/PL07-39PC_corrections.csv", sep = ";")
all.proxies[["PL07-39PC"]]$`Proxy depth`[2:nrow(all.proxies[["PL07-39PC"]])] <-
  as.numeric(PL07.corrections$Correct.proxy.depth.cm)


# Function to tidy each proxy sheet
#' @param prox a read-in sheet containing proxy data from "nature10915-s2.xls"
#' @param return.type return either the proxy part or the carbon dating part
#'
#' @return a data.frame
Tidy.Proxy <- function(prox, return.type=c("proxy", "carbon")){
  
  nms <- names(prox)
  unts <- prox[1, ]

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


  # make separate data.frames for proxy data and assocated cabon dating data
  # because they have different lengths
  proxy <- dplyr::select_(prox, .dots=quote(1:`Age model error (yr, 1σ)`))
  
  carbon <- data.frame(prox[, which(new.nms=="Age model error (yr, 1σ)"):ncol(prox)],
                       stringsAsFactors = FALSE,
                       check.names = FALSE)[,-1]


  # remove empty rows
  proxy <- proxy[apply(proxy, 1, function(x) sum(is.na(x)==FALSE)) != 0, ]
  carbon <- carbon[apply(carbon, 1, function(x) sum(is.na(x)==FALSE)) != 0, ]

  result <- switch(match.arg(return.type),
                   proxy = proxy,
                   carbon = carbon)

  return(result)
}

#Tidy.Proxy(all.proxies[[1]], return.type = "proxy")


 
# Process all proxies -----------------------------

proxies.1 <- plyr::ldply(all.proxies, Tidy.Proxy, return.type = "proxy",
                         .id = "Core") %>%
  tbl_df() %>% 
  # Fix types
  # as.is = TRUE keeps character strings rather than converting to factors
  mutate_each(funs(type.convert(as.character(.), as.is = TRUE))) %>%
  mutate(no.proxy.flag = rowSums(select(., one_of(c("TEX86", "Mg/Ca (mmol/mol)",
                                                    "UK'37", "d18O (VSMOW)",
                                                    "Published temperature T_warm (°C)"))),
                                 na.rm = TRUE)==0)
# Have to treat records with values for proxies separate from those with only values
# for temperature
proxies.1a <- proxies.1 %>% 
  filter(no.proxy.flag == FALSE) %>% 
  gather(`Proxy type`, `Proxy value`,
         starts_with("TEX86"),
         starts_with("Mg/Ca"),
         starts_with("UK'37"),
         starts_with("d18O (VSMOW)"),
         starts_with("Published temperature T_warm (°C)")) %>% 
  filter(complete.cases(`Proxy value`))
  #filter(is.na(`Proxy value`) == FALSE | no.proxy.flag == TRUE) %>% 

proxies.1b <- proxies.1 %>% 
  filter(no.proxy.flag == TRUE) %>% 
  select(-starts_with("TEX86"),
         -starts_with("Mg/Ca"),
         -starts_with("UK'37"),
         -starts_with("d18O (VSMOW)"),
         -starts_with("Published temperature T_warm (°C)"))
  
proxies.1ab <- bind_rows(proxies.1a, proxies.1b) %>% 
    # Next line removes empty columns
  .[, apply(., 2, function(x) sum(is.na(x)==FALSE)) != 0] %>%
  # single depth type
  mutate(
    Proxy.depth.m = ifelse(
      is.na(`Proxy depth (m)`),
      `Proxy depth (cm)` / 100,
      `Proxy depth (m)`
    ),
    Proxy.depth.cm = ifelse(
      is.na(`Proxy depth (cm)`),
      `Proxy depth (m)` * 100,
      `Proxy depth (cm)`
    )
  ) %>% 
  select(-`Proxy depth (cm)`, -`Proxy depth (m)`)

# no.age.model.types <- rowSums(is.na(proxies.1[, c("IntCal04 age (yr BP)",
#                                                   "IntCal09 age (yr BP)", 
#                                                   "Marine04 age (yr BP)", 
#                                                   "Marine09 age (yr BP)")])==FALSE)
# stopifnot(all(no.age.model.types <= 1))

# Keep separate age models

# Tidy names and create glossary -------------------

tmp.nms.1 <- gsub(" ", ".", names(proxies.1ab))
tmp.nms <- sapply(strsplit(tmp.nms.1, ".(", fixed = TRUE), function(x) head(x, 1))
proxies.2 <- proxies.1ab
names(proxies.2) <- tmp.nms

proxies.3 <- proxies.2 %>%
  mutate(ID = paste0(Core, " ", Proxy.type)) %>%
  select(ID, Core, Proxy.type, Proxy.value, Published.temperature,
         everything()) %>% 
  # Filter out 2 records for "ODP1144" with missing Proxy.value
  filter((Core == "ODP1144" & no.proxy.flag == TRUE) == FALSE)


# View(cbind(paste(shakun.metadata$Number,
#                  shakun.metadata$Core, 
#                  shakun.metadata$Location, 
#                  shakun.metadata$Reference,
#                  shakun.metadata$Proxy), proxy.names))

# shakun.glossary <- data.frame(Variable.name = names(shakun.proxies), Description = NA)
# write.csv(shakun.glossary, "data-raw/shakun.glossary.csv", row.names = FALSE)

# n <- 1:80
# n[67] <- 68
# n[68] <- 67
# shak.key <- data.frame(Core = proxy.names,
#                        Number = n)
# write.csv(shak.key, "data-raw/shak.key.csv", row.names = FALSE)

shak.key <- read.csv("data-raw/shak.key.csv", stringsAsFactors = FALSE) %>% 
  mutate(ID.no = paste0("N", Number))

shakun.proxies <- left_join(shak.key, proxies.3) %>% 
  tbl_df()

shakun.proxies <- shakun.proxies %>% 
  mutate(Age = ifelse(is.na(Marine04.age), Published.age, Marine04.age)) %>% 
  select(Core, Number, ID.no, ID, Proxy.type, Proxy.value, Published.temperature, 
         Temperature, Age, everything())
  

devtools::use_data(shakun.proxies, overwrite = TRUE)


# Process all carbon dating data ------------------

shakun.dating <- plyr::ldply(all.proxies, Tidy.Proxy, return.type = "carbon",
                              .id = "Core") %>%
  tbl_df() %>%
  # Next line remove all columns with no non NA entries
  .[, apply(., 2, function(x) sum(is.na(x)==FALSE)) != 0] %>% 
  mutate_each(funs(type.convert(as.character(.), as.is = TRUE))) 

devtools::use_data(shakun.dating, overwrite = TRUE)
