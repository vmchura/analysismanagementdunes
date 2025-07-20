# TFM Project Summary: Coastal Dunes Analysis

## Project Overview
- **Title**: "Análisis de la Relación entre la Gestión de Playas, la Cobertura del Suelo y la Diversidad Vegetal en Dunas Costeras de Cataluña"
- **Focus**: Examining relationships between beach management practices, land cover, and plant diversity in coastal dune systems in Catalonia
- **Goal**: Understand how beach management practices affect plant diversity to inform conservation strategies for coastal dune ecosystems

## Data Structure & Schema

### Core Datasets

#### 1. Vegetation Survey Data (`all_observations_split.RData`)
- **Source File**: `data/db_species_20250214.xlsx` (sheet: "original_data")
- **Structure**: 278 plots across 168 transects from 39 beaches
- **Species Data**: 147 identified plant species with Braun-Blanquet abundance values
- **Key Columns**:
  - `plot`: Plot identifier
  - `id_beach`: Beach identifier (1-39)
  - `beach`: Beach name
  - `id_transect`: Transect identifier
  - `id_plot`: Plot identifier within transect
  - `transect`: Transect name
  - `eunis`: EUNIS habitat classification
  - `[species_names]`: 147 columns with species names (abundance values)

#### 2. Land Cover Data (`all_land_cover_data.RData`)
- **Source Sheets**: "girona_land_cover", "barcelona_land_cover", "tarragona_land_cover"
- **Structure**: Land cover percentages measured at 50m and 100m from beach
- **Key Columns**:
  - `id_beach`: Beach identifier
  - `x50m_[land_cover_type]_percent`: Land cover percentage at 50m distance
  - `x100m_[land_cover_type]_percent`: Land cover percentage at 100m distance
- **Land Cover Types**: urban, forests, scrubland, crops, grassland, water bodies, bare soil, etc.
- **Data Source**: ICGC (Institut Cartogràfic i Geològic de Catalunya) 2018

#### 3. Beach Management Data (`all_management_data.RData`)
- **Source Sheets**: "girona_management", "barcelona_management", "tarragona_management"
- **Key Variables**:
  - `id_beach`: Beach identifier
  - `managed_paths`: Presence of managed paths (categorical)
  - `rope_fences`: Presence of rope fences (categorical)
  - `mechanical_cleaning`: Type of mechanical cleaning (categorical)
  - `surface_area_occupied_by_seasonal_services_and_amenities_on_or_less_than_5_m_from_the_dunes`: Impact of seasonal services
  - `surface_area_of_parking_or_other_fixed_services_on_or_less_than_5_m_from_the_dunes`: Impact of permanent services
  - `protection_of_the_system_and_the_immediate_environment`: Protection status
  - `degree_of_protection_according_to_the_iucn_classification`: IUCN protection classification

### Regional Distribution
- **Split by provinces** reflecting biogeographical zones:
  - **Girona**: Beaches 1-19 (Mediterranean coast, more pristine areas)
  - **Barcelona**: Beaches 20-23 (Urban coast, higher human pressure)
  - **Tarragona**: Beaches 24+ (Southern coast, mixed characteristics)

## Key Variables & Measurements

### Vegetation Data - Braun-Blanquet Scale:
- **0**: Taxa absent
- **0.1**: Solitary shoot, <5% cover
- **0.5**: Few shoots (<5), <5% cover
- **1**: Many shoots (>5), <5% cover
- **2**: 5-25% cover
- **3**: 25-50% cover
- **4**: 50-75% cover
- **5**: 75-100% cover

### Conversion to Percentages (for analysis):
- 0 → 0%, 0.1 → 2.5%, 0.5 → 2.5%, 1 → 2.5%, 2 → 15%, 3 → 37.5%, 4 → 62.5%, 5 → 87.5%

### Land Cover Categories:
- **Urban areas**: Built environments, infrastructure
- **Forest areas**: Natural and planted forests
- **Scrubland**: Mediterranean shrublands and garrigue
- **Agricultural areas**: Crops and cultivated land
- **Grasslands**: Natural and semi-natural grasslands
- **Water bodies**: Rivers, lagoons, wetlands
- **Bare soil**: Exposed soil and rock surfaces

## Analysis Methods & Current Progress

### ✅ **COMPLETED ANALYSES**

#### 1. Data Preprocessing & Exploration
- ✅ Dataset splitting by provinces (Girona, Barcelona, Tarragona)
- ✅ Data cleaning and standardization
- ✅ Braun-Blanquet values conversion to numeric percentages
- ✅ Missing values handling and outlier detection

#### 2. Multivariate Analyses
- ✅ **Non-metric Multidimensional Scaling (NMDS)**:
  - Classification of plots into 4 habitat types: front-dune, back-dune, mixed, disturbed
  - Regional analysis showing distinct vegetation patterns
  - Habitat classification with stress values < 0.2 (acceptable fit)
  - Identification of indicator species for each habitat type

