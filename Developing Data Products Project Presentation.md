Developing Data Products Project Presentation
========================================================
author: Anirban Dhar
date: 05/08/2016

Projct Presentation Overview
========================================================

This presentation is being created to prepare a reproducible pitch on Storm Data Base Explorer application created using Shiny as part of Developing Data Product Course Project. The presentation will have 3 parts:

- Basic overview of the application 
- Sample code snippet in R
- Sample plotting code in R

Storm Database Explorer Application
========================================================

Storm Database Explorer Application has been developed using Shiny. This application is based on the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database. Dataset has been obtained from the Coursera site:

- You can use the slider to select a date range for the application 

- Check boxes can be used to select event types

- The graphs are displayed by state and by year. You can draw the charts based on population impact or economic impact by selecting from the menu on the right hand side

- You can also look at the data set by state

Sample Data
========================================================


```
       YEAR        STATE             EVTYPE COUNT FATALITIES INJURIES
    1: 1950      alabama            TORNADO     2          0       15
    2: 1951      alabama            TORNADO     5          0       13
    3: 1952      alabama            TORNADO    13          6      116
    4: 1953      alabama            TORNADO    22         16      248
    5: 1954      alabama            TORNADO    10          0       36
   ---                                                               
17610: 2011     nebraska           WILDFIRE     1          0        0
17611: 2011        idaho DUST STORM / DEVIL     3          0        0
17612: 2011   new mexico              FLOOD     1          0        0
17613: 2011    tennessee           WILDFIRE     1          0        0
17614: 2011 south dakota            DROUGHT     1          0        0
       PROPDMG CROPDMG
    1: 0.02750       0
    2: 0.03500       0
    3: 5.45250       0
    4: 3.07000       0
    5: 0.60753       0
   ---                
17610: 1.00000       5
17611: 0.00500       0
17612: 0.00000       0
17613: 0.10000       0
17614: 0.00000       0
```

Sample Code to Read Data
========================================================

```r
library(rCharts)
library(data.table)
library(reshape2)

dataset <- fread('data/events.agg.csv')
dataset.agg.year <- dataset[, list(Count=sum(COUNT), Injuries=sum(INJURIES), Fatalities=sum(FATALITIES)), by=list(YEAR)]
dataset
```

```
       YEAR        STATE             EVTYPE COUNT FATALITIES INJURIES
    1: 1950      alabama            TORNADO     2          0       15
    2: 1951      alabama            TORNADO     5          0       13
    3: 1952      alabama            TORNADO    13          6      116
    4: 1953      alabama            TORNADO    22         16      248
    5: 1954      alabama            TORNADO    10          0       36
   ---                                                               
17610: 2011     nebraska           WILDFIRE     1          0        0
17611: 2011        idaho DUST STORM / DEVIL     3          0        0
17612: 2011   new mexico              FLOOD     1          0        0
17613: 2011    tennessee           WILDFIRE     1          0        0
17614: 2011 south dakota            DROUGHT     1          0        0
       PROPDMG CROPDMG
    1: 0.02750       0
    2: 0.03500       0
    3: 5.45250       0
    4: 3.07000       0
    5: 0.60753       0
   ---                
17610: 1.00000       5
17611: 0.00500       0
17612: 0.00000       0
17613: 0.10000       0
17614: 0.00000       0
```


Sample Code to Generate Plots
========================================================

```r
data <- melt(dataset.agg.year[, list(YEAR=YEAR, Injuries=Injuries, Fatalities=Fatalities)], id='YEAR')
impact2population <- nPlot(
    value ~ YEAR, group = 'variable', data = data[order(-YEAR, variable, decreasing = T)],
    type = 'stackedAreaChart', dom = 'populationImpact'
)
        
impact2population$chart(margin = list(left = 100))
impact2population$yAxis( axisLabel = "Affected", width = 80)
impact2population$xAxis( axisLabel = "Year", width = 70)
impact2population
```

```
<iframe src=' Developing Data Products Project Presentation-figure/nvd3plot2-1.html ' scrolling='no' frameBorder='0' seamless class='rChart nvd3 ' id=iframe- populationImpact ></iframe> <style>iframe.rChart{ width: 100%; height: 400px;}</style>
```

