`r format(Sys.time(), "%d %B, %Y")`  

# `climproxyrecords`

The `climproxyrecords` package supplies published proxy climate record data and
compilations. So far it includes data from:

* the Marcott et al (2013) and Shakun et al (2012) compilation

* the GISP2 Ice Core Temperature and Accumulation Data from Alley (2000)

* Uk'37 based proxy for core MD99-2275 from Sicre et al (2011)

* Alkenone based reconstruction for core ODP846 from Herbert et al (2010)

* Alkenone based reconstruction for core U1313 from Naafs et al (2012)

For the two compilations the package contains three dataframes: `proxies`,
`dating`, and `metadata` (e.g. `marcott.proxies`). These
contain the proxy data, associated carbon dating information, and metadata
respectively.

For the individual proxies there are similar dataframes.

`alley.accumulation`  

`alley.temperature`  


`sicre.2011.MD99_2275.age.model` 
 
`sicre.2011.MD99_2275.metadata` 
 
`sicre.2011.MD99_2275.temperature`  


`naafs.U1313.temperature`  

`naafs.U1313.metadata`  

`herbert.ODP846.temperature`  

`herbert.ODP846.metadata`

## Installation

`climproxyrecords` can be installed from Bitbucket like this: 


```r
if (!require("devtools")) {
  install.packages("devtools")
}

devtools::install_bitbucket("ecus/climproxyrecords")
```

## Citing the data

For the compilations, please cite both the compilaton papers (Marcott et al 2013, Shakun et al
2012), and the original sources from which the data were extracted. A full
list of sources can be found in the metadata dataframes, e.g. `marcott.metadata`.


For the other records please cite the original papers. See the help files e.g.
`help(sicre.2011.MD99_2275.temperature)` for the correct citations.


# Using the `climproxyrecords` data package

After loading the package with `library(climproxyrecords)`, all included data has been "lazy loaded". Data are not in memory yet, but are available when the name of an object is passed to the R interpreter.


```r
library(climproxyrecords)
library(dplyr)

marcott.proxies
```

```
## # A tibble: 13,134 x 13
##    Number               ID Core.location Proxy.type Proxy.value
##     <int>            <chr>         <chr>     <fctr>       <dbl>
##  1      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
##  2      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
##  3      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9536
##  4      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9366
##  5      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9400
##  6      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9570
##  7      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
##  8      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9366
##  9      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9366
## 10      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
## # ... with 13,124 more rows, and 8 more variables:
## #   Published.temperature <dbl>, Proxy.depth.type <chr>,
## #   Proxy.depth <dbl>, Published.age <dbl>, Age.model.error <dbl>,
## #   depth.flag <lgl>, Age.type <chr>, Age <dbl>
```

## Subsetting

For each proxy compilation, all records are stored in a single dataframe. To access subsets of proxies use either base R's subsetting 


```r
subset(marcott.proxies, Proxy.type == "Uk'37")
```

```
## # A tibble: 3,222 x 13
##    Number               ID Core.location Proxy.type Proxy.value
##     <int>            <chr>         <chr>     <fctr>       <dbl>
##  1      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
##  2      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
##  3      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9536
##  4      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9366
##  5      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9400
##  6      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9570
##  7      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
##  8      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9366
##  9      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9366
## 10      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
## # ... with 3,212 more rows, and 8 more variables:
## #   Published.temperature <dbl>, Proxy.depth.type <chr>,
## #   Proxy.depth <dbl>, Published.age <dbl>, Age.model.error <dbl>,
## #   depth.flag <lgl>, Age.type <chr>, Age <dbl>
```

or `dplyr::filter`


```r
marcott.proxies %>% 
  filter(Proxy.type == "Uk'37")
```

```
## # A tibble: 3,222 x 13
##    Number               ID Core.location Proxy.type Proxy.value
##     <int>            <chr>         <chr>     <fctr>       <dbl>
##  1      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
##  2      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
##  3      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9536
##  4      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9366
##  5      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9400
##  6      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9570
##  7      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
##  8      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9366
##  9      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9366
## 10      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
## # ... with 3,212 more rows, and 8 more variables:
## #   Published.temperature <dbl>, Proxy.depth.type <chr>,
## #   Proxy.depth <dbl>, Published.age <dbl>, Age.model.error <dbl>,
## #   depth.flag <lgl>, Age.type <chr>, Age <dbl>
```

## Split to a list

or make a list of dataframes, each a separate proxy record


```r
lst <- plyr::dlply(marcott.proxies, "ID")

lapply(lst[1:2], head)
```

