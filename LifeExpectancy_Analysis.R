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


library(moments)  

mean_le   <- mean(analysis_data$Life.Expectancy.World.Bank)
median_le <- median(analysis_data$Life.Expectancy.World.Bank)
skew_le   <- skewness(analysis_data$Life.Expectancy.World.Bank)

# Create histogram of Life Expectancy
histogram <- ggplot(analysis_data, aes(x = Life.Expectancy.World.Bank)) +
  
  # Histogram
  geom_histogram(aes(y = ..density..),bins = 30,fill = "steelblue",color = "black",alpha = 0.6) +
  
  # Density curve
  geom_density(color = "red", size = 1.1) +
  
  # Mean line
  geom_vline(xintercept = mean_le,linetype = "dashed",color = "darkgreen",size = 1) +
  
  # Median line
  geom_vline(xintercept = median_le,linetype = "dotdash",color = "purple",size = 1) +
  
  # Mean annotation
  annotate("text",
           x = mean_le,
           y = max(density(analysis_data$Life.Expectancy.World.Bank)$y),
           label = paste0("Mean = ", round(mean_le, 2)),
           color = "darkgreen",
           angle = 90,
           vjust = -0.5,
           size = 3.8) +
  
  # Median annotation
  annotate("text",
           x = median_le,
           y = max(density(analysis_data$Life.Expectancy.World.Bank)$y) * 0.9,
           label = paste0("Median = ", round(median_le, 2)),
           color = "purple",
           angle = 90,
           vjust = -0.5,
           size = 3.8) +
  
  # Skewness annotation
  annotate("text",x = Inf, y = Inf,hjust = 1.1, vjust = 1.6,label = paste0("Skewness = ", round(skew_le, 2)),size = 4,fontface = "bold") +
  
  labs(
    title = "Life Expectancy Distribution with Centre and Skewness",
    subtitle = "Mean–Median separation and skewness quantify distribution asymmetry",
    x = "Life Expectancy (years)",
    y = "Density"
  ) +
  
  theme_minimal()

print(histogram)



png("histogram.png", width = 800, height = 600, res = 100)
print(histogram)
dev.off()
