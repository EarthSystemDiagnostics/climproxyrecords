# Read in data from Marcott.SM.database.S1.xlsx
# Andrew Dolman <andrew.dolman@awi.de>
# 2016.12.6

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
                           proxy.names[68])
# Special cases
prox <- readxl::read_excel("data-raw/Marcott.SM.database.S1.xlsx",
                           "GIK23258-2")


all.proxies <- lapply(proxy.names, function(x){
  readxl::read_excel("data-raw/Marcott.SM.database.S1.xlsx",
                     x)
})

names(all.proxies) <- proxy.names

# Get colnames from all proxies and check for consistency
all.colnames <- lapply(all.proxies, colnames)
table(sapply(all.colnames, length))

# Function to tidy all proxy sheets

Tidy.Proxy <- function(prox, return.type=c("proxy", "carbon")){
  unique.id <- prox[2, 1]

  nms <- names(prox)
  unts <- prox[1, ]

  #proxy.col <- which(nms == "Published Proxy")
  proxy.type <- unts[4][[1]]

  nms[is.na(nms)] <- ""
  unts[is.na(unts)] <- ""

  new.nms <- trimws(paste0(nms, " ", unts), which = "both")

  prox <- prox[-1, ]
  names(prox) <- new.nms

  prox <- prox[, 3:ncol(prox)]

  #col.lengths <- apply(prox, 2, function(x) sum(is.na(x)==FALSE))
  proxy <- data.frame(prox[, 1:6],
                      stringsAsFactors = FALSE,
                      check.names = FALSE)
  carbon <- data.frame(prox[, 9:ncol(prox)],
                       stringsAsFactors = FALSE,
                       check.names = FALSE)

  # remove empty rows
  proxy <- proxy[apply(proxy, 1, function(x) sum(is.na(x)==FALSE)) != 0, ]
  carbon <- carbon[apply(carbon, 1, function(x) sum(is.na(x)==FALSE)) != 0, ]

  proxy$`Proxy type` <- proxy.type
  names(proxy)[2] <- "Published proxy value"

  result <- switch(match.arg(return.type),
                   proxy = proxy,
                   carbon = carbon)

  return(result)
}

Tidy.Proxy(all.proxies[[50]])

tmp <- plyr::ldply(all.proxies, Tidy.Proxy)
