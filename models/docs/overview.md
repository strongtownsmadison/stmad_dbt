{% docs __overview__ %}
# Strong Towns Madison dbt Project Overview

## Project Purpose
The primary objective of this dbt project is to centralize and transform municipal data for comprehensive analysis by Strong Towns Madison members, with a specific focus on urban infrastructure and spatial information.

## Data Sources
- **Primary Focus**: City of Madison municipal data
- **Key Focus Areas**: 
 - Streets
 - Parcels
 - Geospatial overlays

## Database Configuration
- **Database**: PostgreSQL
- **Geospatial Extension**: PostGIS
- **Enables**: Advanced spatial data analysis and transformations

## Project Schema Structure

### Staging Schema
- **Purpose**: Data cleaning and initial transformation
- Prepares raw data for further processing and analysis
- Implements initial data quality checks and standardization

### Public Schema
- **Purpose**: Contains final fact tables for analysis
- Provides clean, transformed data ready for member insights
- Structured for easy querying and visualization

## Geospatial Analysis Capabilities
- Geometry overlay techniques
- Analysis of:
 - Area plans
 - Alder districts
 - Spatial relationships between municipal data points

## Contact Information
**Person**: Ben Noffke
**Email**: bnoffke3790@gmail.com
- For project suggestions
- To report issues
- To discuss data analysis needs

## Recommended Next Steps
1. Review staging transformations
2. Validate public schema fact tables
3. Develop additional geospatial analysis models
{% enddocs %}