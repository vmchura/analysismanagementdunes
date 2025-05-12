# Braun-Blanquet Survey Method Visualization

This document provides reference information for visualizing Braun-Blanquet scale data throughout this project.

## Scale Definition

The Braun-Blanquet scale is a method for estimating plant species cover within sample plots. It combines both abundance and coverage information into a single value:

| Score | Cover Description |
|-------|------------------|
| 0     | Taxa absent from quadrat |
| 0.1   | Taxa represented by a solitary shoot, <5% cover |
| 0.5   | Taxa represented by a few (<5) shoots, >5% cover |
| 1     | Taxa represented by many (>5) shoots, <5% cover |
| 2     | Taxa represented by many (>5) shoots, 5-25% cover |
| 3     | Taxa represented by many (>5) shoots, 25-50% cover |
| 4     | Taxa represented by many (>5) shoots, 50-75% cover |
| 5     | Taxa represented by many (>5) shoots, 75-100% cover |

## Visualization Options

### Option 1: Original Braun-Blanquet Scale (0-5)

When visualizing the original Braun-Blanquet scale values, the chart shows the direct scale values (0-5).

Example usage:
```r
# Method 1: Apply to existing plot object
p <- ggplot(data, aes(x = species, y = abundance)) +
  geom_bar(stat = "identity")
p <- apply_braun_blanquet_scale(p)
p
```

### Option 2: Percentage Coverage Scale (0-100%)

For improved interpretability, the Braun-Blanquet scale values can be converted to their maximum percentage coverage:

| Braun-Blanquet Value | Converted Percentage |
|----------------------|---------------------|
| 0                    | 0%                  |
| 0.1                  | 5%                  |
| 0.5                  | 5%                  |
| 1                    | 5%                  |
| 2                    | 25%                 |
| 3                    | 50%                 |
| 4                    | 75%                 |
| 5                    | 100%                |

Example usage:
```r
# Convert Braun-Blanquet values to percentages
percentage_data <- data %>%
  mutate(across(value_columns, bb_to_percentage))

# Create and display the plot
p <- ggplot(percentage_data, aes(x = species, y = percentage)) +
  geom_bar(stat = "identity")
p <- apply_percentage_scale(p)
p
```

## Implementation

The scale implementations are centralized in the `R/global_config.R` file to ensure consistency across all visualizations. The functions include:

1. `bb_to_percentage()`: Converts Braun-Blanquet values to maximum percentage coverage
2. `apply_braun_blanquet_scale()`: Applies the original scale (0-5) formatting to a plot
3. `apply_percentage_scale()`: Applies the percentage scale (0-100%) formatting to a plot

Using these standardized functions ensures consistent visualization throughout the project. = abundance)) +
  geom_bar(stat = "identity") +
  apply_braun_blanquet_scale()
```

