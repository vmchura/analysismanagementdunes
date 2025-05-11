# Task1_1_validation.R
# Validation script for checking the integrity and format of processed data files

# Load necessary libraries
library(tidyverse)

# Set conflicts resolution preference
conflicted::conflict_prefer("filter", "dplyr")
conflicted::conflict_prefer("select", "dplyr")

# =================================================================
# Validation function for main_data
# =================================================================

validate_main_data <- function(data) {
  cat("===== Validating main_data =====\n\n")
  
  # Check dimensions
  expected_rows <- 278
  expected_cols <- 147 + 7  # Species columns + identifier columns
  
  cat("Dimensions check:\n")
  cat("  Expected: ", expected_cols, " columns by ", expected_rows, " rows\n", sep = "")
  cat("  Actual:   ", ncol(data), " columns by ", nrow(data), " rows\n", sep = "")
  
  if (nrow(data) != expected_rows) {
    cat("  WARNING: Row count does not match expected value!\n")
  }
  
  if (ncol(data) < expected_cols - 5 || ncol(data) > expected_cols + 5) {
    cat("  WARNING: Column count is significantly different from expected value!\n")
  }
  
  # Check column existence and order
  expected_first_cols <- c("plot", "id_beach", "beach", "id_transect", "id_plot", "transect", "eunis")
  
  cat("\nColumn presence check:\n")
  for (col in expected_first_cols) {
    if (col %in% names(data)) {
      cat("  Column '", col, "' is present at position ", which(names(data) == col), "\n", sep = "")
    } else {
      cat("  WARNING: Column '", col, "' is missing!\n", sep = "")
    }
  }
  
  # Validate column formats
  cat("\nColumn format validation:\n")
  
  # Check plot format (D+_D+_D+)
  if ("plot" %in% names(data)) {
    plot_format_check <- all(grepl("^\\d+_\\d+_\\d+$", data$plot))
    cat("  'plot' format (D+_D+_D+): ", ifelse(plot_format_check, "VALID", "INVALID"), "\n", sep = "")
    if (!plot_format_check) {
      invalid_plots <- data$plot[!grepl("^\\d+_\\d+_\\d+$", data$plot)]
      cat("    Invalid examples: ", toString(head(invalid_plots, 5)), "\n", sep = "")
    }
  }
  
  # Check id_beach format (D+)
  if ("id_beach" %in% names(data)) {
    id_beach_format_check <- all(grepl("^\\d+$", as.character(data$id_beach)))
    cat("  'id_beach' format (D+): ", ifelse(id_beach_format_check, "VALID", "INVALID"), "\n", sep = "")
    if (!id_beach_format_check) {
      invalid_id_beach <- data$id_beach[!grepl("^\\d+$", as.character(data$id_beach))]
      cat("    Invalid examples: ", toString(head(invalid_id_beach, 5)), "\n", sep = "")
    }
  }
  
  # Check id_transect format (D+)
  if ("id_transect" %in% names(data)) {
    id_transect_format_check <- all(grepl("^\\d+$", as.character(data$id_transect)))
    cat("  'id_transect' format (D+): ", ifelse(id_transect_format_check, "VALID", "INVALID"), "\n", sep = "")
    if (!id_transect_format_check) {
      invalid_id_transect <- data$id_transect[!grepl("^\\d+$", as.character(data$id_transect))]
      cat("    Invalid examples: ", toString(head(invalid_id_transect, 5)), "\n", sep = "")
    }
  }
  
  # Check id_plot format (D+)
  if ("id_plot" %in% names(data)) {
    id_plot_format_check <- all(grepl("^\\d+$", as.character(data$id_plot)))
    cat("  'id_plot' format (D+): ", ifelse(id_plot_format_check, "VALID", "INVALID"), "\n", sep = "")
    if (!id_plot_format_check) {
      invalid_id_plot <- data$id_plot[!grepl("^\\d+$", as.character(data$id_plot))]
      cat("    Invalid examples: ", toString(head(invalid_id_plot, 5)), "\n", sep = "")
    }
  }
  
  # Check transect format (D+_D+)
  if ("transect" %in% names(data)) {
    transect_format_check <- all(grepl("^\\d+_\\d+$", as.character(data$transect)))
    cat("  'transect' format (D+_D+): ", ifelse(transect_format_check, "VALID", "INVALID"), "\n", sep = "")
    if (!transect_format_check) {
      invalid_transect <- data$transect[!grepl("^\\d+_\\d+$", as.character(data$transect))]
      cat("    Invalid examples: ", toString(head(invalid_transect, 5)), "\n", sep = "")
    }
  }
  
  # Validate that plot is the concatenation of id_beach, id_transect, and id_plot
  if (all(c("plot", "id_beach", "id_transect", "id_plot") %in% names(data))) {
    cat("\nValidating plot concatenation:\n")
    # Build expected plot values
    expected_plot <- paste(data$id_beach, data$id_transect, data$id_plot, sep = "_")
    plot_match <- all(data$plot == expected_plot)
    
    cat("  'plot' matches concatenation of id_beach_id_transect_id_plot: ", 
        ifelse(plot_match, "VALID", "INVALID"), "\n", sep = "")
    
    if (!plot_match) {
      # Find mismatches and display examples
      mismatches <- which(data$plot != expected_plot)
      if (length(mismatches) > 0) {
        cat("    Mismatches (first 5):\n")
        for (i in head(mismatches, 5)) {
          cat("      Row ", i, ": plot='", data$plot[i], 
              "', expected='", expected_plot[i], "'\n", sep = "")
        }
      }
    }
  } else {
    cat("\nCannot validate plot concatenation - one or more required columns missing\n")
  }
  
  # Validate all species columns (from column 8 to the end) have values between 0 and 5
  cat("\nValidating species abundance values (0-5):\n")
  
  # Find the index of the first species column
  first_species_idx <- max(which(names(data) %in% expected_first_cols)) + 1
  
  if (first_species_idx <= ncol(data)) {
    species_cols <- names(data)[first_species_idx:ncol(data)]
    cat("  Checking", length(species_cols), "species columns\n")
    
    # Function to check if column has valid values (0-5 or NA)
    check_species_col <- function(col_name) {
      values <- data[[col_name]]
      valid_values <- is.na(values) | (values >= 0 & values <= 5 & values == floor(values))
      return(all(valid_values))
    }
    
    # Apply check to all species columns
    species_check_results <- sapply(species_cols, check_species_col)
    
    # Report results
    valid_cols <- sum(species_check_results)
    invalid_cols <- sum(!species_check_results)
    
    cat("  Valid columns (integers 0-5 or NA):", valid_cols, "\n")
    cat("  Invalid columns:", invalid_cols, "\n")
    
    if (invalid_cols > 0) {
      cat("  Invalid column names: ", 
          toString(head(names(species_check_results)[!species_check_results], 5)), "\n", sep = "")
      
      # Show examples of invalid values for the first few invalid columns
      for (col in head(names(species_check_results)[!species_check_results], 3)) {
        values <- data[[col]]
        invalid_values <- values[!(is.na(values) | (values >= 0 & values <= 5 & values == floor(values)))]
        cat("    Column '", col, "' invalid values: ", toString(head(invalid_values, 5)), "\n", sep = "")
      }
    }
  } else {
    cat("  WARNING: Could not find species columns after identifier columns!\n")
  }
  
  cat("\nMain data validation complete.\n")
  cat("=============================================\n\n")
}

