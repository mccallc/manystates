
# COW_MINDIST Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for many packages universe.

# Stage one: Collecting data
load("data-raw/distance/COW_MINDIST/cow_mindist.rda")

# In this stage you will want to correct the variable names and
# formats of the 'HUGGO_CONT' object until the object created
# below (in stage three) passes all the tests.
# We recommend that you avoid using one letter variable names to keep
# away from issues with ambiguous names down the road.

# Reduce the raw data first: code_states() is expensive, so do not run it on
# every directed dyad-year observation.
COW_MINDIST <- tibble::as_tibble(cow_mindist) |>
  # Sorting the raw COW codes makes the two directions of each dyad identical.
  dplyr::transmute(ccode1 = pmin(ccode1, ccode2),
                   ccode2 = pmax(ccode1, ccode2),
                   year = as.integer(year),
                   mindist) |>
  dplyr::group_by(ccode1, ccode2, year) |>
  dplyr::mutate(inconsistent = dplyr::n_distinct(mindist, na.rm = FALSE) > 1) |>
  dplyr::ungroup()

# A pair-year is unusable when its two directions disagree on mindist.
inconsistent_pair_years <- COW_MINDIST |>
  dplyr::filter(inconsistent) |>
  dplyr::distinct(ccode1, ccode2, year)

if (nrow(inconsistent_pair_years) > 0) {
  warning(
    "Removed ", nrow(inconsistent_pair_years),
    " pair-year observations with conflicting mindist values: ",
    paste(utils::capture.output(print(inconsistent_pair_years)), collapse = " ")
  )
}

COW_MINDIST <- COW_MINDIST |>
  dplyr::filter(!inconsistent) |>
  dplyr::distinct(ccode1, ccode2, year, mindist) |>
  dplyr::arrange(ccode1, ccode2, year) |>
  dplyr::group_by(ccode1, ccode2) |>
  # Start a new run when years are non-consecutive or mindist changes.
  dplyr::mutate(run = cumsum(
    year != dplyr::lag(year, default = dplyr::first(year) - 1) + 1 |
      dplyr::coalesce(
        mindist != dplyr::lag(mindist, default = dplyr::first(mindist)),
        xor(is.na(mindist), is.na(dplyr::lag(mindist, default = dplyr::first(mindist)))),
        FALSE
      )
  )) |>
  dplyr::group_by(ccode1, ccode2, run, mindist) |>
  dplyr::summarise(Begin = min(year), End = max(year), .groups = "drop") |>
  dplyr::select(ccode1, ccode2, Begin, End, mindist)

# Translate only the distinct COW endpoints that remain after consolidation.
state_lookup <- tibble::tibble(
  ccode = sort(unique(c(COW_MINDIST$ccode1, COW_MINDIST$ccode2)))
) |>
  dplyr::mutate(cowc = countrycode::countrycode(ccode, "cown", "country.name"),
                stateID = manystates::code_states(cowc))

COW_MINDIST <- COW_MINDIST |>
  # Re-canonicalize after translation because standardized IDs may sort
  # differently from the original numeric COW codes.
  dplyr::left_join(state_lookup, by = c("ccode1" = "ccode")) |>
  dplyr::rename(stateID1 = stateID) |>
  dplyr::left_join(state_lookup, by = c("ccode2" = "ccode")) |>
  dplyr::rename(stateID2 = stateID) |>
  dplyr::filter(!is.na(stateID1) & !is.na(stateID2)) |>
  dplyr::mutate(pair1 = pmin(stateID1, stateID2),
                pair2 = pmax(stateID1, stateID2)) |>
  dplyr::select(stateID1 = pair1, stateID2 = pair2, Begin, End, mindist)

# make sure all vars are correctly coded as NA if necessary
COW_MINDIST <- COW_MINDIST |> 
  dplyr::mutate(Begin = messydates::as_messydate(Begin),
    End = messydates::as_messydate(End)) |>
  dplyr::distinct(.keep_all = TRUE)

# manypkgs includes several functions that should help cleaning
# and standardising your data such as `standardise_titles()`
# and `standardise_texts()`.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make COW_MINDIST available
# within the package.
# This function also does two additional things.
# First, it creates a set of tests for this object to ensure adherence
# to certain standards.You can hit Cmd-Shift-T (Mac) or Ctrl-Shift-T (Windows)
# to run these tests locally at any point.
# Any test failures should be pretty self-explanatory and may require
# you to return to stage two and further clean, standardise, or wrangle
# your data into the expected format.
# Second, it also creates a documentation file for you to fill in.
# Please note that the export_data() function requires a .bib file to be
# present in the data_raw folder of the package for citation purposes.
# Therefore, please make sure that you have permission to use the dataset
# that you're including in the package.
# To add a template of .bib file to the package,
# please run `manypkgs::add_bib("distance", "COW_MINDIST")`.
manypkgs::export_data(COW_MINDIST, database = "distance",
                      URL = "https://svmiller.com/peacesciencer/index.html")
