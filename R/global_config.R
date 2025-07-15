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

# Función para aplicar configuraciones estándar de provincia a un objeto ggplot
apply_province_theme <- function(gg_plot, fill_var = "Region") {
  gg_plot +
    scale_fill_manual(values = PROVINCE_COLORS) +
    scale_color_manual(values = PROVINCE_COLORS)
}

# Función para asegurar que las provincias estén ordenadas consistentemente
order_provinces <- function(data_frame, column_name = "Region") {
  data_frame[[column_name]] <- factor(data_frame[[column_name]], levels = PROVINCE_ORDER)
  return(data_frame)
}

# --- Configuración de estilos de gráficos ---

# Define los valores de la escala Braun-Blanquet para uso consistente
BRAUN_BLANQUET_VALUES <- c(0, 1, 2, 3, 4, 5)

# Define descripciones para cada valor en la escala
BRAUN_BLANQUET_DESCRIPTIONS <- c(
  "0: Taxón ausente",
  "1: Numerosos individuos (>5), <5% cobertura",
  "2: 5-25% cobertura",
  "3: 25-50% cobertura", 
  "4: 50-75% cobertura",
  "5: 75-100% cobertura"
)

# Función para aplicar la escala Braun-Blanquet a un objeto ggplot
apply_braun_blanquet_scale <- function(gg_plot = NULL, y_axis_name = "y") {
  # Cuando se usa en una cadena de pipes, gg_plot será NULL
  if (is.null(gg_plot)) {
    # Retorna expresiones para ser añadidas al gráfico
    return(list(
      geom_hline(yintercept = BRAUN_BLANQUET_VALUES, linetype = "dashed", 
                 color = "gray70", alpha = 0.7),
      scale_y_continuous(limits = c(0, 5), breaks = BRAUN_BLANQUET_VALUES),
      labs(caption = "Escala Braun-Blanquet: 0 (ausente) a 5 (75-100% cobertura)"),
      theme(panel.grid.major.y = element_blank())
    ))
  } else {
    # Usado directamente con un objeto de gráfico
    gg_plot +
      geom_hline(yintercept = BRAUN_BLANQUET_VALUES, linetype = "dashed", 
                 color = "gray70", alpha = 0.7) +
      scale_y_continuous(limits = c(0, 5), breaks = BRAUN_BLANQUET_VALUES) +
      labs(caption = "Escala Braun-Blanquet: 0 (ausente) a 5 (75-100% cobertura)") +
      theme(panel.grid.major.y = element_blank())
  }
}

# --- Escala de Porcentaje para Valores Braun-Blanquet ---

# Define puntos de quiebre de porcentaje que corresponden a la escala Braun-Blanquet
PERCENTAGE_BREAKS <- c(0, 5, 25, 50, 75, 100)

# Función para aplicar escala de porcentaje a un objeto ggplot
apply_percentage_scale <- function(gg_plot = NULL) {
  # Cuando se usa en una cadena de pipes, gg_plot será NULL
  if (is.null(gg_plot)) {
    # Retorna expresiones para ser añadidas al gráfico
    return(list(
      geom_hline(yintercept = PERCENTAGE_BREAKS, linetype = "dashed", 
                 color = "gray70", alpha = 0.7),
      scale_y_continuous(limits = c(0, 100), breaks = PERCENTAGE_BREAKS, minor_breaks = NULL),
      labs(caption = "Basado en valores máximos de cobertura de la escala Braun-Blanquet")
    ))
  } else {
    # Usado directamente con un objeto de gráfico
    gg_plot +
      geom_hline(yintercept = PERCENTAGE_BREAKS, linetype = "dashed", 
                 color = "gray70", alpha = 0.7) +
      scale_y_continuous(limits = c(0, 100), breaks = PERCENTAGE_BREAKS, minor_breaks = NULL) +
      labs(caption = "Basado en valores máximos de cobertura de la escala Braun-Blanquet")
  }
}

# Función para convertir valores Braun-Blanquet a porcentaje
# Esta es una versión vectorizada que puede manejar tanto valores únicos como vectores
bb_to_percentage <- function(bb_values) {
  # Si es un valor único
  if (length(bb_values) == 1) {
    if (is.na(bb_values)) return(0)
    
    # Convertir el valor único
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
  # Si es un vector
  else {
    # Aplicar la conversión a cada elemento en el vector
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