```
## $`17940 Uk'37`
##   Number          ID Core.location Proxy.type Proxy.value
## 1     49 17940 Uk'37         17940      Uk'37       0.929
## 2     49 17940 Uk'37         17940      Uk'37       0.932
## 3     49 17940 Uk'37         17940      Uk'37       0.925
## 4     49 17940 Uk'37         17940      Uk'37       0.926
## 5     49 17940 Uk'37         17940      Uk'37       0.933
## 6     49 17940 Uk'37         17940      Uk'37       0.927
##   Published.temperature Proxy.depth.type Proxy.depth Published.age
## 1                26.821 Proxy depth (cm)           0          13.5
## 2                26.922 Proxy depth (cm)           9         174.0
## 3                26.711 Proxy depth (cm)          17         326.0
## 4                26.725 Proxy depth (cm)          21         396.0
## 5                26.950 Proxy depth (cm)          27         492.0
## 6                26.752 Proxy depth (cm)          37         635.0
##   Age.model.error depth.flag             Age.type       Age
## 1              NA       TRUE Marine09 age (yr BP)   0.00000
## 2        90.18293      FALSE Marine09 age (yr BP)  74.96323
## 3        96.58324      FALSE Marine09 age (yr BP) 139.87508
## 4        88.40831      FALSE Marine09 age (yr BP) 171.82024
## 5       108.50835      FALSE Marine09 age (yr BP) 242.60834
## 6       116.74236      FALSE Marine09 age (yr BP) 370.76723
## 
## $`18287-3 Uk'37`
##   Number            ID Core.location Proxy.type Proxy.value
## 1     28 18287-3 Uk'37       18287-3      Uk'37      0.9631
## 2     28 18287-3 Uk'37       18287-3      Uk'37      0.9662
## 3     28 18287-3 Uk'37       18287-3      Uk'37      0.9662
## 4     28 18287-3 Uk'37       18287-3      Uk'37      0.9662
## 5     28 18287-3 Uk'37       18287-3      Uk'37      0.9631
## 6     28 18287-3 Uk'37       18287-3      Uk'37      0.9631
##   Published.temperature Proxy.depth.type Proxy.depth Published.age
## 1                  28.1 Proxy depth (cm)           5          3389
## 2                  28.2 Proxy depth (cm)          15          3751
## 3                  28.2 Proxy depth (cm)          25          4114
## 4                  28.2 Proxy depth (cm)          35          4476
## 5                  28.1 Proxy depth (cm)          45          4838
## 6                  28.1 Proxy depth (cm)          55          5200
##   Age.model.error depth.flag             Age.type      Age
## 1        377.0880      FALSE Marine09 age (yr BP) 1776.787
## 2        184.3612      FALSE Marine09 age (yr BP) 3746.217
## 3        285.4207      FALSE Marine09 age (yr BP) 4105.665
## 4        346.4947      FALSE Marine09 age (yr BP) 4466.036
## 5        387.1881      FALSE Marine09 age (yr BP) 4826.850
## 6        413.6232      FALSE Marine09 age (yr BP) 5187.967
```



## **Warnings**

Core.location does not identify a unique proxy record (for the Marcott data at least) because some cores have multiple proxies measured on them. 


```r
name.type <- marcott.proxies %>% 
  select(Core.location, Proxy.type) %>% 
  distinct()

name.type %>% 
  group_by(Core.location) %>% 
  mutate(n = n_distinct(Proxy.type)) %>% 
  filter(n > 1)
```

```
## # A tibble: 9 x 3
## # Groups:   Core.location [3]
##   Core.location                Proxy.type     n
##           <chr>                    <fctr> <int>
## 1      MD79-257  Foram T.F. (warm season)     3
## 2    GIK23258-2  Foram T.F. (warm season)     3
## 3      MD79-257  Foram T.F. (cold season)     3
## 4    GIK23258-2  Foram T.F. (cold season)     3
## 5      TN057-17 Diatom T.F. (warm season)     3
## 6      TN057-17 Diatom T.F. (cold season)     3
## 7      MD79-257  Foram T.F. (mean; deg C)     3
## 8    GIK23258-2  Foram T.F. (mean; deg C)     3
## 9      TN057-17 Diatom T.F. (mean; deg C)     3
```


At present, things like the names of proxy types have been taken "as is" from the supplementary data to the publications. There may be multiple spellings of the same type.


## Get metadata

To get additional metadata for the proxies, look at corresponding `metadata` dataframe and reference/join by `ID`


```r
dplyr::left_join(marcott.proxies, marcott.metadata)
```

```
## Joining, by = c("Number", "Core.location", "Proxy.type")
```

```
## # A tibble: 13,134 x 22
##    Number               ID Core.location Proxy.type Proxy.value
##     <int>            <chr>         <chr>     <fctr>       <dbl>
##  1      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
##  2      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
##  3      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9536
##  4      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9366
##  5      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9400
##  6      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9570
##  7      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
##  8      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9366
##  9      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9366
## 10      1 GeoB5844-2 UK'37    GeoB5844-2      Uk'37      0.9502
## # ... with 13,124 more rows, and 17 more variables:
## #   Published.temperature <dbl>, Proxy.depth.type <chr>,
## #   Proxy.depth <dbl>, Published.age <dbl>, Age.model.error <dbl>,
## #   depth.flag <lgl>, Age.type <chr>, Age <dbl>, Proxy.type.detail <chr>,
## #   Temperature.cali.ref <chr>, Lat <dbl>, Lon <dbl>, Elevation <int>,
## #   Resolution <int>, Pub.seas.interp <chr>, Reference <chr>,
## #   Seasonality.comment <chr>
```

```r
marcott.metadata %>% 
  filter(Core.location == "GeoB5844-2")
```

```
## # A tibble: 1 x 12
##   Number Core.location Proxy.type Proxy.type.detail
##    <int>         <chr>     <fctr>             <chr>
## 1      1    GeoB5844-2      Uk'37             UK’37
## # ... with 8 more variables: Temperature.cali.ref <chr>, Lat <dbl>,
## #   Lon <dbl>, Elevation <int>, Resolution <int>, Pub.seas.interp <chr>,
## #   Reference <chr>, Seasonality.comment <chr>
```