#### 3. Exploratory Visualizations
- ✅ Species richness distribution by region
- ✅ Top abundant species by region (Elymus farctus dominant across regions)
- ✅ Land cover composition at 50m and 100m distances
- ✅ Relationships between species richness and land cover types
- ✅ Habitat distribution across regions

### 🔄 **IN PROGRESS / PENDING ANALYSES**

#### 1. Canonical Correspondence Analysis (CCA)
- **Status**: NOT STARTED
- **Purpose**: Explore species-environment relationships
- **Goals**: 
  - Link vegetation patterns to land cover variables
  - Understand environmental gradients affecting species composition
  - Address previous issues with low eigenvalues (<50%)

#### 2. SIMPER Analysis
- **Status**: NOT STARTED  
- **Purpose**: Identify key species driving differences between groups
- **Goals**: Determine species contributing most to habitat type differences

#### 3. Management Impact Analysis
- **Status**: NOT STARTED
- **Purpose**: Analyze effects of management practices on vegetation
- **Goals**: 
  - Compare areas with Nature-Based Solutions (NBS) vs conventional management
  - Assess effectiveness of different management approaches
  - Generate practical recommendations for coastal managers

#### 4. Multiple Factor Analysis (MFA)
- **Status**: NOT STARTED
- **Purpose**: Integrate vegetation, land cover, and management datasets
- **Goals**: Identify patterns across multiple data types

## Key Findings (Preliminary)

### Regional Patterns:
- **Regional Specificity**: Each region shows characteristic species assemblages
- **Dominant Species**: Elymus farctus appears as dominant across multiple habitats and regions
- **Habitat Diversity**: Four distinct habitat types identified through NMDS
- **Land Cover Gradients**: Significant differences in land cover between 50m and 100m distances

### Habitat Classification:
- **Front-dune**: Characterized by pioneer species, harsh conditions
- **Back-dune**: More established vegetation, greater species diversity
- **Mixed**: Transitional areas with intermediate characteristics
- **Disturbed**: Areas affected by human activities or natural disturbance

### Analytical Challenges Identified:
- **Scale Mismatch**: Land cover data constant per beach while vegetation varies within beaches
- **Low CCA Eigenvalues**: Suggests need for better environmental variable selection
- **Data Integration**: Need to properly link management practices with vegetation outcomes

## Technical Configuration

### Libraries/Packages Used:
- **Data manipulation**: tidyverse, dplyr, readxl, janitor
- **Multivariate analysis**: vegan (NMDS, CCA, SIMPER)
- **Visualization**: ggplot2, gridExtra, RColorBrewer, patchwork
- **Utility**: conflicted (function conflicts resolution)

### File Structure:
- **Main analysis scripts**: `Experiments/Task1_*.R`
- **Results chapters**: `Chapters/06_resultados/`
- **Processed data**: `data/*.RData`
- **Figures**: `figures/*.png`
- **Configuration**: `R/global_config.R`

## Next Steps (Priority Order)

### 1. **CCA Analysis** (High Priority)
- Implement Canonical Correspondence Analysis
- Focus on relating species composition to land cover variables
- Address previous eigenvalue issues through variable selection
- Create constrained ordination linking vegetation to environmental gradients

### 2. **Management Impact Analysis** (High Priority)  
- Analyze relationships between management practices and species diversity
- Compare NBS approaches with conventional management
- Statistical testing of management effects on vegetation communities

### 3. **SIMPER Analysis** (Medium Priority)
- Identify species driving differences between habitat types
- Determine characteristic species for each management approach
- Quantify species contributions to group differences

### 4. **Data Integration (MFA)** (Medium Priority)
- Link vegetation, land cover, and management datasets
- Comprehensive analysis across all data types
- Identify overarching patterns in coastal dune systems

### 5. **Synthesis & Recommendations** (Final Phase)
- Integrate findings across all analyses
- Generate evidence-based management recommendations
- Complete thesis writing and documentation

## Project Goals & Success Criteria

### Scientific Goals:
- Understand species-environment relationships in coastal dunes
- Quantify effects of different management approaches on biodiversity
- Identify effective conservation strategies for dune ecosystems

### Practical Outcomes:
- Evidence-based recommendations for coastal dune management
- Guidelines for implementing Nature-Based Solutions
- Framework for monitoring dune ecosystem health

### Academic Requirements:
- Complete multivariate analysis demonstrating ecological relationships
- Statistical validation of management effects on vegetation
- Comprehensive thesis document meeting TFM standards

---
*Last Updated: Current analysis through NMDS completed. CCA analysis is the next critical step to understand species-environment relationships and complete the multivariate analysis framework.*