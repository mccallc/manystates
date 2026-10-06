#' contiguity database documentation
#'
#' @format The contiguity database is a list that contains the
#' following 1 datasets: HUGGO_CONT.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{HUGGO_CONT: }{A dataset with 609 observations and the following
#' 8 variables: stateID1, stateID2, Begin, End, StateName1, StateName2, ContiguityType, url.}
#' }

#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(contiguity, messydates::mreport)
#' ```
"contiguity"
