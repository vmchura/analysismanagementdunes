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

# --- Diccionarios de Traducción ---

# Diccionario para tipos de cobertura del suelo (land cover types)
LAND_COVER_TRANSLATIONS <- c(
  # Vegetation types - Tipos de vegetación
  "forest" = "Bosque",
  "forests" = "Bosques",
  "scrubland" = "Matorral",
  "grassland" = "Pastizal",
  "herbaceous" = "Herbáceas",
  "woody" = "Leñosas",
  "vegetation" = "Vegetación",
  "natural vegetation" = "Vegetación Natural",
  "pine forest" = "Pinar",
  "oak forest" = "Encinar",
  "mixed forest" = "Bosque Mixto",
  
  # Land use types - Tipos de uso del suelo
  "agricultural" = "Agrícola",
  "cropland" = "Cultivos",
  "crops" = "Cultivos",
  "urban" = "Urbano",
  "developed" = "Desarrollado",
  "residential" = "Residencial",
  "commercial" = "Comercial",
  "industrial" = "Industrial",
  "infrastructure" = "Infraestructura",
  "transport" = "Transporte",
  "roads" = "Carreteras",
  "communication routes" = "Vías de Comunicación",
  "communication_routes" = "Vías de Comunicación",
  
  # Water and coastal features - Agua y características costeras
  "water" = "Agua",
  "freshwater" = "Agua Dulce",
  "saltwater" = "Agua Salada",
  "wetland" = "Humedal",
  "lagoon and salt marshes" = "Lagunas y Marismas",
  "lagoon_and_salt_marshes" = "Lagunas y Marismas",
  "beach" = "Playa",
  "sand" = "Arena",
  "dunes" = "Dunas",
  "coastal" = "Costero",
  "marine" = "Marino",
  
  # Built environment - Entorno construido
  "buildings" = "Edificios",
  "parking" = "Aparcamiento",
  "pavement" = "Pavimento",
  "concrete" = "Hormigón",
  "asphalt" = "Asfalto",
  "impervious" = "Impermeable",
  
  # Natural features - Características naturales
  "rock" = "Roca",
  "bare soil" = "Suelo Desnudo",
  "forestry bare soil" = "Suelo Desnudo Forestal",
  "cliff" = "Acantilado",
  "slope" = "Ladera",
  
  # Common compound terms - Términos compuestos comunes
  "artificial surfaces" = "Superficies Artificiales",
  "natural areas" = "Áreas Naturales",
  "semi natural" = "Semi-Natural",
  "mixed use" = "Uso Mixto"
)

