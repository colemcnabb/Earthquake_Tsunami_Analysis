# Earthquake and Tsunami Analysis

## Overview
Analysis of global earthquake and tsunami data from 1950 to present, exploring patterns, impacts and relationships between these natural disasters. The analyses were performed separately to provide a clear understanding of each disaster.

---

## Purpose
The goal of this analysis was to explore global earthquake and tsunami data over the past 75 years, focusing on patterns in frequency, geographical occurrence and human impact. By cleaning and analyzing NOAA datasets, this project aims to uncover key insights into when and where these disasters occur, and which events have been the most destructive.

---

## Tools Used
- MySQL: Data cleaning and analysis.
- Tableau: Data visualization and dashboard creation.
- Excel: Initial data exploration.

---

## Data Sources
- Earthquake Data: NOAA Global Significant Earthquake Database (1950 - 2025)
- Tsunami Data: NOAA Global Historical Tsunami Database (1950 - 2025)

---

## Key Insights

1. **Earthquake Analysis**:
    - The number of reported earthquakes has increased since 1950, though this may be attributed to improved detection, particularly over the last two decades.
    - Major earthquakes (≥7.0 magnitude) had higher average casualties but several moderate earthquakes were among the deadliest likely due to population density.
    - The deadliest earthquakes were not always the strongest in magnitude, emphasizing the importance of infrastructure and preparedness.

2. **Tsunami Analysis**:
    - Tsunami activity fluctuated over time, with a higher number of recorded events in recent decades.
    - A small number of events were responsible for the vast majority of tsunami-related casualties, highlighting the extreme impact of rare, catastrophic incidents.
    - Interestingly, there were increased historical reports during the months of March and July, pointing to a potential impact that seasonality has with tsunami prevalence.

---

## Tableau Dashboards
- [Earthquake Dashboard](https://public.tableau.com/views/EarthquakeAnalysis1950-2025/EarthquakeAnalysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
- [Tsunami Dashboard](https://public.tableau.com/views/TsunamiAnalysis1950-2025/TsunamiAnalysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

## Dashboard Previews

### Tsunami Analysis
![Tsunami Dashboard](LINK here)

### Earthquake Analysis
![Earthquake Dashboard](LINK here)

---

## Repository Structure
- `data/` -> Raw and cleaned CSV
- `Scripts/` -> SQL cleaning and analysis
- `visuals/` -> Dashboard preview PNGs
- `README.md` -> Project overview
