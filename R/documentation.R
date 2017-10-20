## Document package and /data

#' climproxyrecords: A package containing climate proxy data.
#' 
#' @description The climproxyrecords package supplies published proxy climate record data and
#' compilations. So far it includes data from two compilations:
#' Marcott et al (2013) and  Shakun et al (2012);
#' 
#' The GISP2 Ice Core Temperature and Accumulation Data from Alley (2000);
#' 
#' Uk'37 based proxy for core MD99-2275 from Sicre et al (2011);
#' 
#' Alkenone based reconstruction for core ODP846 from Herbert et al (2010);
#' 
#' Alkenone based reconstruction for core U1313 from Naafs et al (2012).
#' 
#' @details 
#' For the two compilations the package contains three dataframes: \code{proxies},
#' \code{dating}, and \code{metadata} (e.g. \code{marcott.proxies}). These
#' contain the proxy data, associated carbon dating information, and metadata
#' respectively.
#' 
#' For the individual proxies there are similar dataframes.
#' 
#' \code{alley.accumulation}  
#' 
#' \code{alley.temperature}  
#' 
#' 
#' \code{sicre.2011.MD99_2275.age.model} 
#'  
#' \code{sicre.2011.MD99_2275.metadata} 
#'  
#' \code{sicre.2011.MD99_2275.temperature}  
#' 
#' 
#' \code{naafs.U1313.temperature}  
#' 
#' \code{naafs.U1313.metadata}  
#'
#' \code{herbert.ODP846.temperature}  
#' 
#' \code{herbert.ODP846.metadata}  
#' 
#' @section Citing the data:
#' 
#' For the compilations, please cite both the compilaton papers (Marcott et al 2013, Shakun et al
#' 2012), and the original sources from which the data were extracted. A full
#' list of sources can be found in the metadata dataframes, e.g. \code{marcott.metadata}.
#' 
#' For the other records please cite the original papers. See the help files e.g.
#' \code{help(sicre.2011.MD99_2275.temperature)} for the correct citations.
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
#' @format A tbl (data.frame) with 13 columns and 13134 rows containing the
#'   following variables:
#' \tabular{lll}{
#' \bold{Variable.name} \tab \bold{Units} \tab \bold{Description} \cr
#' Number                \tab       \tab Integer used to ID unique proxy records in Marcott et al (2013)\cr
#' ID                    \tab       \tab Combination of Core.location and Core.type, to uniquely identify a proxy\cr
#' Core.location         \tab       \tab Core ID code or location name from which proxy was obtained. Corresponds to the Excel sheet name in the supplied data file from Marcott et al (2013)     \cr
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
#'@format A tbl (data.frame) with 14 columns and 16879 rows containing the 
#'  following variables: \tabular{lll}{ \bold{Variable.name} \tab \bold{Units}  \tab \bold{Description} 
#'  \cr Core                  \tab NA    \tab Core ID                                            
#'  \cr Number                \tab NA    \tab ID number assigned in publication                                           
#'  \cr ID                    \tab NA    \tab A unique ID formed by combining Core and Proxy.type
#'  \cr Proxy.type            \tab NA    \tab Proxy type                                         
#'  \cr Proxy.value           \tab NA    \tab Proxy value                           
#'  \cr Published.temperature \tab deg C \tab NA                                
#'  \cr Temperature           \tab deg C \tab NA        
#'  \cr Age                   \tab yr BP \tab Best available age in yr BP, Present = 1950 AD, Marine04.age when present, otherwise Published.age   
#'  \cr Published.age         \tab yr BP \tab Age in yr BP, Present = 1950 AD   
#'  \cr Age.model.error       \tab yr    \tab Estimated error in age model, in years per 1 SD    
#'  \cr Marine04.age          \tab yr BP \tab Age in yr BP, Present = 1950 AD 
#'  \cr Marine09.age          \tab yr BP \tab Age in yr BP, Present = 1950 AD       
#'  \cr Proxy.depth.m         \tab m     \tab Proxy depth   
#'  \cr Proxy.depth.cm        \tab cm    \tab Proxy depth 
#'  }
#'  
#'@usage data(shakun.proxies)
#'  
#'@source
#'  \url{http://www.nature.com/nature/journal/v484/n7392/full/nature10915.html}
"shakun.proxies"


