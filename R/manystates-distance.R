#' distance database documentation
#'
#' @format The distance database is a list that contains the
#' following 1 datasets: COW_MINDIST.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{COW_MINDIST: }{A dataset with 26512 observations and the following
#' 5 variables: stateID1, stateID2, Begin, End, mindist.}
#' }

#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(distance, messydates::mreport)
#' ```
"distance"
