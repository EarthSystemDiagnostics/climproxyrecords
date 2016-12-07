## Document package and /data

#' marcott2013: A package containing the climate proxy data from Marcott et al
#' (2013).
#'
#' The marcott2013 package contains three dataframes: \code{proxies},
#' \code{dating}, and \code{metadata.} These contain the proxy data, associated carbon dating
#' information, and metadata respectively.
#'
#' Please cite both Marcott et al (2013), and the original sources from which
#' the data were extracted. A full list of sources can be found in the
#' dataframe \code{metadata}
#'
#' @docType package
#' @name marcott2013
NULL

#' Climate proxy data from Marcott et al (2013)
#' @description The climate proxy data supplied as supplementary online material
#'   with the publication, Marcott et al (2013), was read into R from the .xlsx
#'   file and reformatted into a handy format for use in R.
#'
#'   Please cite both Marcott et al (2013), and the original sources from which
#'   the data were extracted. A full list of sources can be found in the dataframe
#'   \code{metadata}
#'
#' @section Reference: Marcott, Shaun A., Jeremy D. Shakun, Peter U. Clark, and
#'   Alan C. Mix. 2013. “A Reconstruction of Regional and Global Temperature for
#'   the Past 11,300 Years.” Science 339 (6124): 1198–1201.
#'   doi:10.1126/science.1228026.
#'
#' @section Corrections: Proxy "GeoB 6518-1 (MBT)" was excluded as it seems to
#'   have duplicated temperature data and no raw proxy data.

#' @format A tbl (data.frame) with 10 columns and 10885 rows containing the
#'   following variables:
#' \tabular{lll}{
#' \bold{Variable.name} \tab \bold{Units} \tab \bold{Description} \cr
#' Core.location         \tab              \tab Core ID code or location name from which proxy was obtained\cr
#' Published.age         \tab yr BP        \tab Published age, present = 1950 AD                           \cr
#' Published.temperature \tab deg C        \tab Published temperature                                      \cr
#' Age.model.error       \tab yr (1 sigma) \tab Age model error                                            \cr
#' Proxy.type            \tab              \tab Proxy type                                                 \cr
#' Proxy.value           \tab              \tab Proxy value                                                \cr
#' Proxy.depth.type      \tab              \tab Proxy depth type                                           \cr
#' Proxy.depth           \tab cm           \tab Proxy depth                                                \cr
#' Age.type              \tab              \tab Age type                                                   \cr
#' Age                   \tab yr BP        \tab Age, present = 1950 AD
#'}
#'
#' @usage data(proxies)
#'
#' @source \url{http://www.sciencemag.org/content/339/6124/1198}
"proxies"

