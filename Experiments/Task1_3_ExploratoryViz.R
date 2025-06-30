
# Task 1.3: Exploratory Visualization
# This script creates visualizations of vegetation patterns across regions

# Load necessary libraries
library(tidyverse)
library(ggplot2)
library(gridExtra) # for arranging multiple plots

# Load data
load("../data/all_observations_split.RData")
names(beaches_by_region) # "Girona"    "Barcelona" "Tarragona"
load("../data/all_land_cover_data.RData")
names(land_cover_data) # "Girona"    "Barcelona" "Tarragona"

# --- Vegetation Pattern Analysis ---

# Function to calculate average abundance for each species in a region
calculate_avg_abundance <- function(region_data) {
  # Get species columns - exclude "plot" and "id_beach"
  species_cols <- setdiff(names(region_data), c("plot", "id_beach"))
  
  # Calculate mean for each species
  region_data %>%
    summarise(across(all_of(species_cols), mean, na.rm = TRUE)) %>%
    pivot_longer(cols = everything(), 
                 names_to = "species", 
                 values_to = "mean_abundance") %>%
    arrange(desc(mean_abundance))
}

# Calculate average abundance for each region
girona_abundance <- calculate_avg_abundance(beaches_by_region$Girona)
barcelona_abundance <- calculate_avg_abundance(beaches_by_region$Barcelona)
tarragona_abundance <- calculate_avg_abundance(beaches_by_region$Tarragona)

# Get top 10 most abundant species in each region
top_girona <- girona_abundance %>% slice_head(n = 10)
top_barcelona <- barcelona_abundance %>% slice_head(n = 10)
top_tarragona <- tarragona_abundance %>% slice_head(n = 10)

# Get the union of top species from all regions
top_species <- unique(c(top_girona$species, 
                         top_barcelona$species, 
                         top_tarragona$species))

# Function to prepare data for plotting
prepare_plot_data <- function(abundance_data, region_name, top_species_list) {
  abundance_data %>%
    filter(species %in% top_species_list) %>%
    mutate(region = region_name)
}

# Combine data from all regions
plot_data <- bind_rows(
  prepare_plot_data(girona_abundance, "Girona", top_species),
  prepare_plot_data(barcelona_abundance, "Barcelona", top_species),
  prepare_plot_data(tarragona_abundance, "Tarragona", top_species)
)

# Create a bar plot of top species by region
ggplot(plot_data, aes(x = reorder(species, mean_abundance), y = mean_abundance, fill = region)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Mean Abundance of Top Plant Species by Region",
       x = "Species",
       y = "Mean Abundance (Braun-Blanquet Scale)",
       fill = "Region") +
  theme(legend.position = "top",
        axis.text.y = element_text(size = 8)) +
  scale_fill_brewer(palette = "Set1")

# Save the plot
ggsave("figures/top_species_by_region.png", width = 12, height = 8)

# --- Proportion of Species Presence ---

# Function to calculate proportion of plots where species is present
calculate_presence <- function(region_data) {
  # Get species columns - exclude "plot" and "id_beach"
  species_cols <- setdiff(names(region_data), c("plot", "id_beach"))
  
  # Calculate presence (>0) percentage for each species
  region_data %>%
    summarise(across(all_of(species_cols), 
                    ~mean(. > 0, na.rm = TRUE) * 100)) %>%
    pivot_longer(cols = everything(), 
                 names_to = "species", 
                 values_to = "presence_percent") %>%
    arrange(desc(presence_percent))
}

# Calculate presence percentage for each region
girona_presence <- calculate_presence(beaches_by_region$Girona)
barcelona_presence <- calculate_presence(beaches_by_region$Barcelona)
tarragona_presence <- calculate_presence(beaches_by_region$Tarragona)

# Get top 10 most frequent species in each region
top_freq_girona <- girona_presence %>% slice_head(n = 10)
top_freq_barcelona <- barcelona_presence %>% slice_head(n = 10)
top_freq_tarragona <- tarragona_presence %>% slice_head(n = 10)

# Get the union of top frequent species from all regions
top_freq_species <- unique(c(top_freq_girona$species, 
                             top_freq_barcelona$species, 
                             top_freq_tarragona$species))

# Combine presence data from all regions
presence_plot_data <- bind_rows(
  prepare_plot_data(girona_presence, "Girona", top_freq_species) %>% 
    rename(value = presence_percent),
  prepare_plot_data(barcelona_presence, "Barcelona", top_freq_species) %>% 
    rename(value = presence_percent),
  prepare_plot_data(tarragona_presence, "Tarragona", top_freq_species) %>% 
    rename(value = presence_percent)
)

