# Process MD99_2275 data from Sicre et al 2011

library(tidyverse)

readxl::excel_sheets("data-raw/sicre2011.xlsx")

Sicre2011_MD99_2275 <- readxl::read_excel("data-raw/sicre2011.xlsx",
                                          sheet = "MD99-2275 SST", skip = 2,
                                          col_types = c("numeric", "numeric"),
                                          na = "-")


Sicre2011_MD99_2275.age.model <- readxl::read_excel("data-raw/sicre2011.xlsx",
                                                    sheet = "MD99-2275 Age-Model", skip = 2,
                                                    #col_types = c("numeric", "numeric"),
                                                    na = "-") %>% 
  mutate(Marine04 = `Marine04 age BP ± 1σ/(14C yr BP)`) %>% 
  separate(`Tephra model age (cal. yr BP)`, c("Tephra.age", "Tephra.error"),
           sep = "±", remove = FALSE, convert = TRUE) %>% 
  separate(Marine04, c("Marine04.age", "Marine04.error"),
           sep = " ", remove = FALSE, convert = TRUE)


devtools::use_data(Sicre2011_MD99_2275, Sicre2011_MD99_2275.age.model, overwrite = TRUE)

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
# Sicre2011_MD99_2275.age.model %>% 
#   filter(Tephra.age <= 1000) %>% 
# lm(`Core depth (cm)`~ Tephra.age, data = .)
