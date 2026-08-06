# 🗺️ Urban Accessibility and Socioeconomic Data Analysis - Curitiba

An R-based framework for processing, integrating, and analyzing spatial, census (IBGE), and employment (RAIS) data to study how public transit accessibility affects labor market performance in the Metropolitan Region of Curitiba, Brazil.

---

## 📋 Table of Contents



---

## 💻 About the Project

This repository contains the R scripts and spatial workflows developed for academic and urban economics research (such as master's theses and academic essays). The main goal is to compute **cumulative and gravitational accessibility indicators** for public transportation, mapping socioeconomic inequalities, job densities across different sectors (industry, commerce, and services), and household income distribution by quartiles.

---

## ✨ Features

- **Spatial Data Manipulation:** Loading, projecting, and converting geometric layers and spatial file formats (`sf`, `gpkg`, `shapefiles`).
- **Accessibility Indicators:** Implementation of public transit travel-time matrices to calculate cumulative and gravity-based accessibility metrics.
- **Socioeconomic Data Integration:** Merging and filtering geocoded formal employment microdata (RAIS) with IBGE census tracts.
- **Interactive Mapping:** Generating thematic maps for employment density and spatial distribution using the `mapview` library.
- **Data Visualization:** Plotting curves for linear distance to the Central Business District (CBD) and income-based inequality bar charts via `ggplot2`.

---

## 🛠️ Technologies & Libraries

The entire pipeline is built using **R** and leverages the following core ecosystem:

- **Data Manipulation:** `tidyverse` (dplyr, ggplot2, purrr, tidyr), `plyr`, `haven`, `foreign`.
- **Spatial Analysis (GIS):** `sf`, `sp`, `nngeo`, `areal` (spatial interpolation), `rgdal`.
- **Official Data API Wrappers:** `geobr` (official shapefiles for Brazil), `aopdata`.
- **Visualization:** `mapview`, `RColorBrewer`.

---

## 📊 Data Sources

To run the script completely, you will need the following datasets (which are not hosted directly in this repository due to file size constraints):
1. **IPPUC:** Origin-Destination Survey data for Curitiba.
2. **IBGE (2010 Census):** Synopsis and basic variables by census tract for the state of Paraná.
3. **RAIS (2017):** Geocoded microdata of formal employment records.
4. **Travel Time Matrices & GTFS:** Operational transit metrics and system network parameters.

---

## 🚀 Getting Started

### Prerequisites

You will need [R](https://r-project.org) installed on your machine. Using an IDE like [RStudio](https://posit.co) is highly recommended.

### Installation

Open your R console or RStudio and install the required packages:

```R
install.packages(c("tidyverse", "sf", "mapview", "geobr", "aopdata", 
                   "haven", "foreign", "RColorBrewer", "areal", "plyr"))
```

### Execution & File Paths

1. Clone this repository to your local machine.
2. Open the main `.R` script file.
3. **Important Note:** The original script references absolute data directories on a local drive (e.g., `D:/Economia/...`). You **must update** these file paths (`read_dta`, `read_excel`, `st_read`) to point to the directory where you have stored your local data inputs before running the pipeline.
4. Execute the script sequentially or load it via `source("script_name.R")`.

---

## 📁 Code Architecture

The script structure is divided into the following logical processing blocks:

- **Data Loading & Coordinate Adjustments:** Reads relational tables and standardizes Spatial Reference Systems (CRS) to Sirgas 2000 or UTM Zone 22S.
- **Employment Processing (RAIS):** Classifies commercial activity into Industry, Commerce, and Services using CNAE codes.
- **Accessibility Metrics Calculation:** Grouping, spatial interpolation (`aw_interpolate`), and matrix calculations across public transit networks.
- **Custom Indicators (`dtransit` & `mode_share`):** Aggregates travel indices and public vs. private modal split stratified by income brackets.
- **Plotting & Analytics:** Generates charts demonstrating population distribution as a factor of distance to Curitiba's CBD.

