# VL Anwendungsorientierte Analyseverfahren, Prof. Dr. Michael Scharkow
# Wenn RStudio Ihnen nicht vorschlaegt die Pakete zu installieren:
# install.packages(c("tidyverse", "report", "marginaleffects", "lme4))

library(tidyverse)
library(report)
library(lme4)
library(marginaleffects)

theme_set(theme_bw())


festl13 = haven::read_sav("data/Festl13.sav") %>%
  mutate(gender = as_factor(gender)) %>%
  haven::zap_label()

festl13

# Häufigkeiten und Chi-Quadrat Test
table(festl13$cbvictim_gen, festl13$gender)

table(festl13$cbvictim_gen, festl13$gender) %>%
  chisq.test()


# Bivariate logistische Regression
m1 = glm(cbvictim_gen ~ gender, festl13, family=binomial(link="logit"))

# Unstandardisierte B
report::report_table(m1)

# Exp(B) bzw. Odds Ratios
report::report_table(m1, exponentiate = TRUE)

# Pseudo R-Quadrate
performance::r2_mcfadden(m1)
performance::r2_nagelkerke(m1)
performance::r2_coxsnell(m1)

# Intercept umrechnen
coef(m1)

coef(m1)[1] %>%
  plogis()

# Average Marginal Effects
marginaleffects::marginaleffects(m1) %>%
  summary()

# Vorhergesagte Wahrscheinlichkeiten
marginaleffects::marginalmeans(m1) %>%
  summary()


# Visualisiert
marginaleffects::marginalmeans(m1) %>%
  tidy() %>%
  ggplot(aes(x = value, y = estimate, ymin = conf.low, ymax = conf.high))+
  geom_pointrange()+
  labs(y = "Predicted Probability", x = "Gender")


# Multilevel logistisches Regression
# Daten zentrieren
festl13 = festl13 %>% mutate(age12 = age - 12, internetuse_c = internetuse - mean(internetuse), female = ifelse(gender=="female", 1, 0))

m2 = glmer(cbvictim_gen ~ female*age12 + internetuse_c + (1|class), data = festl13, family=binomial)
summary(m2)
report::report_table(m2, exponentiate = TRUE)

# Average Marginal Effects
marginaleffects::marginaleffects(m2) %>% summary()

# Visualisierung der vorhergesagten Wahrscheinlichkeiten
glm(cbvictim_gen ~ gender*age + internetuse, data = festl13, family=binomial) %>%
  marginaleffects::predictions(variables=c("age", "gender")) %>%
  ggplot(aes(x = age, y = predicted, ymin = conf.low, ymax = conf.high,
             group = gender, fill = gender))+
  geom_line(aes(color = gender))+
  geom_ribbon(alpha = .2)