# Create a bar plot of most frequent species by region
ggplot(presence_plot_data, aes(x = reorder(species, value), y = value, fill = region)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Percentage of Plots with Species Present by Region",
       x = "Species",
       y = "Presence (%)",
       fill = "Region") +
  theme(legend.position = "top",
        axis.text.y = element_text(size = 8)) +
  scale_fill_brewer(palette = "Set1")

# Save the plot
ggsave("figures/species_presence_by_region.png", width = 12, height = 8)

# --- Species Richness Analysis ---

# Calculate species richness (number of species present) for each plot
calculate_richness <- function(region_data) {
  # Get species columns - exclude "plot" and "id_beach"
  species_cols <- setdiff(names(region_data), c("plot", "id_beach"))
  
  # Calculate number of species present for each plot
  region_data %>%
    mutate(richness = rowSums(across(all_of(species_cols), ~ . > 0))) %>%
    select(plot, id_beach, richness)
}

# Calculate richness for each region
girona_richness <- calculate_richness(beaches_by_region$Girona) %>% 
  mutate(region = "Girona")
barcelona_richness <- calculate_richness(beaches_by_region$Barcelona) %>% 
  mutate(region = "Barcelona")
tarragona_richness <- calculate_richness(beaches_by_region$Tarragona) %>% 
  mutate(region = "Tarragona")

# Combine richness data
all_richness <- bind_rows(girona_richness, barcelona_richness, tarragona_richness)

# Create box plot of species richness by region
ggplot(all_richness, aes(x = region, y = richness, fill = region)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Species Richness Distribution by Region",
       x = "Region",
       y = "Number of Species Present") +
  theme(legend.position = "none") +
  scale_fill_brewer(palette = "Set1")

# Save the plot
ggsave("figures/species_richness_by_region.png", width = 8, height = 6)

# Print summary statistics
cat("\nSummary of Species Richness by Region:\n")
richness_summary <- all_richness %>%
  group_by(region) %>%
  summarise(
    mean_richness = mean(richness, na.rm = TRUE),
    median_richness = median(richness, na.rm = TRUE),
    min_richness = min(richness, na.rm = TRUE),
    max_richness = max(richness, na.rm = TRUE)
  )
print(richness_summary)

# --- Land Cover Analysis ---

# Function to reshape land cover data for plotting
prepare_land_cover <- function(region_data) {
  region_data %>%
    pivot_longer(
      cols = -id_beach,
      names_to = "cover_type",
      values_to = "percentage"
    ) %>%
    # Extract the distance (50m or 100m) from the column name
    mutate(
      distance = ifelse(grepl("^x50m", cover_type), "50m", "100m"),
      # Clean up the cover type name by removing the distance prefix
      cover_type = gsub("^x(50|100)m_(.+)_percent$", "\\2", cover_type)
    )
}

# Prepare land cover data for all regions
girona_land <- prepare_land_cover(land_cover_data$Girona) %>% 
  mutate(region = "Girona")
barcelona_land <- prepare_land_cover(land_cover_data$Barcelona) %>% 
  mutate(region = "Barcelona")
tarragona_land <- prepare_land_cover(land_cover_data$Tarragona) %>% 
  mutate(region = "Tarragona")

# Combine all land cover data
all_land_cover <- bind_rows(girona_land, barcelona_land, tarragona_land)

