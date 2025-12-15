# Load required libraries
library(ggplot2)
library(dplyr)

# Load the dataset
life_expectancy <- read.csv('life expectancy.csv')
cat("Total Population Size:", nrow(life_expectancy), "\n")

# Remove rows with missing values in the variables of interest
analysis_data <- life_expectancy %>%
  select(Life.Expectancy.World.Bank, Health.Expenditure..) %>%
  na.omit()

# Descriptive statistics
cat("Sample Size:", nrow(analysis_data), "\n")
cat("\nLife Expectancy Statistics:\n")
print(summary(analysis_data$Life.Expectancy.World.Bank))
cat("\nHealth Expenditure % Statistics:\n")
print(summary(analysis_data$Health.Expenditure..))

