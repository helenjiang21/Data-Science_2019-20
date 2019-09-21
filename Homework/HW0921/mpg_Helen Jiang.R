#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("MPG Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         selectInput("dropdown1", label = "Select Column",
                     choices = names(mpg))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("mpgPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$mpgPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
     library(ggplot2)
     ggplot(mpg, aes_string(x = "displ", y = input$dropdown1)) +
       geom_point(aes(color = class), show.legend = T)+
       geom_smooth(show.legend = F, se = F)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

