# Earthquake and Tsunami Analysis

## Overview

- This project cleans and analyzes NOAA earthquake and tsunami data (1950-2025) to uncover long-term trends in frequency, geography, and human impact. Separate workflows for each disaster ensure clear, focused insights. 

---

## Technical Stack

| Stage         | Tool      |
|---------------|-----------|
| Data cleaning | MySQL     |
| Exploration   | Excel     |
| Dashboards    | Tableau Public |

---

## Data Sources
- **Earthquake Data:** [NOAA Global Significant Earthquake Database (1950 - 2025)](https://www.ngdc.noaa.gov/hazel/view/hazards/earthquake/event-data?minYear=1950)
- **Tsunami Data:** [NOAA Global Historical Tsunami Database (1950 - 2025)](https://www.ngdc.noaa.gov/hazel/view/hazards/tsunami/event-data?minYear=1950)

---

## Key Insights

1. **Earthquake Analysis**:
    - Reports rise post-1950, likely due to improved detection, especially in the last two decades.
    - Major earthquakes (≥7.0 magnitude) average higher casualties, yet several moderate events rank among the deadliest due to population density. 
    - The deadliest earthquakes were not always the strongest in magnitude, emphasizing the importance of infrastructure and preparedness.

2. **Tsunami Analysis**:
    - Event frequency fluctuates, with more recorded tsunamis in recent decades.
    - A handful of catastrophic incidents account for most tsunami-related casualties.
    - March and July show noticeable spikes in recorded tsunamis, hinting at seasonal drivers. 

---

## Tableau Dashboards
- [Earthquake Dashboard](https://public.tableau.com/views/EarthquakeAnalysis1950-2025/EarthquakeAnalysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
- [Tsunami Dashboard](https://public.tableau.com/views/TsunamiAnalysis1950-2025/TsunamiAnalysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

---

## Dashboard Previews

### Earthquake Analysis
![Earthquake Dashboard](/visuals/Earthquake_Analysis.png)

### Tsunami Analysis
![Tsunami Dashboard](/visuals/Tsunami_Analysis.png)

---

## Repository Structure
- `data/` -> Raw and cleaned CSV
- `Scripts/` -> SQL cleaning and analysis
- `visuals/` -> Dashboard preview PNGs
- `README.md` -> Project overview
