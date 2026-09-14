# UNGA ideal point distance Preparation Script

# This is a template for importing, cleaning, and exporting data
# ready for the many packages universe.

# Stage one: Collecting data

# Polity case data
UNGA <- read.csv(file.path("data-raw", "regimes", "UNGA", "IdealpointestimatesAll_Jun2024.csv"))

# Stage two: Correcting data
# In this stage you will want to correct the variable names and
# formats of the 'Polity5' object until the object created
# below (in stage three) passes all the tests.
UNGA <- tibble::as_tibble(UNGA) %>%
  dplyr::rename(cowNR = ccode, StateName = Countryname) %>%
  # dplyr::mutate(StateName = countrycode::countrycode(cowID, "cown", "country.name")) %>%
  dplyr::mutate(cowID = countrycode::countrycode(cowNR, "cown", "cowc"), 
    stateID = manystates::code_states(StateName),
    Year = messydates::as_messydate(session + 1945)) %>%
  dplyr::mutate(ID = paste0(cowID, "-", Year), 
    cowNR = manypkgs::standardize_titles(as.character(cowID))) %>%
  dplyr::arrange(stateID, Year) %>%
  dplyr::select("ID", "stateID", "StateName", "Year", "IdealPointAll") %>%
  dplyr::relocate(ID, stateID, Year, StateName)

# Stage three: Connecting data
# Next run the following line to make UNGA ideal point distance available
# within the many package.
manypkgs::export_data(UNGA, database = "regimes", 
                     URL = "http://doi.org/10.7910/DVN/LEJUQZ")

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
