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


cat("Starting data validation...\n\n")

# Load main_data
cat("Loading main_data...\n")
if (file.exists("data/processed_data_clean.RData")) {
  load("data/processed_data_clean.RData")
  validate_main_data(main_data)
} else {
  cat("ERROR: File 'data/processed_data_clean.RData' not found!\n\n")
}

cat("Validation complete.\n")
