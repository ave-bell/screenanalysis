# load libraries and data
library(tidyverse)
library(screenanalysis)
library(knitr)
data(Yoga_Analysis)

# create and view table 1
variableDescription <- data.frame(
  Variable = colnames(Yoga_Analysis),
  Description = 
    c("Month, day, and year of observation",
      "Day of week",
      "Total amount of screen time (minutes)",
      "Amount of time spent on social media (minutes)",
      "Amount of time spent doing reading and reference activities (minutes)",
      "Amount of time spent on other activities (minutes)",
      "Amount of time spent on productive activities, such as work (minutes)",
      "Amount of time spent working out (minutes)",
      "Amount of time spent watching movies/playing video games etc (minutes)",
      "Amount of time spent creating art/music (minutes)",
      "Indicates whether or not yoga was done that day"),
  Type = 
    c("Date",
       "Factor",
       "Numeric",
       "Numeric",
       "Numeric",
       "Numeric",
       "Numeric",
       "Numeric",
       "Numeric",
       "Numeric",
       "Factor")
                                  )

kable(variableDescription, caption = "Variable Descriptions")

# create and view figure 1
ggplot(Yoga_Analysis, aes(x =Yoga, y = Total.Screen.Time))+
  geom_boxplot(aes(color = Yoga))+
  geom_jitter(width = 0.02, aes(color = Yoga))+
  labs(title = " Figure 1: Total Daily Screen Time With Yoga Participation",
       x = "Daily Yoga",
       y = "Total Screen Time (mins)")+
  scale_x_discrete(labels= c("No", "Yes"))+
  theme(legend.position="none")


# create and view figure 2
ggplot(Yoga_Analysis, aes(x = Week.Day, y = Total.Screen.Time))+
  geom_boxplot(aes(color = Yoga))+
  labs(title = 
         "Figure 2: Total Daily Screen Time Across Weekdays",
       x = "Day of Week",
       y = "Total Screen Time (mins)")+
  theme(axis.text.x = element_text(angle = 45))

# run the two-way ANOVA, create and view table 2
result <- aov(Total.Screen.Time ~ Week.Day + Yoga, Yoga_Analysis)

anovatable <- data.frame(
  Predictor = c("Day of Week", "Yoga"),
  `Degrees of Freedom` = c(6, 1),
  `F value` = c(1.5524, 2.40),
  `P-value` = c(0.221, 0.132),
  check.names = FALSE
                        )

kable(anovatable, align = 'l', caption = "Main Effects Results")

# create and view diagnostic plot
df.residual <- data.frame(
  TotalScreenTime = Yoga_Analysis$Total.Screen.Time, 
  Residual = resid(result)
)

residPlot <- ggplot(df.residual, aes(x = TotalScreenTime, y = Residual)) +
  geom_point(size = 3) +
  geom_hline(yintercept = 0, color='red')+
  labs(
    title = "Assessing Variance",
    x = "Total Daily Screen Time",
    tag = "A"
  )

qqPlot <- ggplot(df.residual, aes(sample = Residual))+ 
  stat_qq() + 
  stat_qq_line(color = 'red') +
  labs(
    title = "Assessing Normality",
    y = 'Theoretical Quantiles',
    x = 'Observed Quantiles',
    tag = "B"
      )
                )


p3 <- cowplot::plot_grid(residPlot, qqPlot)

p3 + cowplot::draw_figure_label(label = "Figure 3", position = "bottom") 


