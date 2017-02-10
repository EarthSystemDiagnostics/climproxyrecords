# Process Data_Alley_2000...
# Andrew Dolman 10.02.2017

library(tidyverse)
library(devtools)

# Read file --------------

filename <- "data-raw/Data_Alley_2000_The Younger Dryas cold interval as viewed from central Greenland.txt" 

alley.temperature <- read_tsv(filename, skip = 74, n_max = 1632) %>% 
  rename(Age.Temperature = `Age           Temperature (C)`) %>% 
  mutate(Age.Temperature = trimws(Age.Temperature)) %>% 
  separate(Age.Temperature, into = c("Age", "Temperature"), sep = "  *") %>% 
  mutate_all(trimws) %>% 
  mutate_all(as.numeric)

alley.accumulation <- read_tsv(filename, skip = 1716, n_max = 1697) %>% 
  rename(Age.Accumulation = `Age          Accumulation`) %>% 
  mutate(Age.Accumulation = trimws(Age.Accumulation)) %>% 
  separate(Age.Accumulation, into = c("Age", "Accumulation"), sep = "  *") %>% 
  mutate_all(trimws) %>% 
  mutate_all(as.numeric)

use_data(alley.accumulation, alley.temperature)
