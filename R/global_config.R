# Global configuration settings for the project
# This file contains shared variables to maintain consistency across all visualizations

# --- Regional settings ---

# Define the standard order for provinces (regions)
PROVINCE_ORDER <- c("Tarragona", "Barcelona", "Girona")

# Define consistent colors for each province
# Using a custom color palette that will be used across all visualizations
PROVINCE_COLORS <- c(
  "Tarragona" = "#E41A1C",  # Red
  "Barcelona" = "#377EB8",  # Blue
  "Girona" = "#4DAF4A"      # Green
)

# Function to apply standard province settings to a ggplot object
apply_province_theme <- function(gg_plot, fill_var = "Region") {
  gg_plot +
    scale_fill_manual(values = PROVINCE_COLORS) +
    scale_color_manual(values = PROVINCE_COLORS)
}

# Function to ensure provinces are ordered consistently
order_provinces <- function(data_frame, column_name = "Region") {
  data_frame[[column_name]] <- factor(data_frame[[column_name]], levels = PROVINCE_ORDER)
  return(data_frame)
}
