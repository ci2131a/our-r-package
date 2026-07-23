# Main

# required packages
library(shiny)
library(shinydashboard)
library(shinythemes)
library(shinyWidgets)
#library(ggplot2)


ui <- fluidPage(theme = shinytheme("sandstone"),
                
                # Application title
                titlePanel("Simulation of some stuff"),
                
                withMathJax(),
                
                # High level tabs  
                navbarPage("",
                           tabPanel(icon("home"),
                                    mainPanel(
                                      h1("Introduction", align = "left"),
                                      br(),
                                      p("This R Shiny App can be used to simulate data.
                     Enter parameters and view plots", style = "font-family: 'times'; font-size:16pt; color: black")
                                    )
                                    
                           ),
                           tabPanel("First",
                                    sidebarLayout(
                                      sidebarPanel(
                                        tags$head(tags$script('$(document).on("shiny:connected", function(e) {
                            Shiny.onInputChange("innerWidth", window.innerWidth);
                            });
                            $(window).resize(function(e) {
                            Shiny.onInputChange("innerWidth", window.innerWidth);
                            });
                            ')),
                                        numericInput("tsite","Number of Stuff", value = 100, min = 1, max = 1e+09),
                                        numericInput("tsamp","Number of Samples", value = 100, min = 1, max = 1e+05)
                                        ,
                                        width = 3
                                      ),
                                      mainPanel(
                                        tabsetPanel(
                                          tabPanel("Plot", plotOutput("plot1",width = "100%",height = "400px"))
                                        )
                                      )
                                    )
                           ),
                           tabPanel("Second",
                                    sidebarLayout(
                                      sidebarPanel(
                                        numericInput("tsite","Number of Stuff", value = 100, min = 1, max = 1e+09),
                                        numericInput("tsamp","Number of Samples", value = 100, min = 1, max = 1e+05)
                                        ,
                                        width = 3
                                      ),
                                      mainPanel(
                                        tabsetPanel(
                                          tabPanel("Plot", plotOutput("plot2", width = "100%",height = "400px"))
                                        )
                                      )
                                    )),
                           tabPanel("Third",
                                    sidebarLayout(
                                      sidebarPanel(
                                        numericInput("tsite","Number of Stuff", value = 100, min = 1, max = 1e+09),
                                        numericInput("tsamp","Number of Samples", value = 100, min = 1, max = 1e+05)
                                        ,
                                        width = 3
                                      ),
                                      mainPanel(
                                        tabsetPanel(
                                          tabPanel("Boxplot", plotOutput("plot3", width = "100%",height = "400px"))
                                        )
                                      )
                                    ))
                )
)


server <- function(input, output) {
  
  
  
  
  
}

#  Run
shinyApp(ui = ui, server = server)