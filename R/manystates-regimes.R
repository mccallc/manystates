#' regimes database documentation
#'
#' @format The regimes database is a list that contains the
#' following 1 datasets: UNGA.
#' For more information and references to each of the datasets used,
#' please use the `data_source()` and `data_contrast()` functions.
#'\describe{
#' \item{UNGA: }{A dataset with 11238 observations and the following
#' 5 variables: ID, stateID, Year, StateName, IdealPointAll.}
#' }

#'
#' @details
#' ``` {r, echo = FALSE, warning = FALSE}
#' lapply(regimes, messydates::mreport)
#' ```
"regimes"
