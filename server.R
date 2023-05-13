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
  # Filter the data based on selected methods
  subset_year_type <- subset(data, Discovery.Method %in% input$method)

  # Add frequencies
  year_method_frequency <- table(subset_year_type$Discovery.Year, subset_year_type$Discovery.Method)

  # Convert to data frame
  year_method_frequency_df <- data.frame(Year = as.integer(rownames(year_method_frequency)),
                                         Method = colnames(year_method_frequency),
                                         Frequency = as.vector(year_method_frequency))

  # Custom colors
  col_pal <- c("Astrometry" = "#BEBADA",
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

  # Generate the plot
  ggplot(year_method_frequency_df, aes(x = Year, y = Frequency, fill = Method)) +
    geom_bar(stat = "identity") +
    labs(title = "Nombre d'exoplanètes découvertes par année et par méthode",
         x = "Année",
         y = "Fréquence",
         fill = "Méthode de découverte") +
    scale_x_continuous(breaks = seq(1985, 2023, 5)) +
    scale_fill_manual(values = col_pal, guide = FALSE) +  # Set custom colors
    coord_cartesian(xlim = input$slider1)
})

  
  
  output$plot2 <- renderPlot({
    # Sous tableau
    subset_observatoire <- subset(data, select = c("Discovery.Facility"))
    # Ajout de fréquences
    observatoire_frequency <- table(subset_observatoire$Discovery.Facility)
    # Conversion en data frame
    year_method_frequency_df <- data.frame(Observatoire = rownames(observatoire_frequency),
                                           Frequency = as.vector(observatoire_frequency))
    data_filtered <- subset(year_method_frequency_df, Frequency <= input$slider2[1])
    
    # Create treemap chart
    ggplot(data_filtered, aes(area = Frequency, fill = Frequency, label = Observatoire)) +
      geom_treemap() +
      labs(title = "Nombre d'exoplanètes découvertes par observatoire",
           fill = "Nombre d'exoplanètes") +
      geom_treemap_text(place = "centre", size = 10, color = "white", na.rm = TRUE) 
  })
  
  output$plot3 <- renderPlot({
    # Subset data and remove rows with null values
    subset_3 <- subset(data, select = c("Stellar.Mass", "Stellar.Radius", "Equilibrium.Temperature"))
    subset_3 <- subset_3[complete.cases(subset_3),]
    
    data_filtered <- subset(subset_3, Stellar.Mass <= input$slider3 & Stellar.Radius <= input$slider4 & Equilibrium.Temperature <= input$slider5)
    
    ggplot(data_filtered, aes(x = Stellar.Mass, y = Stellar.Radius, color = Equilibrium.Temperature)) + 
      geom_point(size = 1.5) +
      geom_smooth(method = "lm", se = FALSE) +
      labs(x = "Masse", y = "Rayon") +
      scale_color_gradient(low = "blue", high = "red", limits = c(0, 5000),
                           breaks = c(0, 1000, 2000, 3000, 4000),
                           labels = c("0", "1000", "2000", "3000", "4000"))
  })
}