# Diccionario para variables de gestión (management variables)
MANAGEMENT_TRANSLATIONS <- c(
  # Management practices - Prácticas de gestión
  "managed_paths" = "Senderos Gestionados",
  "managed paths" = "Senderos Gestionados",
  "rope_fences" = "Vallado con Cuerdas",
  "rope fences" = "Vallado con Cuerdas",
  "mechanical_cleaning" = "Limpieza Mecánica",
  "mechanical cleaning" = "Limpieza Mecánica",
  "seasonal_services" = "Servicios Estacionales",
  "seasonal services" = "Servicios Estacionales",
  "fixed_services" = "Servicios Fijos",
  "fixed services" = "Servicios Fijos",
  "surface_area_occupied_by_seasonal_services_and_amenities_on_or_less_than_5_m_from_the_dunes" = "Servicios Estacionales (≤5m de Dunas)",
  "surface area occupied by seasonal services and amenities on or less than 5 m from the dunes" = "Servicios Estacionales (≤5m de Dunas)",
  "surface_area_of_parking_or_other_fixed_services_on_or_less_than_5_m_from_the_dunes" = "Servicios Fijos (≤5m de Dunas)",
  "surface area of parking or other fixed services on or less than 5 m from the dunes" = "Servicios Fijos (≤5m de Dunas)",
  "protection_of_the_system_and_the_immediate_environment" = "Protección del Sistema",
  "protection of the system and the immediate environment" = "Protección del Sistema",
  "degree_of_protection_according_to_the_iucn_classification" = "Protección IUCN",
  "degree of protection according to the iucn classification" = "Protección IUCN",
  
  # Spanish terms that should remain unchanged (identity mapping)
  "Senderos Gestionados" = "Senderos Gestionados",
  "Vallado con Cuerdas" = "Vallado con Cuerdas", 
  "Limpieza Mecánica" = "Limpieza Mecánica",
  "Servicios Estacionales (≤5m de Dunas)" = "Servicios Estacionales (≤5m de Dunas)",
  "Servicios Fijos (≤5m de Dunas)" = "Servicios Fijos (≤5m de Dunas)",
  "Protección del Sistema" = "Protección del Sistema",
  "Protección IUCN" = "Protección IUCN",
  "Servicios Estacionales" = "Servicios Estacionales",
  "Servicios Fijos" = "Servicios Fijos",
  
  # Additional management variables that might appear
  "visitor_management" = "Gestión de Visitantes",
  "visitor management" = "Gestión de Visitantes",
  "access_control" = "Control de Acceso",
  "access control" = "Control de Acceso",
  "infrastructure_management" = "Gestión de Infraestructura",
  "infrastructure management" = "Gestión de Infraestructura",
  "beach_cleaning" = "Limpieza de Playa",
  "beach cleaning" = "Limpieza de Playa",
  "vegetation_management" = "Gestión de Vegetación",
  "vegetation management" = "Gestión de Vegetación",
  "erosion_control" = "Control de Erosión",
  "erosion control" = "Control de Erosión",
  "restoration_activities" = "Actividades de Restauración",
  "restoration activities" = "Actividades de Restauración",
  "monitoring_programs" = "Programas de Monitoreo",
  "monitoring programs" = "Programas de Monitoreo",
  "education_programs" = "Programas Educativos",
  "education programs" = "Programas Educativos",
  "signage" = "Señalización",
  "interpretive_signs" = "Señales Interpretativas",
  "interpretive signs" = "Señales Interpretativas",
  "barriers" = "Barreras",
  "fencing" = "Vallado",
  "boardwalks" = "Pasarelas",
  "pathways" = "Senderos",
  "designated_areas" = "Áreas Designadas",
  "designated areas" = "Áreas Designadas",
  "restricted_areas" = "Áreas Restringidas",
  "restricted areas" = "Áreas Restringidas",
  
  # Management categories - Categorías de gestión
  "Unmanaged" = "Sin Gestión",
  "Low Management" = "Gestión Baja",
  "Moderate Management" = "Gestión Moderada",
  "High Management" = "Gestión Alta",
  "Very High Management" = "Gestión Muy Alta",
  "No Management (0)" = "Sin Gestión (0)",
  "Very Low (0-1)" = "Muy Baja (0-1)",
  "Low (1-2)" = "Baja (1-2)",
  "Moderate (2-3)" = "Moderada (2-3)",
  "High (3-4)" = "Alta (3-4)",
  "Very High (4-5)" = "Muy Alta (4-5)",
  "Unknown" = "Desconocido",
  
  # Management descriptors - Descriptores de gestión
  "Management Intensity" = "Intensidad de Gestión",
  "Management Practice" = "Práctica de Gestión",
  "Management Practices" = "Prácticas de Gestión",
  "Management Score" = "Puntuación de Gestión",
  "Overall Intensity" = "Intensidad General",
  "Variable de Gestión" = "Variable de Gestión",
  "Variables de Gestión" = "Variables de Gestión",
  "Variables descriptivas para CCA" = "Variables Descriptivas para CCA"
)

# Diccionario para términos de análisis (analysis terms)
ANALYSIS_TRANSLATIONS <- c(
  # Statistical terms - Términos estadísticos
  "Species" = "Especies",
  "Region" = "Región",
  "Percentage" = "Porcentaje",
  "Mean" = "Media",
  "Average" = "Promedio",
  "Standard Error" = "Error Estándar",
  "Correlation" = "Correlación",
  "Abundance" = "Abundancia",
  "Richness" = "Riqueza",
  "Diversity" = "Diversidad",
  "Cover" = "Cobertura",
  "Coverage" = "Cobertura",
  "Frequency" = "Frecuencia",
  "Presence" = "Presencia",
  
  # Analysis methods - Métodos de análisis
  "NMDS" = "NMDS",
  "CCA" = "CCA",
  "Ordination" = "Ordenación",
  "Gradient" = "Gradiente",
  "Environmental Variables" = "Variables Ambientales",
  "Environmental Variable" = "Variable Ambiental",
  "Biplot" = "Biplot",
  "Species Scores" = "Puntuaciones de Especies",
  "Site Scores" = "Puntuaciones de Sitios",
  
  # Common plot elements - Elementos comunes de gráficos
  "Land Cover Type" = "Tipo de Cobertura del Suelo",
  "Land Cover" = "Cobertura del Suelo",
  "Beach" = "Playa",
  "Plot" = "Parcela",
  "Site" = "Sitio",
  "Sample" = "Muestra",
  "Observation" = "Observación"
)

