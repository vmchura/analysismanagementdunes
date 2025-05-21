# Configuración global para el proyecto
# Este archivo contiene variables compartidas para mantener la coherencia en todas las visualizaciones

# --- Configuración regional ---

# Define el orden estándar para las provincias (regiones)
PROVINCE_ORDER <- c("Tarragona", "Barcelona", "Girona")

# Define colores consistentes para cada provincia
# Utilizando una paleta de colores personalizada que se usará en todas las visualizaciones
PROVINCE_COLORS <- c(
  "Tarragona" = "#E41A1C",  # Rojo
  "Barcelona" = "#377EB8",  # Azul
  "Girona" = "#4DAF4A"      # Verde
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

# --- Configuración de estilos de gráficos ---

# Define the Braun-Blanquet scale values for consistent use
BRAUN_BLANQUET_VALUES <- c(0, 1, 2, 3, 4, 5)

# Define descriptions for each value in the scale
BRAUN_BLANQUET_DESCRIPTIONS <- c(
  "0: Taxa absent",
  "1: Many shoots (>5), <5% cover",
  "2: 5-25% cover",
  "3: 25-50% cover", 
  "4: 50-75% cover",
  "5: 75-100% cover"
)

# Function to apply Braun-Blanquet scale to a ggplot object
apply_braun_blanquet_scale <- function(gg_plot = NULL, y_axis_name = "y") {
  # When used in a pipe chain, gg_plot will be NULL
  if (is.null(gg_plot)) {
    # Return expressions to be added to the plot
    return(list(
      geom_hline(yintercept = BRAUN_BLANQUET_VALUES, linetype = "dashed", 
                 color = "gray70", alpha = 0.7),
      scale_y_continuous(limits = c(0, 5), breaks = BRAUN_BLANQUET_VALUES),
      labs(caption = "Braun-Blanquet Scale: 0 (absent) to 5 (75-100% cover)"),
      theme(panel.grid.major.y = element_blank())
    ))
  } else {
    # Used directly with a plot object
    gg_plot +
      geom_hline(yintercept = BRAUN_BLANQUET_VALUES, linetype = "dashed", 
                 color = "gray70", alpha = 0.7) +
      scale_y_continuous(limits = c(0, 5), breaks = BRAUN_BLANQUET_VALUES) +
      labs(caption = "Braun-Blanquet Scale: 0 (absent) to 5 (75-100% cover)") +
      theme(panel.grid.major.y = element_blank())
  }
}

# --- Percentage Scale for Braun-Blanquet Values ---

# Define percentage breakpoints that correspond to Braun-Blanquet scale
PERCENTAGE_BREAKS <- c(0, 5, 25, 50, 75, 100)

# Function to apply percentage scale to a ggplot object
apply_percentage_scale <- function(gg_plot = NULL) {
  # When used in a pipe chain, gg_plot will be NULL
  if (is.null(gg_plot)) {
    # Return expressions to be added to the plot
    return(list(
      geom_hline(yintercept = PERCENTAGE_BREAKS, linetype = "dashed", 
                 color = "gray70", alpha = 0.7),
      scale_y_continuous(limits = c(0, 100), breaks = PERCENTAGE_BREAKS, minor_breaks = NULL),
      labs(caption = "Based on Braun-Blanquet scale maximum coverage values")
    ))
  } else {
    # Used directly with a plot object
    gg_plot +
      geom_hline(yintercept = PERCENTAGE_BREAKS, linetype = "dashed", 
                 color = "gray70", alpha = 0.7) +
      scale_y_continuous(limits = c(0, 100), breaks = PERCENTAGE_BREAKS, minor_breaks = NULL) +
      labs(caption = "Based on Braun-Blanquet scale maximum coverage values")
  }
}

# Function to convert Braun-Blanquet values to percentage
# This is a vectorized version that can handle both single values and vectors
bb_to_percentage <- function(bb_values) {
  # If it's a single value
  if (length(bb_values) == 1) {
    if (is.na(bb_values)) return(0)
    
    # Convert the single value
    if (bb_values == 0) return(0)
    else if (bb_values == 0.1) return(5)
    else if (bb_values == 0.5) return(5)
    else if (bb_values == 1) return(5)
    else if (bb_values == 2) return(25)
    else if (bb_values == 3) return(50)
    else if (bb_values == 4) return(75)
    else if (bb_values == 5) return(100)
    else return(as.numeric(bb_values))
  } 
  # If it's a vector
  else {
    # Apply the conversion to each element in the vector
    sapply(bb_values, function(value) {
      if (is.na(value)) return(0)
      
      if (value == 0) return(0)
      else if (value == 0.1) return(5)
      else if (value == 0.5) return(5)
      else if (value == 1) return(5)
      else if (value == 2) return(25)
      else if (value == 3) return(50)
      else if (value == 4) return(75)
      else if (value == 5) return(100)
      else return(as.numeric(value))
    })
  }
}

