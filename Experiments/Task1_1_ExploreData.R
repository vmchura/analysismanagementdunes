use("tidyverse")
use("readxl")
use("conflicted")
use("ggplot2")
use("janitor") # For clean_names function
use("dplyr")
# Load the main data sheet
main_data <- read_excel("../data/db_species_20250214.xlsx", sheet = "original_data")
main_data <- main_data %>% select(where(~ !all(is.na(.))))

# Clean column names - replace spaces and special characters with underscores


# Clean the column names using the janitor package
main_data <- main_data %>% janitor::clean_names()


# Find the index of the EUNIS column
eunis_col_index <- which(grepl("eunis", names(main_data), ignore.case = TRUE))
if(length(eunis_col_index) == 0) {
  cat("Warning: Could not find 'EUNIS' column. Will parse all columns from second onwards.\n")
  eunis_col_index <- ncol(main_data) + 1  # Set to beyond the last column
} else {
  eunis_col_index <- min(eunis_col_index)  # Take the first match if multiple
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
  
  
}

# Reorder columns in main_data before saving
# Identify all desired columns
species_cols <- setdiff(names(main_data),
                        c("plot", "id_beach", "beach", "id_transect", "id_plot", "transect", "eunis"))

# Create the desired column order
ordered_cols <- c("plot", "id_beach", "beach", "id_transect", "id_plot", "transect", "eunis", species_cols)
# Reorder columns (only those that exist)
main_data <- main_data %>% select(all_of(ordered_cols), everything())

cat("\nColumn order after reordering:\n")
print(head(names(main_data), 10))  # Print first 10 column names to verify order

# Save the processed main data with ordered columns
save(main_data, file = "../data/processed_data_clean.RData")

# Load and process the land cover sheets
cat("\n==== Processing land cover sheets ====\n\n")

# Simple function to process land cover sheets with direct transformation of values
process_land_cover <- function(sheet_name) {
  cat("Processing sheet:", sheet_name, "\n")
  
  # Read the sheet - we'll read as numeric to get the raw Excel date values
  land_cover_data <- read_excel("../data/db_species_20250214.xlsx", sheet = sheet_name)
  
  # Clean column names
  land_cover_data <- land_cover_data %>% janitor::clean_names()
  
  
  # Select id_beach/id_plot column
  id_col <- grep("^id_beach$|^id_plot$", names(land_cover_data), value = TRUE)[1]
  if(is.na(id_col)) {
    id_col <- grep("id.*beach|beach.*id|id.*plot|plot.*id", names(land_cover_data), value = TRUE)[1]
  }
  
  # Get 50m and 100m columns
  cols_50m <- grep("^(x)?50m_", names(land_cover_data), value = TRUE)
  cols_100m <- grep("^(x)?100m_", names(land_cover_data), value = TRUE)
  
  if(length(cols_50m) == 0) {
    cols_50m <- grep("50.*m|50m|50 m", names(land_cover_data), value = TRUE)
  }
  
  if(length(cols_100m) == 0) {
    cols_100m <- grep("100.*m|100m|100 m", names(land_cover_data), value = TRUE)
  }
  
  # Select columns
  distance_cols <- c(cols_50m, cols_100m)
  selected_cols <- c(id_col, distance_cols)
  
  # Filter data
  filtered_data <- land_cover_data %>% select(all_of(selected_cols)) %>% distinct()
  
  
  # DIRECT TRANSFORMATION APPROACH
  # For each 50m and 100m column, apply a direct transformation if needed
  for(col in distance_cols) {
    # If already numeric, check if it looks like an Excel date (values > 40000)
    filtered_data[[col]] <- as.numeric(filtered_data[[col]])
  }
  
  # Convert ID column to integer
  filtered_data[[id_col]] <- as.integer(filtered_data[[id_col]])
  
  return(filtered_data)
}

# Process each land cover sheet
girona_land_cover <- process_land_cover("girona_land cover")
barcelona_land_cover <- process_land_cover("barcelona_land cover")
tarragona_land_cover <- process_land_cover("tarragona_land cover")

# Create a list containing all land cover datasets
land_cover_data <- list(
  "Girona" = girona_land_cover,
  "Barcelona" = barcelona_land_cover,
  "Tarragona" = tarragona_land_cover
)

