#Load Packages
library (pacman)
pacman::p_load(here,readxl,tidyverse,modelsummary,dplyr,fixest)
# LOAD PACKAGES -----------------------------------------------------------

library(pacman)

pacman::p_load(
  here, readxl, tidyverse, modelsummary,
  dplyr, fixest, stringr, purrr
)


# SELECT THE EOCEP FOLDER -------------------------------------------------

# Select one Excel file inside the folder containing your five EOCEP files.
file <- file.choose()

# Use the selected file's folder to locate the other files.
folder.path <- dirname(file)


# FIND EXCEL FILES --------------------------------------------------------

lf <- list.files(
  folder.path,
  pattern = "\\.xlsx?$",
  full.names = TRUE,
  ignore.case = TRUE
)

# Exclude temporary Excel files.
lf <- lf[!startsWith(basename(lf), "~$")]

# Check which files will be imported.
print(basename(lf))

# Stop if no Excel files were found.
stopifnot(length(lf) > 0)


# COMBINE FILES -----------------------------------------------------------

# Read each file and stack its rows into one dataframe.
df <- purrr::map_dfr(lf, function(f) {
  readxl::read_excel(f) |>
    dplyr::mutate(
      source_file = basename(f),
      
      # Extract the first four-digit year from the filename.
      # We still need to check that this is the school year's ENDING year.
      year = as.integer(
        stringr::str_extract(basename(f), "\\d{4}")
      )
    )
})


# INSPECT THE DATA --------------------------------------------------------

dplyr::count(df, source_file, year)
names(df)
head(df)
View(df)