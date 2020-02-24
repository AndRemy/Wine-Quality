setwd("C:/Users/Andre/Documents/AndRemy/Sandbox/Wine Quality/")
filename <- "winequality-red.csv"
redwine_df <- read.csv(filename)

ggplot(
  redwine_df,
  aes(
    y = quality
  )
) + geom_boxplot()

hist(redwine_df$quality)

max(redwine_df$quality)

isGood <- function(df, quality = 7, alcohol = 0){
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

redwine_df$good <- apply(
  X       = redwine_df,
  FUN     = isGood,
  MARGIN  = 1,
  quality = 7,
  alcohol = 0
)

library(caTools)
train_index <- sample.split(
  Y          = redwine_df$good,
  SplitRatio = 0.8
)
train_df <- redwine_df[train_index, ]
test_df  <- redwine_df[!train_index, ]

logit_mod <- glm(
  formula = good ~ fixed.acidity + volatile.acidity + citric.acid + residual.sugar + chlorides + free.sulfur.dioxide + total.sulfur.dioxide + density + pH + sulphates + alcohol,
  data = train_df,
  family = "binomial"
)
summary(logit_mod)

logit_mod <- glm(
  formula = good ~ fixed.acidity + volatile.acidity + residual.sugar + chlorides + total.sulfur.dioxide + density + sulphates + alcohol,
  data = train_df,
  family = "binomial"
)
summary(logit_mod)

logit_predict <- predict(
  object   = logit_mod,
  newdata  = test_df,
  response = "response"
)

library(rpart)
library(rpart.plot)

tree_mod <- rpart(
  formula = good ~ fixed.acidity + volatile.acidity + citric.acid + residual.sugar + chlorides + free.sulfur.dioxide + total.sulfur.dioxide + density + pH + sulphates + alcohol,
  data    = train_df,
  method  = "class"
)

plotcp(tree_mod)

rpart.plot(
  x     = tree_mod,
  type  = 1,
  extra = 1,
  tweak = 3.5
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
  extra = 1
)

ggplot_plot <- ggplot(
  data = redwine_df,
  aes(
    y = redwine_df$alcohol
  )
) + geom_boxplot()
library(plotly)
ggplotly(ggplot_plot)

show.prp.palettes()
