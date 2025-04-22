use("tidyverse")
use("readxl")
use("conflicted")
use("ggplot2")
use("janitor") # For clean_names function
use("dplyr")
# Load the main data sheet
main_data <- read_excel("data/db_species_20250214.xlsx", sheet = "original_data")
main_data <- main_data %>% select(where(~ !all(is.na(.))))

# Clean column names - replace spaces and special characters with underscores
cat("Original column names:\n")
print(names(main_data))

# Clean the column names using the janitor package
main_data <- main_data %>% janitor::clean_names()

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

# Save the processed main data
save(main_data, file = "data/processed_data_clean.RData")

# Load and process the land cover sheets
cat("\n==== Processing land cover sheets ====\n\n")

# Function to process land cover sheets
process_land_cover <- function(sheet_name) {
  cat("Processing sheet:", sheet_name, "\n")
  
  # Read the land cover sheet
  land_cover_data <- read_excel("data/db_species_20250214.xlsx", sheet = sheet_name)
  
  # Clean column names
  land_cover_data <- land_cover_data %>% janitor::clean_names()
  
  # Print original column names
  cat("Original column names (after cleaning):\n")
  print(names(land_cover_data))
  
  # Select only id_plot and columns with prefix 50m_ and 100m_
  id_col <- grep("^id_beach$", names(land_cover_data), value = TRUE)
  
  # If id_plot doesn't exist, try to find similar column names
  if(length(id_col) == 0) {
    id_col <- grep("id.*plot|plot.*id", names(land_cover_data), value = TRUE)[1]
    cat("Using", id_col, "as the ID column\n")
  }
  
  # Get columns with 50m_ and 100m_ prefixes
  cols_50m <- grep("^50m_", names(land_cover_data), value = TRUE)
  cols_100m <- grep("^100m_", names(land_cover_data), value = TRUE)
  
  # Select the columns
  selected_cols <- c(id_col, cols_50m, cols_100m)
  
  # Check if any columns were found
  if(length(selected_cols) <= 1) {
    cat("Warning: No columns with 50m_ or 100m_ prefix found. Check column names.\n")
    # Try finding similar patterns
    possible_50m <- grep("50.*m|50m|50 m", names(land_cover_data), value = TRUE)
    possible_100m <- grep("100.*m|100m|100 m", names(land_cover_data), value = TRUE)
    
    cat("Possible 50m columns:", toString(possible_50m), "\n")
    cat("Possible 100m columns:", toString(possible_100m), "\n")
    
    # If alternatives found, use them
    if(length(possible_50m) > 0 || length(possible_100m) > 0) {
      selected_cols <- c(id_col, possible_50m, possible_100m)
    }
  }
  
  # Filter the data to include only selected columns
  filtered_data <- land_cover_data %>% select(all_of(selected_cols)) %>% distinct()
  
  cat("Selected", ncol(filtered_data), "columns from", sheet_name, "\n")
  cat("Final column names:\n")
  print(names(filtered_data))
  
  return(filtered_data)
}

# Process each land cover sheet
girona_land_cover <- process_land_cover("girona_land cover")
barcelona_land_cover <- process_land_cover("barcelona_land cover")
tarragona_land_cover <- process_land_cover("tarragona_land cover")

girona_land_cover
# Save each processed land cover dataset
save(girona_land_cover, file = "data/girona_land_cover_clean.RData")
save(barcelona_land_cover, file = "data/barcelona_land_cover_clean.RData")
save(tarragona_land_cover, file = "data/tarragona_land_cover_clean.RData")

# Create a list containing all land cover datasets
land_cover_data <- list(
  "Girona" = girona_land_cover,
  "Barcelona" = barcelona_land_cover,
  "Tarragona" = tarragona_land_cover
)

# Save the combined land cover data as a list
save(land_cover_data, file = "data/all_land_cover_data.RData")

cat("\nLand cover data processing complete.\n")
cat("Individual datasets saved as:\n")
cat("- data/girona_land_cover_clean.RData\n")
cat("- data/barcelona_land_cover_clean.RData\n")
cat("- data/tarragona_land_cover_clean.RData\n")
cat("Combined datasets saved as a list in: data/all_land_cover_data.RData\n")
cat("Access the combined data using: land_cover_data$Girona, land_cover_data$Barcelona, etc.\n")