# Función para traducir etiquetas automáticamente
translate_labels <- function(labels, custom_dict = NULL, debug = FALSE) {
  strict_mode <- TRUE
  # Combinar todos los diccionarios
  all_translations <- c(LAND_COVER_TRANSLATIONS, MANAGEMENT_TRANSLATIONS, ANALYSIS_TRANSLATIONS)
  
  # Añadir diccionario personalizado si se proporciona
  if (!is.null(custom_dict)) {
    all_translations <- c(all_translations, custom_dict)
  }
  
  # Función para limpiar y normalizar texto
  clean_text <- function(text) {
    # Remover prefijos de distancia y porcentaje
    text <- gsub("^x(50|100)m_", "", text, ignore.case = TRUE)
    text <- gsub("_percent$", "", text, ignore.case = TRUE)
    text <- gsub("_", " ", text)
    text <- tools::toTitleCase(text)
    return(text)
  }
  
  # Almacenar etiquetas no encontradas para reporte de errores
  untranslated_labels <- character(0)
  
  # Traducir cada etiqueta
  translated <- sapply(labels, function(label) {
    original_label <- label
    
    # Primero buscar traducción directa
    if (label %in% names(all_translations)) {
      if (debug) cat("✓ Traducción directa encontrada:", label, "→", all_translations[label], "\n")
      return(all_translations[label])
    }
    
    # Limpiar el texto y buscar nuevamente
    cleaned_label <- clean_text(label)
    cleaned_key <- tolower(cleaned_label)
    
    # Buscar en versiones en minúsculas de las claves
    lower_keys <- tolower(names(all_translations))
    match_idx <- match(cleaned_key, lower_keys)
    
    if (!is.na(match_idx)) {
      if (debug) cat("✓ Traducción por limpieza encontrada:", label, "→", all_translations[match_idx], "\n")
      return(all_translations[match_idx])
    }
    
    # Buscar coincidencias parciales para términos compuestos
    for (key in names(all_translations)) {
      if (grepl(tolower(key), tolower(label), fixed = TRUE) || 
          grepl(tolower(label), tolower(key), fixed = TRUE)) {
        if (debug) cat("✓ Traducción parcial encontrada:", label, "→", all_translations[key], "\n")
        return(all_translations[key])
      }
    }
    
    # Si llegamos aquí, no se encontró traducción
    untranslated_labels <<- c(untranslated_labels, original_label)
    
    if (debug) cat("✗ NO ENCONTRADA:", original_label, "\n")
    
    # En modo estricto, almacenar para error crítico
    if (strict_mode) {
      return(paste0("MISSING_TRANSLATION: ", original_label))
    } else {
      # En modo no estricto, devolver el texto limpio con advertencia
      warning(paste("Traducción no encontrada para:", original_label, "- usando texto limpio"))
      return(cleaned_label)
    }
  })
  
  # Si hay etiquetas no traducidas en modo estricto, lanzar error crítico
  if (strict_mode && length(untranslated_labels) > 0) {
    error_message <- paste0(
      "❌ ERROR CRÍTICO: TRADUCCIONES FALTANTES\n",
      "\n",
      "Las siguientes etiquetas NO tienen traducción al español:\n\n",
      paste("  ➤", unique(untranslated_labels), collapse = "\n"), "\n\n",
      "ACCIONES REQUERIDAS:\n",
      "1. Añadir las traducciones faltantes a los diccionarios en global_config.R\n",
      "2. O usar strict_mode = FALSE para permitir etiquetas sin traducir\n\n",
      "UBICACIÓN: Función translate_labels() en R/global_config.R\n",
      "="
    )
    stop(error_message, call. = FALSE)
  }
  
  # Reporte de debug si está activado
  if (debug) {
    cat("\n📊 REPORTE DE TRADUCCIÓN:\n")
    cat("Total etiquetas:", length(labels), "\n")
    cat("Traducidas exitosamente:", length(labels) - length(untranslated_labels), "\n")
    cat("Sin traducción:", length(untranslated_labels), "\n")
    if (length(untranslated_labels) > 0) {
      cat("Etiquetas sin traducir:", paste(unique(untranslated_labels), collapse = ", "), "\n")
    }
    cat("\n")
  }
  
  return(as.character(translated))
}

# Función auxiliar para agregar traducciones faltantes rápidamente
add_missing_translations <- function(missing_labels, translations) {
  if (length(missing_labels) != length(translations)) {
    stop("El número de etiquetas faltantes debe coincidir con el número de traducciones")
  }
  
  cat("Agregando las siguientes traducciones:\n")
  for (i in seq_along(missing_labels)) {
    cat("  ", missing_labels[i], " → ", translations[i], "\n")
  }
  
  # Crear código R para agregar al diccionario
  new_entries <- paste0('"', missing_labels, '" = "', translations, '"')
  cat("\nCódigo para agregar a LAND_COVER_TRANSLATIONS, MANAGEMENT_TRANSLATIONS o ANALYSIS_TRANSLATIONS:\n")
  cat(paste(new_entries, collapse = ",\n"), "\n")
}

# Función para aplicar traducciones a elementos de ggplot
apply_spanish_labels <- function(gg_plot, 
                                title = NULL, 
                                subtitle = NULL, 
                                x_label = NULL, 
                                y_label = NULL, 
                                legend_title = NULL,
                                caption = NULL) {
  
  if (!is.null(title)) {
    gg_plot <- gg_plot + labs(title = title)
  }
  if (!is.null(subtitle)) {
    gg_plot <- gg_plot + labs(subtitle = subtitle)
  }
  if (!is.null(x_label)) {
    gg_plot <- gg_plot + labs(x = x_label)
  }
  if (!is.null(y_label)) {
    gg_plot <- gg_plot + labs(y = y_label)
  }
  if (!is.null(legend_title)) {
    gg_plot <- gg_plot + labs(fill = legend_title, color = legend_title, shape = legend_title)
  }
  if (!is.null(caption)) {
    gg_plot <- gg_plot + labs(caption = caption)
  }
  
  return(gg_plot)
}