# =================================================================
# Validation function for land_cover_data
# =================================================================

validate_land_cover_data <- function(data) {
  cat("===== Validating land_cover_data =====\n\n")
  
  # Check if it's a list with expected regions
  expected_regions <- c("Girona", "Barcelona", "Tarragona")
  expected_rows <- c("Girona" = 19, "Barcelona" = 4, "Tarragona" = 16)
  
  cat("Region presence check:\n")
  for (region in expected_regions) {
    if (region %in% names(data)) {
      cat("  Region '", region, "' is present with ", nrow(data[[region]]), " observations\n", sep = "")
      
      # Check row count
      if (nrow(data[[region]]) != expected_rows[region]) {
        cat("  WARNING: Expected ", expected_rows[region], " rows for ", 
            region, ", but found ", nrow(data[[region]]), "\n", sep = "")
      }
    } else {
      cat("  WARNING: Region '", region, "' is missing!\n", sep = "")
    }
  }
  
  # Expected column patterns for land cover data
  id_col_pattern <- "^id_beach$"
  expected_50m_patterns <- c(
    "scrubland", "grassland", "communication_routes", "urban", 
    "forestry_bare_soil", "forests", "lagoon_and_salt_marshes", 
    "crops", "freshwater"
  )
  
  # Validate each region's data structure
  cat("\nValidating data structure for each region:\n")
  
  for (region in intersect(names(data), expected_regions)) {
    region_data <- data[[region]]
    cat("\n  Region:", region, "\n")
    
    # Check for 19 columns (id_beach + 9 for 50m + 9 for 100m)
    cat("  Column count:", ncol(region_data), "(expected 19)\n")
    if (ncol(region_data) != 19) {
      cat("  WARNING: Expected 19 columns, found", ncol(region_data), "\n")
    }
    
    # Check for id_beach column
    id_cols <- grep(id_col_pattern, names(region_data), value = TRUE)
    if (length(id_cols) > 0) {
      cat("  ID column found:", id_cols[1], "\n")
    } else {
      cat("  WARNING: No 'id_beach' column found!\n")
    }
    
    # Find 50m and 100m columns
    cols_50m <- grep("50m|50 m|x50", names(region_data), ignore.case = TRUE, value = TRUE)
    cols_100m <- grep("100m|100 m|x100", names(region_data), ignore.case = TRUE, value = TRUE)
    
    cat("  Found", length(cols_50m), "columns for 50m land cover (expected 9)\n")
    cat("  Found", length(cols_100m), "columns for 100m land cover (expected 9)\n")
    
    # Check for expected land cover types in 50m columns
    cat("\n  Checking for expected 50m land cover types:\n")
    for (pattern in expected_50m_patterns) {
      matches <- grep(pattern, cols_50m, ignore.case = TRUE, value = TRUE)
      if (length(matches) <= 0) {
        cat("    WARNING: No column matching '", pattern, "' pattern for 50m\n", sep = "")
      }
    }
    
    # Check for expected land cover types in 100m columns
    cat("\n  Checking for expected 100m land cover types:\n")
    for (pattern in expected_50m_patterns) {
      matches <- grep(pattern, cols_100m, ignore.case = TRUE, value = TRUE)
      if (length(matches) <= 0) {
        cat("    WARNING: No column matching '", pattern, "' pattern for 100m\n", sep = "")
      }
    }
    
    # Check if all columns are numeric
    numeric_cols <- sapply(region_data, is.numeric)
    cat("\n  Numeric columns:", sum(numeric_cols), "out of", ncol(region_data), "\n")
    if (sum(!numeric_cols) > 0) {
      cat("  WARNING: The following columns are not numeric:\n")
      for (col in names(region_data)[!numeric_cols]) {
        cat("    '", col, "' (class: ", class(region_data[[col]]), ")\n", sep = "")
      }
    }
    
    # Validate that 50m columns sum to 100 (allowing for rounding errors)
    if (length(cols_50m) > 0) {
      cat("\n  Validating 50m columns sum to 100%:\n")
      
      # Calculate row sums for 50m columns
      row_sums_50m <- rowSums(region_data[, cols_50m, drop = FALSE], na.rm = TRUE)
      valid_sums <- abs(row_sums_50m - 100) <= 0.15  # Allow for small rounding errors
      
      cat("    Rows with valid sums (approx 100%):", sum(valid_sums), "out of", length(row_sums_50m), "\n")
      if (sum(!valid_sums) > 0) {
        cat("    WARNING: The following rows have 50m sums significantly different from 100%:\n")
        invalid_rows <- which(!valid_sums)
        for (i in head(invalid_rows, 5)) {
          cat("      Row ", i, " (id_beach=", region_data$id_beach[i], 
              "): sum = ", row_sums_50m[i], "\n", sep = "")
        }
      }
    }
    
    # Validate that 100m columns sum to 100 (allowing for rounding errors)
    if (length(cols_100m) > 0) {
      cat("\n  Validating 100m columns sum to 100%:\n")
      
      # Calculate row sums for 100m columns
      row_sums_100m <- rowSums(region_data[, cols_100m, drop = FALSE], na.rm = TRUE)
      valid_sums <- abs(row_sums_100m - 100) <= 0.15  # Allow for small rounding errors
      
      cat("    Rows with valid sums (approx 100%):", sum(valid_sums), "out of", length(row_sums_100m), "\n")
      if (sum(!valid_sums) > 0) {
        cat("    WARNING: The following rows have 100m sums significantly different from 100%:\n")
        invalid_rows <- which(!valid_sums)
        for (i in head(invalid_rows, 5)) {
          cat("      Row ", i, " (id_beach=", region_data$id_beach[i], 
              "): sum = ", row_sums_100m[i], "\n", sep = "")
        }
      }
    }
  }
  
  cat("\nLand cover data validation complete.\n")
  cat("=============================================\n\n")
}

