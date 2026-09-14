unga_name <- "IdealpointestimatesAll_Jun2024.csv"
unga_path <- file.path("data-raw", "regimes", "UNGA", unga_name)

if (!file.exists(unga_path)) {
  cat("Downloading Ideal point estimate data...\n")
  unga <- dataverse::get_file_by_name(filename = unga_name,
      dataset = "10.7910/DVN/LEJUQZ", server = "dataverse.harvard.edu")
  writeBin(unga, unga_path)
  rm(unga)
}
