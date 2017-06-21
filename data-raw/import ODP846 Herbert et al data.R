# import ODP846

library(tidyverse)

herbert.ODP846.temperature <- read_tsv("data-raw/ODP846.txt", skip = 1) %>% 
  separate(`Depth            Age        SST`, c("Depth", "Age", "SST"), sep = "[ \t]+", convert = T)

devtools::use_data(herbert.ODP846.temperature)

