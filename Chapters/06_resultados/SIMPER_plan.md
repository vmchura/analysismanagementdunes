# Plan de Implementación: Análisis SIMPER para Gestión de Dunas Costeras

## Resumen Ejecutivo

El análisis SIMPER (Similarity Percentages) complementará los análisis CCA y NMDS existentes identificando qué especies contribuyen más a las diferencias entre grupos de gestión. Este análisis permitirá determinar especies indicadoras específicas para diferentes intensidades de gestión y cuantificar su contribución a la discriminación entre grupos.

## Contexto del Proyecto

### Análisis Existentes
- **NMDS**: Ordenación de comunidades vegetales por gestión
- **CCA**: Correspondencia entre variables de gestión y composición específica
- **Estructura de datos**: Matrices de especies con valores Braun-Blanquet transformados a porcentajes
- **Variables de gestión**: Escala ordinal 0-5 para diferentes prácticas

### Objetivo del SIMPER
Identificar especies que mejor discriminan entre diferentes intensidades de gestión y cuantificar su contribución a las diferencias observadas.

## Estructura del Análisis

### Paso 1: Configuración y Preparación de Datos
**Archivo**: `11_simper_management_analysis.qmd`
**Ubicación**: `Chapters/06_resultados/`

#### Componentes:
1. **Setup del análisis**
   - Cargar librerías necesarias (vegan, tidyverse, ggplot2)
   - Importar datos de especies y gestión
   - Configurar opciones de knitr

2. **Funciones de preparación**
   - `prepare_simper_data()`: Preparar matrices de especies por grupos de gestión
   - `create_management_groups()`: Crear grupos de gestión basados en intensidad
   - `validate_group_sizes()`: Validar tamaños mínimos de grupos

3. **Transformación de datos**
   - Agregar datos por playa (promedio de parcelas)
   - Convertir Braun-Blanquet a porcentajes
   - Crear grupos de gestión balanceados

### Paso 2: Análisis SIMPER por Región
**Funciones principales**:

#### `run_simper_analysis()`
- Ejecutar SIMPER entre pares de grupos de gestión
- Calcular contribuciones específicas a disimilitud
- Extraer especies discriminantes principales

#### `simper_pairwise_comparisons()`
- Comparaciones por pares entre grupos de gestión
- Sin Gestión vs Gestión Baja
- Gestión Baja vs Gestión Moderada
- Gestión Moderada vs Gestión Alta

#### `extract_discriminant_species()`
- Especies con contribución > 5% a disimilitud
- Especies con ratio contribución/SD > 1.5
- Especies con presencia > 30% en al menos un grupo

### Paso 3: Análisis Regional Comparativo

#### `compare_regions_simper()`
- SIMPER entre regiones para cada nivel de gestión
- Identificar especies características regionales
- Comparar patrones de respuesta a gestión

#### `regional_indicator_species()`
- Especies indicadoras por región
- Especies específicas de cada combinación región-gestión
- Especies cosmopolitas vs especialistas

### Paso 4: Visualizaciones Específicas

#### Gráficos principales:
1. **Contribución de especies a disimilitud**
   - Barras horizontales por comparación
   - Colores por grupos taxonómicos
   - Porcentajes de contribución

2. **Matriz de disimilitud entre grupos**
   - Heatmap de disimilitudes promedio
   - Dendrograma de agrupación
   - Comparación regional

3. **Especies discriminantes por región**
   - Diagramas de Venn de especies compartidas
   - Curvas de contribución acumulada
   - Perfiles de respuesta específica

4. **Análisis de constancia vs dominancia**
   - Scatter plot contribución vs abundancia
   - Identificación de especies clave
   - Categorización funcional

### Paso 5: Interpretación Ecológica

#### Categorías de especies:
1. **Especialistas de gestión**
   - Especies con alta contribución a disimilitud
   - Presencia restringida a ciertos niveles

2. **Indicadores de perturbación**
   - Especies que aumentan con gestión
   - Especies que disminuyen con gestión

3. **Especies tolerantes**
   - Baja contribución a disimilitud
   - Presencia constante entre grupos

## Implementación por Pasos

### Paso 1: Configuración Básica
```r
# Configurar entorno de análisis
# Cargar datos y funciones
# Crear grupos de gestión
# Validar datos
```

