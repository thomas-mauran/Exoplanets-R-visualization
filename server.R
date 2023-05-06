#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(treemapify)
library(RColorBrewer)

data <- read.csv("https://raw.githubusercontent.com/thomas-mauran/Exoplanets-R-visualization/main/data.csv")

# Define server logic required to draw a histogram
function(input, output, session) {
  
  output$plot1 <- renderPlot({
    # Sous tableau
    subset_year_type <- subset(data, Discovery.Method %in% input$method)
    # Ajout de fréquences
    year_method_frequency <- table(subset_year_type$Discovery.Year, subset_year_type$Discovery.Method)
    
    # Conversion en data frame
    year_method_frequency_df <- data.frame(Year = as.integer(rownames(year_method_frequency)),
                                           Method = colnames(year_method_frequency),
                                           Frequency = as.vector(year_method_frequency))
    # Colors 
    # Generate a rainbow color palette with 11 colors
    col_pal <- c("strometry" = "#BEBADA",
                 "Disk Kinematics" = "#8DD3C7",
                 "Eclipse Timing Variations" = "#80B1D3",
                 "Imaging" = "#FDB462",
                 "Microlensing" = "#B3DE69",
                 "Orbital Brightness Modulation" = "#FCCDE5",
                 "Pulsar Timing" = "#D9D9D9",
                 "Pulsation Timing Variations" = "#BC80BD",
                 "Radial Velocity" = "#CCEBC5",
                 "Transit" = "#FFED6F",
                 "Transit Timing Variations" = "#FFFFB3")
    
    
    # Gaphique
    ggplot(year_method_frequency_df, aes(x = Year, y = Frequency, fill = Method)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(values = col_pal) +
      labs(title = "Nombre d'exoplanètes découvertes par année et par méthode",
           x = "Année",
           y = "Fréquence",
           fill = "Méthode de découverte") +
      scale_x_continuous(breaks = seq(1985, 2023, 5)) +
    coord_cartesian(xlim = input$slider2)
  })
}
