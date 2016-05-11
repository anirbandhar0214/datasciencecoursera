#Create Storm Database Explorer Application using Shiny
library(shiny)
library(rCharts)

shinyUI(
    navbarPage("Storm Database Explorer",
        tabPanel("Plot",
                sidebarPanel(
                    sliderInput("range", 
                        "Slide Range:", 
                        min = 1990, 
                        max = 2011, 
                        value = c(1990, 2011),
                        format="####"),
                    uiOutput("evtypeControls"),
                    actionButton(inputId = "clear_all", label = "Clear All Selection", icon = icon("check-square")),
                    actionButton(inputId = "select_all", label = "Select All", icon = icon("check-square-o"))
                ),
  
                mainPanel(
                    tabsetPanel(
                        
                        # Select data by state
                        tabPanel(p(icon("map-marker"), "By state"),
                            column(3,
                                wellPanel(
                                    radioButtons(
                                        "populationCategory",
                                        "Population impact category:",
                                        c("Both" = "both", "Injuries" = "injuries", "Fatalities" = "fatalities"))
                                )
                            ),
                            column(3,
                                wellPanel(
                                    radioButtons(
                                        "economicCategory",
                                        "Economic impact category:",
                                        c("Both" = "both", "Property damage" = "property", "Crops damage" = "crops"))
                                )
                            ),
                            column(7,
                                plotOutput("populationImpactByState"),
                                plotOutput("economicImpactByState")
                            )

                        ),
                        
                        # Select time series data
                        tabPanel(p(icon("line-chart"), "By year"),
                                 h4('Number of events by year', align = "center"),
                                 showOutput("eventsByYear", "nvd3"),
                                 h4('Population impact by year', align = "center"),
                                 showOutput("populationImpact", "nvd3"),
                                 h4('Economic impact by year', align = "center"),
                                 showOutput("economicImpact", "nvd3")
                        ),
                        

                        
                        # Create Data Table Output
                        tabPanel(p(icon("table"), "Data"),
                            dataTableOutput(outputId="table"),
                            downloadButton('downloadData', 'Download')
                        )
                    )
                )
            
        ),
        
        tabPanel("About",
            mainPanel(
                includeMarkdown("include.md")
            )
        )
    )
)
