#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(rpart)
library(rpart.plot)

isGood <- function(df, quality = 6, alcohol = 0){
    resultGood <- 0
    
    if(df["quality"] >= quality){
        resultGood <- 1
    }
    
    if(alcohol > 0){
        if(df["alcohol"] != alcohol)
            resultGood <- 0
    }
    return(resultGood)
}

redefineGood <- function(p_quality = 6, p_alcohol = 0){
    redwine_df$good <<- apply(
        X       = redwine_df,
        FUN     = isGood,
        MARGIN  = 1,
        quality = p_quality,
        alcohol = p_alcohol
    )
    
    library(caTools)
    train_index <- sample.split(
        Y          = redwine_df$good,
        SplitRatio = 0.8
    )
    train_df <<- redwine_df[train_index, ]
    test_df  <<- redwine_df[!train_index, ]
}

filename   <- "winequality-red.csv"
redwine_df <- read.csv(filename)
redefineGood()

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$qualityTree <- renderPlot({
        
        if(input$anyAlcohol == "Any")
            i_alcohol <- 0
        else
            i_alcohol <- input$alcohol
        
        redefineGood(
            #p_quality = input$quality,
            p_alcohol = i_alcohol
        )
        
        tree_mod <- rpart(
            formula = good ~ fixed.acidity + volatile.acidity + citric.acid + residual.sugar + chlorides + free.sulfur.dioxide + total.sulfur.dioxide + density + pH + sulphates + alcohol,
            data    = train_df,
            method  = "class",
            cp      = 0.021
        )
        
        rpart.plot(
            x     = tree_mod,
            type  = 1,
            extra = 1,
            box.palette = "RdGn"
        )
    })
    
    output$scatterAlcohol <- renderPlotly({
        
        data <- redwine_df[, c(input$scatterVariable1, input$scatterVariable2, "good")]
        colnames(data) <- c("y1", "x1", "good")
        
        out_plot <- ggplot(
            data = data,
            aes(
                y     = y1,
                x     = x1,
                color = good
            )
        ) + geom_point() + ylab(input$scatterVariable1) + xlab(input$scatterVariable2)
        
        ggplotly(out_plot)
    })

})
