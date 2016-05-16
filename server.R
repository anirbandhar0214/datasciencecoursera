library(shiny)
library(rsconnect)


# Load Plotting Libraries
library(ggplot2)
library(rCharts)
library(ggvis)

# Load Data Processing Libraries
library(data.table)
library(reshape2)
library(dplyr)

# Load Markdown Library
library(markdown)

# Load Maps Libraries
library(mapproj)
library(maps)

# Load helper.R
source("helpers.R", local = TRUE)


# Load Storms Dataset
states_map <- map_data("state")
#datafile <- fread('data/events.agg.csv') %>% mutate(EVTYPE = tolower(EVTYPE))
datafile <- fread('events.agg.csv') %>% mutate(EVTYPE = tolower(EVTYPE))
eventTypes <- sort(unique(datafile$EVTYPE))


# Craete Shiny server function
shinyServer(function(input, output, session) {
    
    # Initialize reactive values
    values <- reactiveValues()
    values$eventTypes <- eventTypes
    
    # Create various event types check box
    output$evtypeControls <- renderUI({
        checkboxGroupInput('eventTypes', 'Event types', eventTypes, selected=values$eventTypes)
    })
    
    # Add observer function on buttons
    observe({
        if(input$clear_all == 0) return()
        values$eventTypes <- c()
    })
    
    observe({
        if(input$select_all == 0) return()
        values$eventTypes <- eventTypes
    })
    
    # Create maps dataset 
    datafile.agg <- reactive({
        aggregate_by_state(datafile, input$range[1], input$range[2], input$eventTypes)
    })
    
    # Create time series dataset 
    datafile.agg.year <- reactive({
        aggregate_by_year(datafile, input$range[1], input$range[2], input$eventTypes)
    })
    
    # Prepare downloads datasets 
    dataTable <- reactive({
        prepare_downolads(datafile.agg())
    })
    
     
    # Create population impact by state plot
    output$populationImpactByState <- renderPlot({
        print(plot_impact_by_state (
            datafile = compute_affected(datafile.agg(), input$populationCategory),
            states_map = states_map, 
            year_min = input$range[1],
            year_max = input$range[2],
            title = "Population impact %d - %d (number of affected)",
            fill = "Affected"
        ))
    })
    
    # Crate economic impact by state plot
    output$economicImpactByState <- renderPlot({
        print(plot_impact_by_state(
            datafile = compute_damages(datafile.agg(), input$economicCategory),
            states_map = states_map, 
            year_min = input$range[1],
            year_max = input$range[2],
            title = "Economic impact %d - %d (Million USD)",
            fill = "Damages"
        ))
    })
    
    # Create events by year plot
    output$eventsByYear <- renderChart({
       plot_events_by_year(datafile.agg.year())
    })
    
    # Output population impact
    output$populationImpact <- renderChart({
        plot_impact_by_year(
            datafile = datafile.agg.year() %>% select(Year, Injuries, Fatalities),
            dom = "populationImpact",
            yAxisLabel = "Affected",
            desc = TRUE
        )
    })
    
    # Output economic impact 
    output$economicImpact <- renderChart({
        plot_impact_by_year(
            datafile = datafile.agg.year() %>% select(Year, Crops, Property),
            dom = "economicImpact",
            yAxisLabel = "Total damage (Million USD)"
        )
    })
    
    # Write data table
    output$table <- renderDataTable(
        {dataTable()}, options = list(bFilter = FALSE, iDisplayLength = 100))
    
    output$downloadData <- downloadHandler(
        filename = 'data.csv',
        content = function(file) {
            write.csv(dataTable(), file, row.names=FALSE)
        }
    )
})


