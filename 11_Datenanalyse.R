# VL Anwendungsorientierte Analyseverfahren, Prof. Dr. Michael Scharkow
# Wenn RStudio Ihnen nicht vorschlaegt die Pakete zu installieren:
# install.packages(c("tidyverse", "report", "marginaleffects", "lme4))

library(tidyverse)
library(report)
library(lme4)
library(marginaleffects)

theme_set(theme_bw())

lazarus = haven::read_sav("data/Lazarus_2021.sav") %>%
  mutate(country = as_factor(country),
         educ_fact = as_factor(educ_fact))
lazarus
summary(lazarus)

# FF1: Länderunterschiede
m1 = lm(vacc ~ country, data = lazarus)
summary(m1)

# H1: Geschlecht
m2 = lm(vacc ~ female, data = lazarus)
summary(m2)

# H3: Alter
m3 = lm(vacc ~ age, data = lazarus)
summary(m3)

# Kombiniert

m4 = lm(vacc ~ age + female + country, data = lazarus)
summary(m4)
report_table(m4)

# Modellvergleich (Länder vs. Länder + Soziodemographie)
anova(m1, m4)

# Vorhergesagte Werte bei Ländern
marginaleffects::marginalmeans(m4, variables = "country") %>%
  summary()

marginaleffects::marginalmeans(m4, variables = "country") %>%
  tidy() %>%
  ggplot(aes(x = reorder(value, estimate), y = estimate,
             ymin = conf.low, ymax = conf.high))+
  geom_pointrange()+
  coord_flip()+
  labs(x = "", y = "Impfbereitschaft (95%-CI)")

# Vorhergesagte Werte bei Geschlecht
marginaleffects::marginalmeans(m4, variables = "female") %>%
  summary()

marginaleffects::marginalmeans(m4, variables = "female") %>%
  tidy() %>%
  ggplot(aes(x = reorder(value, estimate), y = estimate,
             ymin = conf.low, ymax = conf.high))+
  geom_pointrange()+
  labs(x = "", y = "Impfbereitschaft (95%-CI)")

# BONUS: H3
m5 = lmer(vacc ~ trustngov + (1|country), data = lazarus)
summary(m5)
report::report_table(m5)