# =================================================================
# Validation function for management_data
# =================================================================

validate_management_data <- function(data) {
  cat("===== Validating management_data =====\n\n")
  
  # Check if it's a list with expected regions
  expected_regions <- c("Girona", "Barcelona", "Tarragona")
  expected_rows <- c("Girona" = 19, "Barcelona" = 4, "Tarragona" = 16)
  
  cat("Region presence check:\n")
  for (region in expected_regions) {
    if (region %in% names(data)) {
      cat("  Region '", region, "' is present with ", nrow(data[[region]]), " observations\n", sep = "")
      
      # Check row count
      if (nrow(data[[region]]) != expected_rows[region]) {
        cat("  WARNING: Expected ", expected_rows[region], " rows for ", 
            region, ", but found ", nrow(data[[region]]), "\n", sep = "")
      }
    } else {
      cat("  WARNING: Region '", region, "' is missing!\n", sep = "")
    }
  }
  
  # Expected columns for management data
  expected_columns <- c("id_plot", "id_beach", 
                        "managed_paths", "rope_fences", "mechanical_cleaning",
                        "surface_area_occupied_by_seasonal_services_and_amenities_on_or_less_than_5_m_from_the_dunes",
                        "surface_area_of_parking_or_other_fixed_services_on_or_less_than_5_m_from_the_dunes",
                        "protection_of_the_system_and_the_immediate_environment",
                        "degree_of_protection_according_to_the_iucn_classification")
  
  # Validate each region's data structure
  cat("\nValidating data structure for each region:\n")
  
  for (region in intersect(names(data), expected_regions)) {
    region_data <- data[[region]]
    cat("\n  Region:", region, "\n")
    
    # Check columns exist
    cat("  Column presence check:\n")
    missing_cols <- setdiff(expected_columns, names(region_data))
    present_cols <- intersect(expected_columns, names(region_data))
    
    cat("  Present expected columns:", length(present_cols), "out of", length(expected_columns), "\n")
    if (length(missing_cols) > 0) {
      cat("  WARNING: Missing expected columns:", toString(missing_cols), "\n")
    }
    
    # Validate that management rating columns only contain integer values 0-5
    # These are all columns from managed_paths onwards
    management_cols <- expected_columns[4:length(expected_columns)]
    present_management_cols <- intersect(management_cols, names(region_data))
    
    cat("\n  Validating management rating columns (integers 0-5):\n")
    
    # Function to check if column has valid values (0-5 integer values or NA)
    check_management_col <- function(col_name) {
      values <- region_data[[col_name]]
      valid_values <- is.na(values) | 
                     (values >= 0 & values <= 5 & values == floor(values))
      return(list(
        valid = all(valid_values),
        invalid_values = values[!valid_values]
      ))
    }
    
    # Apply check to all management columns
    for (col in present_management_cols) {
      col_check <- check_management_col(col)
      cat("  Column '", col, "': ", ifelse(col_check$valid, "VALID", "INVALID"), "\n", sep = "")
      
      # If invalid, show examples
      if (!col_check$valid) {
        cat("    Invalid values: ", toString(head(col_check$invalid_values, 5)), "\n", sep = "")
      }
    }
  }
  
  cat("\nManagement data validation complete.\n")
  cat("=============================================\n\n")
}

# =================================================================
# Load and validate the data files
# =================================================================

cat("Starting data validation...\n\n")

# Load main_data
cat("Loading main_data...\n")
if (file.exists("../data/processed_data_clean.RData")) {
  load("../data/processed_data_clean.RData")
  validate_main_data(main_data)
} else {
  cat("ERROR: File 'data/processed_data_clean.RData' not found!\n\n")
}

# Load land_cover_data
cat("Loading land_cover_data...\n")
if (file.exists("../data/all_land_cover_data.RData")) {
  load("../data/all_land_cover_data.RData")
  validate_land_cover_data(land_cover_data)
} else {
  cat("ERROR: File 'data/all_land_cover_data.RData' not found!\n\n")
}

# Load management_data (placeholder for future implementation)
cat("Loading management_data...\n")
if (file.exists("../data/all_management_data.RData")) {
  load("../data/all_management_data.RData")
  validate_management_data(management_data)
} else {
  cat("ERROR: File 'data/all_management_data.RData' not found!\n\n")
}

cat("Validation complete.\n")
