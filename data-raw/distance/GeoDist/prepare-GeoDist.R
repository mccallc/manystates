# GeoDist Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for many packages universe.

# Stage one: Collecting data
tmp_dir <- tempdir()
unzip(file.path("data-raw", "distance", "GeoDist", "dist_cepii.zip"),
    exdir = tmp_dir)
GeoDist <- readxl::read_excel(file.path(tmp_dir, "dist_cepii.xls"))

# In this stage you will want to correct the variable names and
# formats of the 'HUGGO_CONT' object until the object created
# below (in stage three) passes all the tests.
# We recommend that you avoid using one letter variable names to keep
# away from issues with ambiguous names down the road.

GeoDist <- tibble::as_tibble(GeoDist) |>
  manydata::transmutate(stateID1 = countrycode::countrycode(ccode1, "cown", "cowc"),
                        stateID2 = countrycode::countrycode(ccode2, "cown", "cowc"),
                        Year = messydates::as_messydate(year)) |>
  dplyr::filter(!is.na(stateID1) & !is.na(stateID2)) |>
  dplyr::mutate(stateID1 = manystates::code_states(stateID1),
                stateID2 = manystates::code_states(stateID2)) |>
  dplyr::arrange(stateID1, stateID2, Year, mindist)

# make sure all vars are correctly coded as NA if necessary
GeoDist <- GeoDist |> dplyr::distinct(.keep_all = TRUE)

# manypkgs includes several functions that should help cleaning
# and standardising your data such as `standardise_titles()`
# and `standardise_texts()`.
# Please see the vignettes or website for more details.

# Stage three: Connecting data
# Next run the following line to make GeoDist available
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
# please run `manypkgs::add_bib("distance", "GeoDist")`.
manypkgs::export_data(GeoDist, database = "distance",
                      URL = "https://www.cepii.fr/CEPII/en/publications/wp/abstract.asp?NoDoc=3877")
