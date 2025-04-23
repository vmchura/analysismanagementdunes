# Task 1.2: Split dataset by provinces
# This script divides the dataset by the three biogeographical zones 
# (Girona, Barcelona, Tarragona) for separate analysis

# Load necessary libraries

library(tidyverse)

# Set conflicts resolution preference
conflicted::conflict_prefer("filter", "dplyr")
conflicted::conflict_prefer("select", "dplyr")

# First, load the saved data
load("data/processed_data_clean.RData")

# Select only the columns needed: first column (plot), columns from 2 to the one before eunis, and id_beach
main_data <- main_data %>%
  select(plot, 2:(which(names(main_data) == "eunis") - 1), id_beach)

# Create a named list to store the regional data
beaches_by_region <- list()

# Split data by region according to id_beach ranges
beaches_by_region[["Girona"]] <- main_data %>% filter(id_beach >= 1 & id_beach <= 19)
beaches_by_region[["Barcelona"]] <- main_data %>% filter(id_beach >= 20 & id_beach <= 23)
beaches_by_region[["Tarragona"]] <- main_data %>% filter(id_beach >= 24)

# Check the structure and sizes
cat("Number of beaches by region:\n")
cat("Girona:", nrow(beaches_by_region[["Girona"]]), "observations\n")
cat("Barcelona:", nrow(beaches_by_region[["Barcelona"]]), "observations\n")
cat("Tarragona:", nrow(beaches_by_region[["Tarragona"]]), "observations\n")

# You can access each regional dataset like this:
# beaches_by_region[["Girona"]]
# Or with $ notation:
# beaches_by_region$Girona
save(beaches_by_region, file = "data/all_observations_split.RData")
