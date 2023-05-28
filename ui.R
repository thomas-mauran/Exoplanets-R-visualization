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
  h1("Nombre d'éxoplanètes découvertes par année et méthode de découvertes"),
  box(plotOutput("plot1"), width = 12),
  box(
    splitLayout(
      sliderInput(
        "slider1",
        label = h3("Range d'année de découverte"),
        min = 1985,
        max = 2023,
        value = c(1985, 2023),
        sep = "",
        animate = TRUE
      ),
    ),
    width = 12
  )
)

# CHART 2
chart2 <- fluidRow(
  h1("Quels sont les observatoires qui découvrent le plus d'exoplanètes ?"),
  box(plotOutput("plot2"), width = 12),
  
  box(
    sliderInput(
      "slider2",
      label = h3("Nombre maximum d'exoplanètes découvertes"),
      min = 1,
      max = 2500,
      value =2500,
      sep = "",
      animate = TRUE
    ),
     width = 12
  ),
)

# Chart 3
chart3 <- fluidRow(
  h1("Y a-t-il un lien entre la masse stélaire et le rayon des exoplanètes?"),
  box(plotOutput("plot3"), width = 12),
  box(
    column(width = 6,
           sliderInput(
             "slider3",
             label = h3("Masse stélaire maximum"),
             min = 0.1,
             max = 3,
             value = 3,
             sep = "",
             animate = TRUE
           )
    ),
    column(width = 6,
           sliderInput(
             "slider4",
             label = h3("Rayon maximum"),
             min = 0.1,
             max = 7,
             value = 7,
             sep = "",
             animate = TRUE
           )
    ),
    width = 12
  ),
  box(
    sliderInput(
      "slider5",
      label = h3("Température d'équilibre maximum"),
      min = 0.1,
      max = 5000,
      value = 5000,
      sep = "",
      animate = TRUE
    ),
    width = 12
  )
)


# CHART 4
chart4 <- fluidRow(
  h1("Quels sont les observatoires qui découvrent le plus d'exoplanètes ?"),
  box(plotOutput("plot4"), width = 12),
  
  box(
    checkboxGroupInput("checkboxes", "Select options:",
                       choices = c("Disk Kinematics", "Eclipse Timing Variations", "Imaging", "Microlensing", "Orbital Brightness Modulation", "Pulsar Timing",  "Radial Velocity", "Transit Timing Variations"),
                       selected = c("Disk Kinematics", "Eclipse Timing Variations", "Imaging", "Microlensing", "Orbital Brightness Modulation", "Pulsar Timing", "Radial Velocity",  "Transit Timing Variations")),
    width = 12
  ),
)


# Rapport
rapport <- fluidRow(
  tags$object(style="height:600px; width:100%", data="./exoplanet-markdown.pdf", type="application/pdf")
)

# SIDEBAR
sidebar <- dashboardSidebar(
  tags$style(".sidebar-menu li a {font-size: 1.2em;}"),
  sidebarMenu(
    menuItem("Rapport", tabName = "rapport", icon = icon("chart-column")),
    menuItem("Number / year", tabName = "chart1", icon = icon("chart-column")),
    menuItem("Discover Facility", tabName = "chart2", icon = icon("chart-column")),
    menuItem("Stellar mass and radius", tabName = "chart3", icon = icon("chart-column")),
    menuItem("Method / distance", tabName = "chart4", icon = icon("chart-column"))
  )
)


# BODY
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "rapport",
            
              tags$iframe(style = "height: 100vh; width:100%", src="exoplanets-markdown.pdf")
            
    ),
    tabItem(tabName = "chart1",
            chart1),
    tabItem(tabName = "chart2",
            chart2),
    tabItem(tabName = "chart3",
            chart3),
    tabItem(tabName = "chart4",
            chart4)
  )
)


# PAGE
dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Exoplanet datavis"),
  sidebar,
  body
)
