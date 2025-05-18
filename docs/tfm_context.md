# TFM Project Summary: Coastal Dunes Analysis

## Project Overview
- **Title**: "Análisis de la Relación entre la Gestión de Playas, la Cobertura del Suelo y la Diversidad Vegetal en Dunas Costeras de Catalunya"
- **Focus**: Examining relationships between beach management practices, land cover, and plant diversity in coastal dune systems in Catalonia

## Data Structure

### Core Datasets
1. **Vegetation Survey Data** (`all_observations_split.RData`):
   - 278 plots across 168 transects from 39 beaches
   - 147 identified plant species
   - Split by provinces: Girona (beaches 1-19), Barcelona (beaches 20-23), Tarragona (beaches 24+)
   - Vegetation abundance measured using Braun-Blanquet scale (0-5)

2. **Land Cover Data** (`all_land_cover_data.RData`):
   - Measured at 50m and 100m from beach
   - Categories include: urban, forests, scrubland, crops, grassland, etc.
   - Data source: ICGC (2018)
   - Organized by province (Girona, Barcelona, Tarragona)

3. **Beach Management Data** (`all_management_data.RData`):
   - Management practices include: managed paths, rope fences, mechanical cleaning
   - Protection status and degree (IUCN classification)
   - Services impact (area occupied by seasonal/fixed services near dunes)
   - Organized by province (Girona, Barcelona, Tarragona)

### Key Variables

#### Vegetation Data:
- Plant species abundance using Braun-Blanquet scale:
  - 0: Taxa absent
  - 0.1: Solitary shoot, <5% cover
  - 0.5: Few shoots (<5), <5% cover
  - 1: Many shoots (>5), <5% cover
  - 2: 5-25% cover
  - 3: 25-50% cover
  - 4: 50-75% cover
  - 5: 75-100% cover

#### Land Cover Data:
- Percentage of different land cover types at 50m and 100m distances

#### Management Variables:
- Categorical variables for different management practices
- Protection status indicators
- Human impact metrics (services, amenities, parking)

## Analysis Methods
1. **Data preprocessing**: 
   - Split by provinces reflecting biogeographical zones
   - Cleaning, standardization, and conversion of Braun-Blanquet values

2. **Multivariate analyses**:
   - Canonical Correspondence Analysis (CCA): to relate species-environment relationships
   - SIMPER analysis: to identify key species driving differences between habitats
   - Non-metric Multidimensional Scaling (NMDS): to classify plots into habitat types and visualize similarity
   - Multiple Factor Analysis (MFA): to link different datasets

3. **Visualization approaches**:
   - Species abundance by region
   - Land cover composition at different distances
   - Species richness distribution
   - Relationship between management practices and species diversity

## Key Findings (Initial)
1. **Regional differences**:
   - Distinct vegetation patterns between Girona, Barcelona, and Tarragona
   - Elymus farctus is dominant in multiple habitats across regions
   - Each region shows characteristic species assemblages

2. **Habitat classification**:
   - NMDS identified four habitat types: front-dune, back-dune, mixed, disturbed

3. **Land cover impact**:
   - Significant differences in land cover between 50m and 100m distances
   - Different land cover profiles across the three provinces

4. **Analytical challenges**:
   - Low eigenvalues in CCA (under 50%) suggest imbalance between vegetation and land cover datasets
   - Land cover values are constant for beaches while vegetation plots within beaches vary

## Project Goals
- Understand how beach management practices affect plant diversity in dune systems
- Compare areas with Nature-Based Solutions (NBS) to unmanaged zones
- Inform conservation strategies for coastal dune ecosystems in Catalonia

## Analysis Progress
- Completed exploratory data analysis and visualization
- Split dataset by provinces for separate analysis
- Processed land cover data at different distances
- Preliminary multivariate analyses conducted
- Working on relating species presence to management practices

## Library/Package Dependencies
- tidyverse, ggplot2, readxl, janitor (data manipulation)
- vegan (for multivariate analysis: NMDS, CCA)
- gridExtra (visualization)

---
*This summary serves as a quick reference for understanding the structure, variables, and analysis approaches in your TFM project on coastal dune ecosystems in Catalonia.*