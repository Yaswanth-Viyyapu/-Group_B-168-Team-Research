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


# Create scatter plot with regression line
scatter_plot <- ggplot(analysis_data,
       aes(x = Health.Expenditure..,
           y = Life.Expectancy.World.Bank)) +
  
  geom_point(alpha = 0.45, size = 2, color = "steelblue") +
  
  # Linear trend (global correlation)
  geom_smooth(method = "lm",
              se = FALSE,
              color = "red",
              linetype = "dashed",
              size = 1) +
  
  # Non-linear pattern (true relationship)
  geom_smooth(method = "loess",
              se = TRUE,
              color = "darkgreen",
              fill = "lightgreen",
              alpha = 0.25,
              size = 1.2) +
  
  labs(
    title = "Health Expenditure vs Life Expectancy",
    subtitle = "LOESS curve reveals diminishing returns and non-linearity",
    x = "Health Expenditure (% of GDP)",
    y = "Life Expectancy (years)"
  ) +
  theme_minimal()

print(scatter_plot)

# Save outputs
png("scatter_plot.png", width = 800, height = 600, res = 100)
print(scatter_plot)
dev.off()

