# VL Anwendungsorientierte Analyseverfahren, Prof. Dr. Michael Scharkow
# Wenn RStudio ihnen nicht vorschlägt, die Pakete zu installieren:
# install.packages(c("tidyverse", "report", "marginaleffects"))

library(tidyverse)
library(report)
library(marginaleffects)
theme_set(theme_bw())

# Korrelation und Regression

# Beispielstudie: Johannes, N., Dienlin, T., Bakhshi, H., & Przybylski, A. K. (2022). No effect of different types of media on well-being. Scientific reports, 12(1), 1-13.
# Daten: https://osf.io/yn7sx/

johannes22 = haven::read_sav("data/Johannes_etal_2022.sav") %>%
  mutate(age_centered = age - mean(age, na.rm = T),
         age_z = scale(age),
         games_time_z = scale(games_time))

johannes22

# Korrelationen
johannes22 %>%
  select(tv_time, games_time, music_time, age) %>%
  cor(use = "complete")

# Korrelationstest
cor.test(~ age + games_time, data = johannes22)

# Scatterplot
johannes22 %>%
  ggplot(aes(age, games_time))+
  geom_point()

# Bivariate Regression
m1 = lm(games_time ~ age, johannes22)
summary(m1)

# Zentrierte X Variable
m1_centered = lm(games_time ~ age_centered, johannes22)
summary(m1_centered)

# Standardisierte Koeffizienten
m1_z = lm(games_time_z ~ age_z, johannes22)
summary(m1_z)

# Regressionstabelle
report::report_table(m1)

# Vorhergesagte Werte
marginaleffects::predictions(m1) %>%
  head()

# Visualisierung der vorhergesagten Werte
marginaleffects::predictions(m1) %>%
  ggplot(aes(x = age, y = predicted, ymin = conf.low, ymax = conf.high))+
  geom_line()+
  geom_ribbon(alpha = .1)