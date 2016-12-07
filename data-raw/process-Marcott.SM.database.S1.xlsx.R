# Read in data from Marcott.SM.database.S1.xlsx
# Andrew Dolman <andrew.dolman@awi.de>
# 2016.12.6

# TODO(AMD) check for updated data online
# TODO(AMD) for proxies with summer and winter estimates, make long
library(tidyverse)

sheet.names <- readxl::excel_sheets("data-raw/Marcott.SM.database.S1.xlsx")

# Read metadata sheet -------------------------------------
# Skip admonishment to cite orinignal authors on first line
# But of course do cite authors!
metadata <- readxl::read_excel("data-raw/Marcott.SM.database.S1.xlsx",
                               "METADATA", skip = 1)
nrow.metadata <- nrow(metadata)

# Clean up second row which contained units only for elevation
tmp.names <- names(metadata)
tmp.suffixes <- metadata[1,]
tmp.suffixes[is.na(tmp.suffixes)] <- ""
names(metadata) <- paste0(tmp.names, tmp.suffixes)
metadata <- metadata[-1, ]
rm(tmp.names, tmp.suffixes)

stopifnot(nrow.metadata-1 == nrow(metadata))


# Read in raw proxy data -----------------------------------

proxy.names <- sheet.names[5:length(sheet.names)]

## For now just take 1
prox <- readxl::read_excel("data-raw/Marcott.SM.database.S1.xlsx",
                           proxy.names[1])
# Special cases
prox <- readxl::read_excel("data-raw/Marcott.SM.database.S1.xlsx",
                           "GIK23258-2")


all.proxies <- lapply(proxy.names, function(x){
  readxl::read_excel("data-raw/Marcott.SM.database.S1.xlsx",
                     sheet = x,
                     na = "-")
})

names(all.proxies) <- proxy.names

# Get colnames from all proxies and check for consistency
all.colnames <- lapply(all.proxies, colnames)

# Function to tidy all proxy sheets

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
 # new.nms[is.na(new.nms)] <- make.names(new.nms[is.na(new.nms)], unique = TRUE)
 # new.nms[new.nms==""] <- make.names(new.nms[new.nms==""], unique = TRUE)
  # Duplicate names?
  dupes <- as.logical(duplicated(new.nms) +
                        duplicated(new.nms, fromLast = TRUE))
  new.nms[dupes] <- make.names(new.nms[dupes], unique = TRUE)
  #print(unique.id)

  # remove "units" row and replace names with new names
  prox <- prox[-1, ]
  names(prox) <- new.nms

  # remove first three cols which contained unique ID
  prox <- prox[, 3:ncol(prox)]

  # remove empty columns
  # prox <- prox[, apply(prox, 2, function(x) sum(is.na(x)==FALSE)) != 0]

  # make separate data.frames for proxy data and assocated cabon dating data
  # because they have different lengths?

  # proxy <- data.frame(prox[, 1:6],
  #                     stringsAsFactors = FALSE,
  #                     check.names = FALSE)

  proxy <- dplyr::select_(prox, .dots=quote(1:`Age model error (yr, 1σ)`))


  carbon <- data.frame(prox[, 9:ncol(prox)],
                       stringsAsFactors = FALSE,
                       check.names = FALSE)

  # remove empty rows
  proxy <- proxy[apply(proxy, 1, function(x) sum(is.na(x)==FALSE)) != 0, ]
  carbon <- carbon[apply(carbon, 1, function(x) sum(is.na(x)==FALSE)) != 0, ]

  #proxy$`Proxy type` <- proxy.type
  #names(proxy)[2] <- "Published proxy value"

  result <- switch(match.arg(return.type),
                   proxy = proxy,
                   carbon = carbon)

  return(result)
}


# Process all proxies -----------------------------

Tidy.Proxy(all.proxies[[25]], return.type = "carbon")
Tidy.Proxy(all.proxies[[25]])

## Exclude proxy "GeoB 6518-1 (MBT)" which seems to have duplicated temperature and no raw proxy data
excl <- which(proxy.names=="GeoB 6518-1 (MBT)")

Proxies <- plyr::ldply(all.proxies[-68], Tidy.Proxy, return.type = "proxy") %>%
  gather(`Proxy type`, `Proxy value`,
         starts_with("Published Proxy"),
         starts_with("Published Temperature Foram"),
         starts_with("Published Temperature Diatom")) %>%
  filter(complete.cases(`Proxy value`)) %>%
  tbl_df() %>%
  # Next line removes empty columns
  .[, apply(., 2, function(x) sum(is.na(x)==FALSE)) != 0] %>%
  # Fix types
  # as.is = TRUE keeps character strings rather than converting to factors
  mutate_each(funs(type.convert(as.character(.), as.is = TRUE)))


Proxies %>%
  group_by(.id) %>%
  summarise(no_types = n_distinct(`Proxy type`))



# Process all carbon dating data ------------------

Carbon <- plyr::ldply(all.proxies, Tidy.Proxy, return.type = "carbon") %>%
  tbl_df() %>%
  # Next line remove all columns with no non NA entries
  .[, apply(., 2, function(x) sum(is.na(x)==FALSE)) != 0]

