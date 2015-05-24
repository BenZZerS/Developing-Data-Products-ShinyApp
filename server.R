library(shiny)
library(caret)
library(ggplot2)

# Read data and preprocessing
titanicDf <- read.csv("titanicTrain.csv",header = TRUE, )

dataDf <- subset(titanicDf, select = c(Survived, Pclass, Sex, Age, SibSp, Parch, Fare))
dataDf$Pclass1 <- (dataDf$Pclass == 2) * 1
dataDf$Pclass2 <- (dataDf$Pclass == 3) * 1
dataDf <- dataDf[, -2]
dataDf$Sex <- as.numeric((dataDf$Sex == "female") * 1)
dataDf <- dataDf[complete.cases(dataDf), ]

inTrain <- createDataPartition(dataDf$Survived, p=0.9, list=FALSE)
trainDf <- dataDf[inTrain, ]
testDf <- dataDf[-inTrain, ]

# Create the model
model <- glm(Survived ~ Age + SibSp + Parch + Fare + Pclass1 + Pclass2, 
           data=trainDf, family=binomial())
cutoff <- 0.50

# Define server logic
shinyServer(function(input, output) {
    
    p <- reactive({
        Pclass1 <- (input$Pclass == 2) * 1
        Pclass2 <- (input$Pclass == 3) * 1
        inputDf <- data.frame(Age = as.numeric(input$Age),
                              SibSp = as.numeric(input$SibSp),
                              Parch = as.numeric(input$Parch),
                              Fare = as.numeric(input$Fare), 
                              Pclass1 = Pclass1,
                              Pclass2 = Pclass2)
        predict(model, newdata = inputDf, type="response")
    })
    output$textSurvived <- renderText({
        if(p() >= cutoff)
            "Likely to survive"
        else
            "Likely to die"
    })
    output$textProb <- renderText({
        paste("Probability that the passenger will survive is ", 
              round(p()*100,2), "%", sep="")
    })
    output$plotSurvived <- renderPlot({
        sPer <- round(p()*100,0)
        probDf <- data.frame(survived = c(rep("% Survived", sPer), 
                                          rep("% Dead", 100-sPer)))
        p <- ggplot(probDf, aes(x=factor(1), fill=factor(survived)))
        p <- p + geom_bar(width=1)
        p <- p + coord_polar(theta="y")
        p <- p + xlab("")
        p <- p + ylab("Survival Rate")
        p
    })
})