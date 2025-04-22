use("tidyverse")
use("readxl")
use("conflicted")
use("ggplot2")
use("knitr")  # For creating tables
use("vegan")  # For ecological analyses
use("janitor") # For clean_names function

# Load the main data sheet
main_data <- read_excel("data/db_species_20250214.xlsx", sheet = "original_data")
main_data <- main_data %>% select(where(~ !all(is.na(.))))

# Clean column names - replace spaces and special characters with underscores
cat("Original column names:\n")
print(names(main_data))

# Clean the column names using the janitor package
main_data <- main_data %>% janitor::clean_names()

# Alternatively, if janitor package is not available, use this code instead:
# names(main_data) <- gsub(" ", "_", names(main_data))  # Replace spaces with underscores
# names(main_data) <- gsub("[^a-zA-Z0-9_]", "", names(main_data))  # Remove special characters
# names(main_data) <- make.names(names(main_data), unique = TRUE)  # Make syntactically valid names

cat("\nCleaned column names:\n")
print(names(main_data))

# Initial exploration
cat("\nDataset dimensions:", dim(main_data), "\n")
cat("Number of observations:", nrow(main_data), "\n")
cat("Number of variables:", ncol(main_data), "\n\n")

# Find the index of the EUNIS column
eunis_col_index <- which(grepl("eunis", names(main_data), ignore.case = TRUE))
if(length(eunis_col_index) == 0) {
  cat("Warning: Could not find 'EUNIS' column. Will parse all columns from second onwards.\n")
  eunis_col_index <- ncol(main_data) + 1  # Set to beyond the last column
} else {
  eunis_col_index <- min(eunis_col_index)  # Take the first match if multiple
  cat("Found EUNIS column at index:", eunis_col_index, "with name:", names(main_data)[eunis_col_index], "\n\n")
}

# Parse columns from second to EUNIS as numeric
cat("Converting columns from 2 to", max(2, eunis_col_index - 1), "to numeric values...\n")
for(i in 2:min(ncol(main_data), eunis_col_index - 1)) {
  col_name <- names(main_data)[i]
  # Store the original values to check for parsing issues
  original_values <- main_data[[i]]
  
  # Try to convert to numeric
  main_data[[i]] <- as.numeric(as.character(main_data[[i]]))
  
  # Check if we lost any non-NA values
  if(sum(!is.na(original_values)) > sum(!is.na(main_data[[i]]))) {
    warning_msg <- paste("Warning: Some values in column", col_name, "could not be parsed as numeric")
    cat(warning_msg, "\n")
    
    # Report the problematic values
    problematic <- original_values[!is.na(original_values) & is.na(main_data[[i]])]
    if(length(problematic) > 0) {
      cat("  Problematic values:", toString(head(unique(problematic), 5)), "\n")
    }
  }
  
  cat("Converted column", i, ":", col_name, "to numeric\n")
}
cat("Conversion complete\n\n")

