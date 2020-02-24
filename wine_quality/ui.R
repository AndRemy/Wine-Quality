#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(plotly)
library(shiny)
library(shinydashboard)

shinyUI(
    dashboardPage(
        header  = dashboardHeader(
            title = "Red Wine Analysis"
        ),
        sidebar = dashboardSidebar(
            sidebarMenu(
                menuItem(
                    "Graphs",
                    tabName = "graphs"
                ),
                menuItem(
                    "Quality Decision Tree",
                    tabName = "decisionTree"
                ),
                menuItem(
                    "About",
                    tabName = "about"
                )
            )
        ),
        body    = dashboardBody(
            tabItems(
                tabItem(
                    tabName = "graphs",
                    fluidPage(
                        titlePanel("Relationship between red wine properties"),
                        sidebarPanel(
                            selectInput(
                                inputId  = "scatterVariable1",
                                label    = "Select first variable (Y-axis)",
                                choices  = c("fixed.acidity", "volatile.acidity", "citric.acid", "residual.sugar", "chlorides", "free.sulfur.dioxide", "total.sulfur.dioxide", "density", "pH", "sulphates", "alcohol", "quality"),
                                selected = "fixed.acidity"
                            ),
                            selectInput(
                                inputId  = "scatterVariable2",
                                label    = "Select second variable (X-axis)",
                                choices  = c("fixed.acidity", "volatile.acidity", "citric.acid", "residual.sugar", "chlorides", "free.sulfur.dioxide", "total.sulfur.dioxide", "density", "pH", "sulphates", "alcohol", "quality"),
                                selected = "volatile.acidity"
                            )
                        ),
                        mainPanel(
                            plotlyOutput("scatterAlcohol")
                        )
                    )
                ),
                tabItem(
                    tabName = "decisionTree",
                    fluidPage(
                        titlePanel("Red Wine Quality Model"),
                        sidebarPanel(
                            radioButtons(
                                inputId       = "anyAlcohol",
                                label         = "Any preferred alcohol?",
                                choices       = c("Any", "Specific")
                            ),
                            sliderInput("alcohol",
                                        "Specify Alcohol Level:",
                                        min   = 9,
                                        max   = 12,
                                        value = 10,
                                        step  = 0.2,
                                        
                            ),
                        ),
                        mainPanel(
                            plotOutput("qualityTree"),
                            h5("*Assumption: Good wine has a quality greater or equal than 6")
                        )
                    )
                ),
                tabItem(
                    tabName = "about",
                    fluidPage(
                        h4("Version: 1.0.0"),
                        h4("Created by: Andre Remy"),
                        h4("Creation Date: January 11th, 2020"),
                        h4("Source: UCI Machine Learning Repository"),
                        h4("Source URL: https://archive.ics.uci.edu/ml/datasets/Wine+Quality")
                    )
                )
            )
        )
    )
)