#'Alkenone based temperature reconstruction from core ODP846 (-3.095, -90.817) by Herbert et al (2010)
#'@description 
#'  
#'  
#'  
#'@section Reference: 
#' Herbert, T.D., L.C. Peterson, K.T. Lawrence, and Z. Liu. 2010. 
#' Tropical Ocean Temperatures over the Past 3.5 Myr.
#' Science, Vol. 328, no. 5985, pp. 1530-1534, 18 June 2010. 
#' DOI: 10.1126/science.1185435 
#'  
#'@section Corrections: None so far required
#'  
#'@format A tbl (data.frame) with 3 columns and 2250 rows containing the 
#'  following variables: \tabular{lll}{ \bold{Variable.name} \tab \bold{Units}  \tab \bold{Description} 
#'  \cr Depth                  \tab m    \tab Depth in metres (RMCD)                                       
#'  \cr Age                   \tab kyr BP \tab Age in kyr BP, Present = 1950 AD
#'  \cr Temperature           \tab deg C \tab Uk'37 SST, °C
#'  }
#'  
#'@usage data(herbert.ODP846.temperature)
#'  
#'@source
#'  \url{ftp://ftp.ncdc.noaa.gov/pub/data/paleo/contributions_by_author/herbert2010/herbert2010.txt}
"herbert.ODP846.temperature"


#'Alkenone based temperature reconstruction from core U1313 by Naafs et al (2012)
#'@description 
#'
#' @format A data frame with 2455 rows and 10 variables:
#' \describe{
#'   \item{\code{Core}}{}
#'   \item{\code{Number}}{}
#'   \item{\code{ID.no}}{}
#'   \item{\code{ID}}{}
#'   \item{\code{Proxy.type}}{}
#'   \item{\code{Published.temperature}}{}
#'   \item{\code{Age.kyrs.BP}}{}
#'   \item{\code{Age.yrs.BP}}{}
#'   \item{\code{Depth.m}}{}
#'   \item{\code{Sed.acc.rate.m.yr}}{} 
#'}
#'  
#'@section Reference: 
#' Naafs, Bernhard David A; Hefter, Jens; Acton, Gary D; Haug, Gerald H;
#' Martinez-Garcia, Alfredo; Pancost, Richard D; Stein, Ruediger (2012):
#' Concentrations and accumulation rates of biomarkers and SSTs at IODP Site
#' 306-U1313. PANGAEA, https://doi.org/10.1594/PANGAEA.757946, 
#' 
#' In supplement to:
#' Naafs, BDA et al. (2012): Strengthening of North American dust sources during
#' the late Pliocene (2.7 Ma). Earth and Planetary Science Letters, 317-318,
#' 8-19, https://doi.org/10.1016/j.epsl.2011.11.026
#'  
#'@section Corrections: None so far required
#'  
#'  
#'@usage data(naafs.U1313.temperature)
#'  
#'@source
#'  \url{https://doi.org/10.1594/PANGAEA.757946}
"naafs.U1313.temperature"

#' @title Uk'37 based climate proxy for core MD99-2275 published in Sicre et al. (2011)
#' @section Reference:
#'  Sicre, M.-A., Hall, I. R., Mignot, J., Khodri, M., Ezat, U., Truong, M.-X., Eiríksson, J., & Knudsen, K.-L. (2011): 
#' Sea surface temperature variability in the subpolar Atlantic over the last two millennia. Paleoceanography, 26: PA4218.
#' @format A data frame with 518 rows and 8 variables:
#' \describe{
#'   \item{\code{Core}}{}
#'   \item{\code{Number}}{}
#'   \item{\code{ID.no}}{}
#'   \item{\code{ID}}{}
#'   \item{\code{Proxy.type}}{}
#'   \item{\code{Published.temperature}}{}
#'   \item{\code{Age.yrs.AD}}{}
#'   \item{\code{Age.yrs.BP}}{} 
#'}
#' @details 
#' @examples 
#' @NA NULL
"sicre.2011.MD99_2275.temperature"

