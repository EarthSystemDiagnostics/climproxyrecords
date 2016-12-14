## Document package and /data

#' climproxyrecords: A package containing the climate proxy data from Marcott et
#' al (2013).
#' 
#' The climproxyrecords package supplies proxy climate record data from
#' published compilations. So far it includes data from two compilations:
#' Marcott et al (2013) and Shakun et al (2012).
#' 
#' For each compilation the package contains three dataframes: \code{proxies},
#' \code{dating}, and \code{metadata} (e.g. \code{marcott.proxies}). These
#' contain the proxy data, associated carbon dating information, and metadata
#' respectively.
#' 
#' Please cite both the compilaton papers (Marcott et al 2013, Shakun et al
#' 2012), and the original sources from which the data were extracted. A full
#' list of sources can be found in the dataframes \code{compilation.metadata}.
#' 
#' @docType package
#' @name climproxyrecords
NULL

#' Climate proxy data from Marcott et al (2013)
#' @description The climate proxy data supplied as supplementary online material
#'   with the publication, Marcott et al (2013), was read into R from the .xlsx
#'   file and reformatted into a handy format for use in R.
#'
#'   Please cite both Marcott et al (2013), and the original sources from which
#'   the data were extracted. A full list of sources can be found in the dataframe
#'   \code{marcott.metadata}
#'
#' @section Reference: Marcott, Shaun A., Jeremy D. Shakun, Peter U. Clark, and
#'   Alan C. Mix. 2013. “A Reconstruction of Regional and Global Temperature for
#'   the Past 11,300 Years.” Science 339 (6124): 1198–1201.
#'   doi:10.1126/science.1228026.
#'
#' @section Corrections: Proxy "GeoB 6518-1 (MBT)" was excluded as it seems to
#'   have duplicated temperature data and no raw proxy data.
#'   
#'   Location information for proxy "Agassiz & Renland", which is the mean of two 
#'   proxy records, was replaced with the mean location, so as to ensure a numeric
#'   value.
#'   
#'   For proxy "MD01-2378", latitude was changed from 13.1 to -13.1
#'   
#' @format A tbl (data.frame) with 11 columns and 10885 rows containing the
#'   following variables:
#' \tabular{lll}{
#' \bold{Variable.name} \tab \bold{Units} \tab \bold{Description} \cr
#' Number                \tab       \tab Integer used to ID unique proxy records in Marcott et al (2013)\cr
#' ID                    \tab       \tab Combination of Core.location and Core.type, to uniquely identify a proxy\cr
#' Core.location         \tab       \tab Core ID code or location name from which proxy was obtained             \cr
#' Proxy.type            \tab       \tab Proxy type                                                              \cr
#' Proxy.value           \tab       \tab Proxy value                                                             \cr
#' Published.temperature \tab deg C \tab Published temperature                                                   \cr
#' Proxy.depth           \tab cm    \tab Proxy depth                                                             \cr
#' Proxy.depth.type      \tab       \tab Proxy depth type                                                        \cr
#' Published.age         \tab yr BP \tab Published age, present = 1950 AD                                        \cr
#' Age.model.error       \tab yr    \tab Standard error of age model                                             \cr
#' Age.type              \tab       \tab Age type                                                                \cr
#' Age                   \tab yr BP \tab Age, present = 1950 AD
#'}
#'
#' @usage data(marcott.proxies)
#'
#' @source \url{http://www.sciencemag.org/content/339/6124/1198}
"marcott.proxies"


#'Climate proxy data from Shakun et al (2012)
#'@description The climate proxy data supplied as supplementary online material 
#'  with the publication, Shakun et al (2012), was read into R from the .xls 
#'  file and reformatted into a handy format for use in R.
#'  
#'  Please cite both Shakun et al (2012), and the original sources from which 
#'  the data were extracted. A full list of sources can be found in the
#'  dataframe \code{shakun.metadata}
#'  
#'@section Reference: Shakun, Jeremy D., Peter U. Clark, Feng He, Shaun A.
#'  Marcott, Alan C. Mix, Zhengyu Liu, Bette Otto-Bliesner, Andreas Schmittner,
#'  and Edouard Bard. 2012. “Global Warming Preceded by Increasing Carbon
#'  Dioxide Concentrations during the Last Deglaciation.” Nature 484 (7392):
#'  49–54. doi:10.1038/nature10915.
#'  
#'@section Corrections: None so far required
#'  
#'@format A tbl (data.frame) with 12 columns and 16879 rows containing the 
#'  following variables: \tabular{lll}{ \bold{Variable.name} \tab \bold{Units}
#'  \tab \bold{Description} \cr ID                    \tab NA    \tab A unique
#'  ID formed by combining Core and Proxy.type\cr Core                  \tab NA 
#'  \tab Core ID                                            \cr Proxy.type      
#'  \tab NA    \tab Proxy type                                         \cr 
#'  Proxy.value           \tab NA    \tab Proxy value                           
#'  \cr Published.temperature \tab deg C \tab NA                                
#'  \cr Temperature           \tab deg C \tab NA                                
#'  \cr Published.age         \tab yr BP \tab Age in yr BP, Present = 1950 AD   
#'  \cr Age.model.error       \tab yr    \tab Estimated error in age model, in
#'  years per 1 SD    \cr Marine04.age          \tab yr BP \tab Age in yr BP,
#'  Present = 1950 AD                    \cr Marine09.age          \tab yr BP
#'  \tab Age in yr BP, Present = 1950 AD                    \cr Proxy.depth.m   
#'  \tab m     \tab Proxy depth                                        \cr 
#'  Proxy.depth.cm        \tab cm    \tab Proxy depth }
#'  
#'@usage data(shakun.proxies)
#'  
#'@source
#'  \url{http://www.nature.com/nature/journal/v484/n7392/full/nature10915.html}
"shakun.proxies"