### Paso 2: SIMPER por Región
```r
# Girona: 3 grupos de gestión
# Barcelona: 1 grupo dominante (limitado)
# Tarragona: 2 grupos principales
# Análisis por pares
```

### Paso 3: SIMPER Combinado
```r
# Análisis conjunto de todas las regiones
# Identificar patrones generales
# Especies consistentes entre regiones
```

### Paso 4: Comparaciones Regionales
```r
# SIMPER entre regiones
# Efectos de región vs gestión
# Interacciones región-gestión
```

### Paso 5: Visualizaciones
```r
# Gráficos de contribución
# Matrices de disimilitud
# Perfiles de especies
# Mapas de calor
```

### Paso 6: Síntesis e Interpretación
```r
# Identificar especies clave
# Categorizar respuestas
# Generar recomendaciones
```

## Estructura de Archivos

### Archivo Principal
`Chapters/06_resultados/11_simper_management_analysis.qmd`

### Figuras Generadas
- `figures/simper_species_contribution.png`
- `figures/simper_dissimilarity_matrix.png`
- `figures/simper_regional_comparison.png`
- `figures/simper_indicator_species.png`

### Tablas de Resultados
- Tabla de especies discriminantes
- Tabla de contribuciones por grupo
- Tabla de disimilitudes promedio
- Tabla de especies indicadoras

## Integración con Análisis Existentes

### Sección en 05_Resultados.qmd
```markdown
### Análisis SIMPER de Especies Discriminantes {#sec-simper-analysis}

::: {#sec-simper-management-content}
{{< include 06_resultados/11_simper_management_analysis.qmd >}}
:::
```

### Conexiones con Análisis Previos
- **NMDS**: Validar grupos identificados por ordenación
- **CCA**: Relacionar especies discriminantes con variables de gestión
- **Especies abundantes**: Comparar con especies dominantes

## Consideraciones Técnicas

### Validación de Grupos
- Mínimo 3 observaciones por grupo
- Verificar homogeneidad intra-grupo
- Balancear tamaños de grupos cuando sea posible

### Criterios de Selección
- Contribución mínima: 5%
- Ratio contribución/SD: >1.5
- Presencia mínima: 30% en al menos un grupo

### Control de Calidad
- Verificar suma de contribuciones (≈100%)
- Validar significancia estadística
- Comprobar consistencia entre regiones

## Interpretación Ecológica Esperada

### Patrones Esperados
1. **Especies de dunas primarias**: Disminución con gestión intensiva
2. **Especies ruderales**: Aumento con perturbación
3. **Especies intermedias**: Máximo en gestión moderada

### Aplicaciones Prácticas
- Identificar indicadores de calidad de gestión
- Definir especies objetivo para conservación
- Desarrollar protocolos de monitoreo

## Cronograma de Implementación

### Fase 1 (Paso 1-2): Configuración y Análisis Básico
- Configurar entorno y datos
- Implementar funciones principales
- Análisis SIMPER por región

### Fase 2 (Paso 3-4): Análisis Comparativo
- SIMPER combinado todas las regiones
- Comparaciones regionales
- Análisis de interacciones

### Fase 3 (Paso 5-6): Visualización y Síntesis
- Crear visualizaciones principales
- Interpretar resultados ecológicos
- Generar recomendaciones de gestión

## Resultados Esperados

### Productos Principales
1. **Lista de especies discriminantes** por nivel de gestión
2. **Perfiles de respuesta específica** a gradientes de gestión
3. **Comparación regional** de patrones de respuesta
4. **Recomendaciones de gestión** basadas en especies clave

### Integración con Objetivos del Proyecto
- Complementar análisis multivariantes existentes
- Proporcionar herramientas prácticas para gestión
- Identificar prioridades de conservación específicas
- Apoyar toma de decisiones basada en evidencia

## Limitaciones y Consideraciones

### Limitaciones del Método
- Requiere grupos discretos bien definidos
- Sensible a especies dominantes
- Asume composición específica como proxy de calidad

### Consideraciones del Proyecto
- Barcelona tiene rango limitado de gestión
- Girona presenta mayor diversidad de gestión
- Tarragona muestra gestión más homogénea

### Validación Necesaria
- Verificar consistencia con análisis NMDS/CCA
- Confirmar interpretación ecológica
- Validar recomendaciones de gestión