# Save the combined land cover data as a list
save(land_cover_data, file = "../data/all_land_cover_data.RData")

cat("\nLand cover data processing complete.\n")
cat("Combined datasets saved as a list in: data/all_land_cover_data.RData\n")
cat("Access the combined data using: land_cover_data$Girona, land_cover_data$Barcelona, etc.\n")

# Load and process the management sheets
cat("\n==== Processing management sheets ====\n\n")

# Function to process management sheets
process_management <- function(sheet_name) {
  cat("Processing sheet:", sheet_name, "\n")
  
  # Read the sheet
  management_data <- read_excel("../data/db_species_20250214.xlsx", sheet = sheet_name)
  
  # Clean column names
  management_data <- management_data %>% janitor::clean_names()
  
  
  # Standardize key column names based on what is expected
  expected_cols <- c(
    "id_plot", "id_beach", "beach", 
    "managed_paths", "rope_fences", "mechanical_cleaning",
    "surface_area_occupied_by_seasonal_services_and_amenities_on_or_less_than_5_m_from_the_dunes",
    "surface_area_of_parking_or_other_fixed_services_on_or_less_than_5_m_from_the_dunes",
    "protection_of_the_system_and_the_immediate_environment",
    "degree_of_protection_according_to_the_iucn_classification"
  )
  
  # Try to find each expected column
  actual_cols <- vector("character", length(expected_cols))
  for (i in seq_along(expected_cols)) {
    pattern <- expected_cols[i]
    # Create a simplified regex pattern
    simple_pattern <- gsub("_", ".*", pattern)
    matches <- grep(simple_pattern, names(management_data), ignore.case = TRUE, value = TRUE)
    
    if (length(matches) > 0) {
      actual_cols[i] <- matches[1]
    } else {
      cat("Warning: Could not find a column matching '", expected_cols[i], "'\n", sep = "")
      actual_cols[i] <- NA
    }
  }
  
  # Remove NA values
  actual_cols <- actual_cols[!is.na(actual_cols)]
  
  # Create a new data frame with standardized column names
  if (length(actual_cols) > 0) {
    # Subset the original data
    filtered_data <- management_data %>% select(all_of(actual_cols))
    
    # Detect ID columns
    id_plot_col <- grep("id.*plot|plot.*id", names(filtered_data), ignore.case = TRUE, value = TRUE)[1]
    id_beach_col <- grep("id.*beach|beach.*id", names(filtered_data), ignore.case = TRUE, value = TRUE)[1]
    
    # Ensure ID columns are integers
    if (!is.na(id_plot_col)) {
      filtered_data[[id_plot_col]] <- as.integer(filtered_data[[id_plot_col]])
    }
    
    if (!is.na(id_beach_col)) {
      filtered_data[[id_beach_col]] <- as.integer(filtered_data[[id_beach_col]])
    }
    
    # Check each column's class and sample values
    
    for (col in names(filtered_data)) {
    
      
      # Convert appropriate columns to factors if they have categorical values
      if (is.character(filtered_data[[col]]) && 
          !grepl("^id|^beach$", col, ignore.case = TRUE)) {
        unique_vals <- unique(na.omit(filtered_data[[col]]))
        if (length(unique_vals) < 10) {  # Assume categorical if fewer than 10 unique values
          filtered_data[[col]] <- factor(filtered_data[[col]])
          cat("  Converted to factor with levels:",
              toString(levels(filtered_data[[col]])), "\n")
        } else {
          cat("  Sample values:", toString(head(filtered_data[[col]])), "\n")
        }
      } else {
       
      }
    }
    
    return(filtered_data)
  } else {
    warning("No usable columns found in the management sheet")
    return(NULL)
  }
}

# Process each management sheet
girona_management <- process_management("girona_management")
barcelona_management <- process_management("barcelona_management")
tarragona_management <- process_management("tarragona_management")

# Create a list containing all management datasets
management_data <- list(
  "Girona" = girona_management,
  "Barcelona" = barcelona_management,
  "Tarragona" = tarragona_management
)

# Save the combined management data as a list
save(management_data, file = "../data/all_management_data.RData")

cat("\nManagement data processing complete.\n")
cat("Combined datasets saved as a list in: data/all_management_data.RData\n")
cat("Access the combined data using: management_data$Girona, management_data$Barcelona, etc.\n")


