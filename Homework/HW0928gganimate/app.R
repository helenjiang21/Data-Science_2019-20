library(shiny)
library(tidyverse)
# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("MPG Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("dropdown1", label = "Select y axis",
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
  
  output$mpgPlot <- renderImage({
    # generate bins based on input$bins from ui.R
    library(ggplot2)
    library(gganimate)
    anim <- ggplot(mpg, aes_string(x = "displ", y = input$dropdown1)) +
      geom_point(aes(color =  class, group = 1L)) +
      transition_states(class, transition_length = 1, state_length = 1) +
      ease_aes("cubic-in-out") +
      ggtitle("Now showing {closest_state}")
    anim_save("mpg.gif", animate(anim))
    list(src = "outfile.gif",
         contentType = 'image/gif'
    )})}

# Run the application 
shinyApp(ui = ui, server = server)


