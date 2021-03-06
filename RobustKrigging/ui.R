#install.packages("shiny")
#install.packages("shinydashboard")

library(rstudioapi)

library(shiny)
library(shinydashboard)

shinyUI(
  dashboardPage(
    skin = "green",
    dashboardHeader(title = "Learn kriging 0.1", 
                    titleWidth = 200
    ),
    
    dashboardSidebar(width = 200,
                     sidebarMenu(id = 'sidebarmenu',
                                 menuItem('Introduction', 
                                          tabName = "Introduction"
                                 ),
                                 menuItem('Theory of kriging',
                                          menuSubItem('Variogram',
                                                      tabName = 'theory_variograms'
                                          ),
                                          menuSubItem('Kriging',
                                                      tabName = 'theory_kriging'
                                          ),
                                          menuSubItem('Robust variogram',
                                                      tabName = 'theory_rob_variograms'
                                          ),
                                          menuSubItem('Robust kriging',
                                                      tabName = 'theory_rob_kriging'
                                          )
                                 ),
                                 menuItem('Examples',
                                          
                                          menuSubItem('Classical kriging',
                                                      tabName = 'kriging_non_robust'
                                          ),
                                          
                                          menuSubItem('Robust kriging',
                                                      tabName = 'kriging_robust'
                                          ),
                                          menuSubItem('Used data',
                                                      tabName = 'used_data'
                                          )
                                 )
                                 
                     )
    ),
    dashboardBody(
      withMathJax(),
      tabItems(
        tabItem("Introduction", 
                includeHTML("./texts/introduction.html")
        ),
        
        tabItem("theory_variograms",
                includeHTML("./texts/theory_variograms.html")
        ),
        tabItem("theory_kriging",
                includeHTML("./texts/theory_kriging.html")
        ),
        tabItem("theory_rob_variograms",
                includeHTML("./texts/theory_rob_variograms.html")
        ),
        tabItem("theory_rob_kriging",
                includeHTML("./texts/theory_rob_kriging.html")
        ),
        tabItem("used_data",
                h2("Used data"),
                hr(),
                includeHTML("./texts/introduction_data.html")
        ),
        
        
        
        tabItem("kriging_non_robust", 
                h2("Classical kriging"),
                fluidRow(
                  box(width = 4, 
                      selectInput('vario_type', 
                                  label = 'Choose theoretical variogram:', 
                                  choices = c('Spherical',
                                              'Exponential',
                                              'Gaussian',
                                              'Cubic')
                      ),
                      hr(),
                      uiOutput("binSlider"),
                      hr(),
                      uiOutput("nugetSlider"),
                      hr(),

                      #hr(),
                      uiOutput("sillSlider"),
                      hr(),
                      uiOutput("rangeSlider")
                      
                      
                  ),
                  box(width = 4, 
                      plotOutput("variogram"),
                      checkboxInput('def_vario', 
                                    label = 'Draw default variogram', 
                                    value = FALSE),
                      plotOutput("nonrob_krig")
                  )
                )
        ),
        
        tabItem("kriging_robust", 
                h2("Robust kriging"),
                
                fluidRow(
                  box(width = 4, 
                      selectInput('variogram.model', 
                                  label = 'Choose theoretical variogram:', 
                                  choices = c('Spherical',
                                              'Exponential',
                                              'Gaussian',
                                              'Cubic')
                      ),
                      
                      hr(),
                      uiOutput("nugetSlider2"),
                      hr(),
                      uiOutput("sillSlider2"),
                      hr(),
                      uiOutput("rangeSlider2")
                      
                  ),
                  
                  
                  box(width = 7,
                      plotOutput("robustvariogram")),
                  plotOutput("rob_kriging"))
                
                )
                
                
                
                
        
        
        
        )
    
                
                
        
        
        
      
      
    )
  )
  
)