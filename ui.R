library(shiny)

# Define UI for application
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Predict Survival rate on the Titanic"),
    
    # Sidebar
    sidebarLayout(
        sidebarPanel(
            h3("Input Parameters"),
            helpText("Please enter the following information below to measure 
                     the survival rate of the passenger."),
            selectInput("Pclass", label = "Passenger Class",
                        choices = list("Upper"=1, "Middle"=2,
                                       "Lower"=3), selected=1),
            sliderInput("Age", label = "Age", min=1, max=100, value=25),
            sliderInput("SibSp", label = "Number of Siblings/Spouses Abroad", 
                        min=0, max=10, value=0),
            sliderInput("Parch", label = "Number of Parents/Children Abroad", 
                        min=0, max=10, value=0),
            numericInput("Fare", label = "Passenger Fare", value=15)
#             submitButton("Submit")
        ),
        
        # Display the results
        mainPanel(
            h3("Getting started", style="color:#01A9DB"),
            p("1. On the left sidebar, you can change the input parameters."),
            p("2. Then, the results will automatically calculate how likely to 
              survive or die depend on the characteristics of the passenger you 
              specified in the left sidebar."),
            h3("Results", style="color:#01A9DB"),
            h4(textOutput("textSurvived"), style="color:#FA5858"),
            helpText("Note: The above text will display as 'likely to survive' 
                     when the survival rate is more than 50%"),
            h4(textOutput("textProb"), style="color:#FA5858"),
            plotOutput("plotSurvived"),
            
            h3("Documentation", style="color:#01A9DB"),
            h4("Background:"),
            p("The sinking of the RMS Titanic is one of the most infamous 
              shipwrecks in history.  On April 15, 1912, during her maiden 
              voyage, the Titanic sank after colliding with an iceberg, 
              killing 1502 out of 2224 passengers and crew. This sensational 
              tragedy shocked the international community and led to better 
              safety regulations for ships."),
            h4("Overview:"),
            p("This data product provides the basic model to predict the 
              probability that the passengers on the Titanic will survive. 
              Additionally, the data used to train this model is on Kaggle's 
              Titanic challenge, which you can download from Kaggles's page."),
            a(">> Titanic: Machine Learning from Disaster", 
              href = "https://www.kaggle.com/c/titanic"),
            br(),
            br(),
            p("The technique that used to build this model called 'the Logistic 
              Regression'. For more information, please visit the following 
              link:"),
            a(">> Logistic regression", 
              href = "http://en.wikipedia.org/wiki/Logistic_regression"),
            br()
        )
    )
))