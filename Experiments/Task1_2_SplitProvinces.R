# Task 1.2: Split dataset by provinces
# This script divides the dataset by the three biogeographical zones 
# (Girona, Barcelona, Tarragona) for separate analysis

# Load necessary libraries
library(tidyverse)
library(readxl)
library(writexl)
library(here)

# Set conflicts resolution preference
conflicted::conflict_prefer("filter", "dplyr")
conflicted::conflict_prefer("select", "dplyr")

# Load the dataset
data_path <- "data/db_species_20250214.xlsx"
main_data <- read_excel(data_path, sheet = "original_data")

# Clean dataset - remove completely empty columns
data_clean <- main_data %>% select(where(~ !all(is.na(.))))

# Check if we have a direct province column
if("province" %in% colnames(data_clean)) {
  province_column <- "province"
  cat("Using existing province column\n")
} else {
  # Try to find province information in other columns
  # This will need to be adjusted based on actual column names in your dataset
  possible_columns <- c(
    "location", "region", "zona", "beach", "playa", "platja", 
    "site", "sector", "municipality", "municipio", "municipi"
  )
  
  # Check which columns exist
  existing_columns <- possible_columns[possible_columns %in% colnames(data_clean)]
  
  if(length(existing_columns) > 0) {
    cat("Province column not found. Checking these columns for province information:", 
        paste(existing_columns, collapse=", "), "\n")
    
    # Look at the values in these columns
    for(col in existing_columns) {
      cat("\nValues in", col, "column:\n")
      print(table(data_clean[[col]]))
    }
    
    # Ask for manual input
    cat("\nPlease specify which column contains province information by uncommenting and editing the line below\n")
    # province_column <- "COLUMN_NAME_HERE"
    
    # As a fallback, create a placeholder column based on the beach location if known
    # This is just a template and will need to be adjusted based on actual data
    cat("Creating a placeholder province column based on known beach locations\n")
    
    # Example logic - would need to be adapted to your actual data
    data_clean <- data_clean %>% 
      mutate(province_inferred = case_when(
        # Replace with actual beach names or municipality patterns for your data
        grepl("Girona|Lloret|Blanes|Tossa|Roses|Palamós|Pals", beach_name_column) ~ "Girona",
        grepl("Barcelona|Badalona|Sitges|Mataró|Castelldefels", beach_name_column) ~ "Barcelona",
        grepl("Tarragona|Salou|Cambrils|Tortosa|Amposta", beach_name_column) ~ "Tarragona",
        TRUE ~ NA_character_
      ))
    
    province_column <- "province_inferred"
    
    # Check how many records were assigned
    cat("Records with inferred province information:", sum(!is.na(data_clean$province_inferred)), 
        "out of", nrow(data_clean), "\n")
    
    # Display assignment distribution
    print(table(data_clean$province_inferred, useNA = "ifany"))
  } else {
    stop("Could not find any columns likely containing province information. Please check your data.")
  }
}

# Split the data by province
girona_data <- data_clean %>% filter(.data[[province_column]] == "Girona")
barcelona_data <- data_clean %>% filter(.data[[province_column]] == "Barcelona")
tarragona_data <- data_clean %>% filter(.data[[province_column]] == "Tarragona")

# Print summary of the splits
cat("\nDataset split by provinces:\n")
cat("Girona:", nrow(girona_data), "records\n")
cat("Barcelona:", nrow(barcelona_data), "records\n")
cat("Tarragona:", nrow(tarragona_data), "records\n")

# Check if any records didn't get assigned
total_assigned <- nrow(girona_data) + nrow(barcelona_data) + nrow(tarragona_data)
if(total_assigned < nrow(data_clean)) {
  cat("\nWarning:", nrow(data_clean) - total_assigned, 
      "records could not be assigned to a province.\n")
  
  unassigned <- data_clean %>% 
    filter(is.na(.data[[province_column]]) | 
             !(.data[[province_column]] %in% c("Girona", "Barcelona", "Tarragona")))
  
  cat("Values in unassigned records:\n")
  print(table(unassigned[[province_column]], useNA = "ifany"))
}

# Save the split datasets
# Create a directory for processed data if it doesn't exist
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

# Export as Excel
write_xlsx(list(
  Girona = girona_data,
  Barcelona = barcelona_data,
  Tarragona = tarragona_data
), path = "data/processed/split_by_province.xlsx")

# Also save as separate RDS files for easier R loading
saveRDS(girona_data, "data/processed/girona_data.rds")
saveRDS(barcelona_data, "data/processed/barcelona_data.rds")
saveRDS(tarragona_data, "data/processed/tarragona_data.rds")

cat("\nSplit datasets saved to data/processed/\n")
cat("- Combined Excel file: data/processed/split_by_province.xlsx\n")
cat("- Individual RDS files for each province\n")

# Print a message about next steps
cat("\nNext steps:\n")
cat("1. Check province assignments to ensure they are correct\n")
cat("2. Make any necessary adjustments to the province identification logic\n")
cat("3. Proceed to exploratory visualization of species distribution by province\n")
