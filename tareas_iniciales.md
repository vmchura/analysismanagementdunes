# Tareas Iniciales de Investigación - TFM Dunas Costeras

## Primeros Pasos (Semana 1)

- [ ] Ejecutar el script `Task1_1_ExploreData.R` para explorar la estructura del dataset
  * Revisa todas las variables disponibles
  * Identifica las columnas que contienen información de especies
  * Comprende la estructura de provincias y localidades
  * Examina las variables de gestión y cobertura de suelo

- [ ] Ejecutar el script `Task1_2_SplitProvinces.R` para dividir el conjunto de datos por provincias
  * Verifica que la separación por provincias sea correcta
  * Confirma que las cantidades coincidan con lo mencionado en el reporte previo (39 playas, 278 parcelas)
  * Revisa que no haya pérdida de información en el proceso

- [ ] Ejecutar el script `Task1_3_ExploratoryViz.R` para visualizar la distribución de especies
  * Analiza los gráficos generados
  * Compara los resultados con las descripciones en los reportes previos
  * Identifica patrones preliminares de distribución de especies

## Preparación del Entorno y Documentación (Semana 1-2)

- [ ] Revisar y adaptar los archivos de capítulos draft creados
  * Personaliza la introducción según tu enfoque específico
  * Adapta la metodología a los análisis que realizarás
  * Asegúrate que la estructura siga las normas del TFM

- [ ] Configurar el entorno R y bibliotecas necesarias
  * Verifica que todas las bibliotecas mencionadas en los scripts estén instaladas
  * Prueba la funcionalidad de carga y procesamiento de datos
  * Configura tu espacio de trabajo en RStudio para el proyecto

- [ ] Familiarizarte con los archivos Quarto para la generación del documento final
  * Revisa la estructura de _quarto.yml
  * Entiende cómo se generan las referencias bibliográficas
  * Prueba la compilación de un capítulo simple

## Análisis Preliminar (Semana 2)

- [ ] Crear un primer borrador del Capítulo 1 con la introducción y contexto
  * Incluye el objetivo general y específicos
  * Describe brevemente la relevancia del estudio
  * Integra información sobre las dunas costeras catalanas

- [ ] Desarrollar scripts para el preprocesamiento de datos
  * Implementa el tratamiento de valores perdidos
  * Desarrolla la detección y manejo de outliers
  * Prepara las transformaciones de variables necesarias

- [ ] Realizar una primera ejecución del análisis NMDS para clasificación de hábitats
  * Genera visualizaciones preliminares de agrupaciones
  * Compara con resultados previos (capítulo 2 del reporte anterior)
  * Documenta las diferencias o similitudes observadas

## Criterios de Validación para esta Fase Inicial

1. **Comprensión de datos**
   * Se ha identificado correctamente la estructura del dataset
   * Se comprenden todas las variables y sus significados
   * Se ha documentado adecuadamente la exploración inicial

2. **Replicación preliminar**
   * Los resultados iniciales son consistentes con reportes previos
   * La división por provincias refleja la estructura biogeográfica mencionada
   * Las especies dominantes identificadas coinciden con lo reportado

3. **Estructura del documento**
   * Los borradores de capítulos siguen el formato requerido
   * La estructura del TFM está claramente definida
   * Las referencias están correctamente configuradas

## Próximos Pasos Después de la Fase Inicial

Una vez completadas estas tareas iniciales, deberás:

1. Definir un cronograma detallado para el resto del análisis según el plan del proyecto
2. Comenzar con el análisis multivariante más complejo (CCA, SIMPER, MFA)
3. Profundizar en la relación entre gestión de playas y composición de especies
4. Desarrollar visualizaciones avanzadas para resultados
5. Continuar con la redacción sistemática de los capítulos del TFM

## Recursos y Apoyo

- Reportes previos en la carpeta `/previous_report/` 
- Dataset principal en `/data/db_species_20250214.xlsx`
- Scripts iniciales en `/Experiments/`
- Borradores de capítulos en `/Chapters/`

## Consideraciones Finales

Recuerda que este es un proceso iterativo. Los resultados iniciales informarán los siguientes pasos del análisis, y es posible que necesites ajustar tu enfoque a medida que descubras patrones en los datos. Mantén una documentación clara de todas tus decisiones analíticas para facilitar la redacción final del TFM.
