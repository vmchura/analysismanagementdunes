# Project Plan: Coastal Dunes Analysis - TFM

## Project Overview
**Title**: Análisis de la Relación entre la Gestión de Playas, la Cobertura del Suelo y la Diversidad Vegetal en Dunas Costeras de Catalunya  
**Goal**: Explore relationships between beach management, land cover, and plant diversity in coastal dune systems of Catalunya to inform conservation strategies.

## Phased Implementation Plan

### Phase 1: Project Setup and Data Exploration
**Objective**: Set up the project structure and gain a comprehensive understanding of the available data.

#### Task 1.1: Explore the dataset structure
- **Action**: Load and examine the Excel dataset from `data/db_species_20250214.xlsx`
- **Goal**: Understand all variables, their types, and distributions
- **Validation**: Document created with summary statistics and variable descriptions
- **File**: `Chapters/Chapter1.qmd` - Introduction and data description section

#### Task 1.2: Split dataset by provinces
- **Action**: Divide the dataset by the three biogeographical zones (Girona, Barcelona, Tarragona)
- **Goal**: Create three separate dataframes ready for analysis
- **Validation**: Three clean datasets matching previous report findings
- **File**: `Experiments/DataPrep_Provinces.R`

#### Task 1.3: Initial visualization of species distribution
- **Action**: Create visualization of species distribution across the three provinces
- **Goal**: First visual exploration of biodiversity patterns
- **Validation**: Visualizations match findings from previous reports
- **File**: `Experiments/ExploratoryViz.R`

### Phase 2: Data Preprocessing
**Objective**: Clean and prepare data for multivariate analysis.

#### Task 2.1: Handle missing values
- **Action**: Identify and process missing values using EM or k-NN methods
- **Goal**: Complete dataset ready for analysis
- **Validation**: No significant missing values remain, imputation quality assessment completed
- **File**: `Experiments/MissingValues.R`

#### Task 2.2: Detect and treat outliers
- **Action**: Apply Mahalanobis distance to identify multivariate outliers
- **Goal**: Dataset with outliers identified and handled
- **Validation**: Documentation of outliers and justification for treatment approach
- **File**: `Experiments/OutlierAnalysis.R`

#### Task 2.3: Transform variables as needed
- **Action**: Apply appropriate transformations (normalization, standardization)
- **Goal**: Variables in appropriate format for multivariate analysis
- **Validation**: Transformed variables meet assumptions for planned analyses
- **File**: `Experiments/DataTransformation.R`

#### Task 2.4: Encode categorical variables
- **Action**: Convert categorical variables into formats suitable for analysis
- **Goal**: All variables properly formatted for statistical analysis
- **Validation**: Categorical variables appropriately encoded and documented
- **File**: `Experiments/CategoricalEncoding.R`

### Phase 3: Multivariate Analysis
**Objective**: Apply multivariate techniques to explore relationships between species and environmental factors.

#### Task 3.1: Implement NMDS for habitat classification
- **Action**: Apply Non-metric Multidimensional Scaling to classify plots
- **Goal**: Classify plots into habitat types (front-dune, back-dune, mixed, disturbed)
- **Validation**: Results align with or improve upon previous classification
- **File**: `Experiments/NMDS_Analysis.R` and `Chapters/Chapter2.qmd`

#### Task 3.2: Perform Canonical Correspondence Analysis (CCA)
- **Action**: Apply CCA to explore species-environment relationships
- **Goal**: Identify relationships between species and environmental/land cover variables
- **Validation**: Results show meaningful ecological patterns, statistical significance of models
- **File**: `Experiments/CCA_Analysis.R` and `Chapters/Chapter3.qmd`

#### Task 3.3: Conduct SIMPER analysis
- **Action**: Perform SIMPER to identify key species driving differences
- **Goal**: Identify species contributing most to between-group differences
- **Validation**: Clear identification of indicator species for different habitat types
- **File**: `Experiments/SIMPER_Analysis.R` and `Chapters/Chapter3.qmd`

#### Task 3.4: Apply Multiple Factor Analysis (MFA)
- **Action**: Implement MFA to link different datasets (vegetation, land cover, management)
- **Goal**: Identify patterns across multiple data types
- **Validation**: Meaningful integration of datasets showing interesting ecological patterns
- **File**: `Experiments/MFA_Analysis.R` and `Chapters/Chapter4.qmd`

### Phase 4: Management Impacts Analysis
**Objective**: Analyze how management practices affect dune vegetation.

#### Task 4.1: Define management categories
- **Action**: Categorize beaches by management approach
- **Goal**: Clearly defined management types for analysis
- **Validation**: Management categories align with real-world practices
- **File**: `Experiments/ManagementCategories.R`

#### Task 4.2: Analyze differences in species composition by management
- **Action**: Compare species richness and composition across management types
- **Goal**: Identify patterns in vegetation related to management practices
- **Validation**: Statistical significance of differences, ecological meaning
- **File**: `Experiments/Management_Species_Analysis.R` and `Chapters/Chapter5.qmd`

#### Task 4.3: Focus on Nature-Based Solutions
- **Action**: Compare areas with NBS to conventional or unmanaged zones
- **Goal**: Assess effectiveness of NBS for biodiversity
- **Validation**: Statistical comparisons with ecological interpretation
- **File**: `Experiments/NBS_Analysis.R` and `Chapters/Chapter5.qmd`

### Phase 5: Results Integration and Thesis Writing
**Objective**: Integrate all findings and complete thesis document.

#### Task 5.1: Synthesize findings across analyses
- **Action**: Integrate results from different analyses to form cohesive narrative
- **Goal**: Comprehensive understanding of coastal dune dynamics in relation to management
- **Validation**: Clear connections between different analyses, coherent story
- **File**: `Chapters/Chapter6.qmd` - Synthesis and discussion

#### Task 5.2: Generate practical recommendations
- **Action**: Develop conservation and management recommendations
- **Goal**: Actionable insights for coastal managers
- **Validation**: Recommendations are specific, feasible, and evidence-based
- **File**: `Chapters/Chapter7.qmd` - Conclusions and recommendations

#### Task 5.3: Complete thesis document
- **Action**: Finalize all chapters, front matter, references, and appendices
- **Goal**: Complete, polished thesis document
- **Validation**: Document meets all university requirements for TFM
- **File**: All Quarto files and compilation of final document

## Immediate Next Actions

1. Begin with Task 1.1 by exploring the Excel dataset structure
2. Then proceed to Task 1.2 to split the dataset by provinces
3. Start the visual exploration with Task 1.3

## Validation Criteria for Project Success

The TFM will be considered successful if it meets these criteria:

1. **Scientific Rigor**: All analyses are statistically sound and ecologically meaningful
2. **Novelty**: Provides new insights beyond what was shown in previous reports
3. **Integration**: Successfully links vegetation data with land cover and management practices
4. **Applicability**: Generates useful recommendations for coastal dune conservation
5. **Quality**: Meets academic standards for Master's thesis in terms of structure and content
6. **Reproducibility**: Analysis code is well-documented and reproducible