# Calculate average land cover percentages for each region and distance
avg_land_cover <- all_land_cover %>%
  group_by(region, distance, cover_type) %>%
  summarise(
    mean_percentage = mean(percentage, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  # Filter out cover types with very low percentages for clarity
  filter(mean_percentage > 1)

# Plot land cover composition at 50m by region
ggplot(avg_land_cover %>% filter(distance == "50m"), 
       aes(x = region, y = mean_percentage, fill = cover_type)) +
  geom_bar(stat = "identity", position = "stack") +
  theme_minimal() +
  labs(
    title = "Average Land Cover Composition at 50m by Region",
    x = "Region",
    y = "Percentage (%)",
    fill = "Land Cover Type"
  ) +
  scale_fill_brewer(palette = "Set3") +
  theme(legend.position = "right")

# Save the plot
ggsave("figures/land_cover_50m_by_region.png", width = 10, height = 6)

# Plot land cover composition at 100m by region
ggplot(avg_land_cover %>% filter(distance == "100m"), 
       aes(x = region, y = mean_percentage, fill = cover_type)) +
  geom_bar(stat = "identity", position = "stack") +
  theme_minimal() +
  labs(
    title = "Average Land Cover Composition at 100m by Region",
    x = "Region",
    y = "Percentage (%)",
    fill = "Land Cover Type"
  ) +
  scale_fill_brewer(palette = "Set3") +
  theme(legend.position = "right")

# Save the plot
ggsave("figures/land_cover_100m_by_region.png", width = 10, height = 6)

# --- Compare 50m vs 100m land cover trends ---

# Calculate the difference between 50m and 100m for each land cover type
land_cover_diff <- all_land_cover %>%
  select(-percentage) %>%
  distinct() %>%
  left_join(
    all_land_cover %>%
      group_by(region, cover_type, distance) %>%
      summarise(mean_pct = mean(percentage, na.rm = TRUE), .groups = "drop"),
    by = c("region", "cover_type", "distance")
  ) %>%
  pivot_wider(
    names_from = distance,
    values_from = mean_pct
  ) %>%
  mutate(difference = `100m` - `50m`) %>%
  filter(abs(difference) > 2) # Filter for meaningful differences

# Plot the differences for top changing cover types
ggplot(land_cover_diff, aes(x = region, y = difference, fill = cover_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Difference in Land Cover Percentages (100m - 50m)",
    x = "Region",
    y = "Difference in Percentage Points",
    fill = "Land Cover Type"
  ) +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position = "bottom")

# Save the plot
ggsave("figures/land_cover_distance_diff.png", width = 10, height = 6)

# --- Relationship between land cover and species richness ---

# Join land cover data with species richness data
richness_land_cover <- all_richness %>%
  left_join(
    all_land_cover %>% 
      filter(distance == "50m") %>% # Using 50m for this analysis
      select(id_beach, region, cover_type, percentage),
    by = c("id_beach", "region")
  )

# Select the most relevant land cover types for analysis
relevant_cover_types <- c("urban", "forests", "scrubland", "crops", "grassland")

richness_vs_land <- richness_land_cover %>%
  filter(cover_type %in% relevant_cover_types)

# Create scatter plots for richness vs. land cover
ggplot(richness_vs_land, aes(x = percentage, y = richness, color = region)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE, linetype = "dashed") +
  facet_wrap(~cover_type, scales = "free_x") +
  theme_minimal() +
  labs(
    title = "Species Richness vs. Land Cover Types (50m)",
    x = "Land Cover Percentage (%)",
    y = "Number of Species Present",
    color = "Region"
  ) +
  scale_color_brewer(palette = "Set1") +
  theme(legend.position = "top")

# Save the plot
ggsave("figures/richness_vs_land_cover.png", width = 12, height = 8)

# --- Correlation analysis between dominant species and land cover ---

# Get top 5 species across all regions
top5_species <- c(
  top_girona$species[1:min(5, nrow(top_girona))],
  top_barcelona$species[1:min(5, nrow(top_barcelona))],
  top_tarragona$species[1:min(5, nrow(top_tarragona))]
) %>% unique()

# Function to prepare species abundance data with ID
prepare_species_data <- function(region_name) {
  region_data <- beaches_by_region[[region_name]]
  
  # Select only the top species and ID
  region_data %>%
    select(id_beach, all_of(top5_species)) %>%
    pivot_longer(
      cols = -id_beach,
      names_to = "species",
      values_to = "abundance"
    ) %>%
    mutate(region = region_name)
}

# Combine species data from all regions
species_data <- bind_rows(
  prepare_species_data("Girona"),
  prepare_species_data("Barcelona"),
  prepare_species_data("Tarragona")
)

# Join with land cover data
species_land_cover <- species_data %>%
  left_join(
    all_land_cover %>% 
      filter(distance == "50m", cover_type %in% relevant_cover_types) %>%
      select(id_beach, region, cover_type, percentage),
    by = c("id_beach", "region")
  )

# Create heatmap of correlations between species abundance and land cover
ggplot(species_land_cover, aes(x = cover_type, y = species, fill = abundance)) +
  geom_tile() +
  facet_wrap(~region, ncol = 3) +
  scale_fill_viridis_c() +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "right"
  ) +
  labs(
    title = "Dominant Species Abundance by Land Cover Type",
    x = "Land Cover Type",
    y = "Species",
    fill = "Mean Abundance\n(Braun-Blanquet Scale)"
  )

# Save the plot
ggsave("figures/species_by_land_cover_heatmap.png", width = 14, height = 10)

