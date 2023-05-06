#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(dplyr)

data <- read.csv("https://raw.githubusercontent.com/thomas-mauran/Exoplanets-R-visualization/main/data.csv")


# CHART 1
chart1 <- fluidRow(
  box(plotOutput("plot1"), width = 12),
  box(
    title = "Controls",
    splitLayout(
      sliderInput(
        "slider2",
        label = h3("Discover year range"),
        min = 1985,
        max = 2023,
        value = c(1985, 2023),
        sep = "",
        animate = TRUE
      ),
      div(
        checkboxGroupInput(
          "method",
          label = h3("Discovery Method"),
          choices = sort(unique(data$Discovery.Method)),
          selected = unique(data$Discovery.Method),
        ),
        style = "margin: 0px 20px;"
      ),
      cellWidths = c("70%", "30%"),
    ),
    width = 12
  ),
)

# SIDEBAR
sidebar <- dashboardSidebar(
  tags$style(".sidebar-menu li a {font-size: 1.2em;}"),
  sidebarMenu(
    menuItem("Number / year", tabName = "chart1", icon = icon("chart-column")),
    menuItem("Discover Facility", tabName = "chart2", icon = icon("chart-simple")),
    menuItem("Stellar mass and radius", tabName = "chart3", icon = icon("chart-column"))
  )
)

# BODY
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "chart1",
            chart1
    ),
    tabItem(tabName = "chart2",
            h2("chart2")
    )
  )
)


# PAGE
dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Exoplanet datavis"),
  sidebar,
  body
)
