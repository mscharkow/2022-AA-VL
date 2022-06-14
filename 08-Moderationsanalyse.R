# VL Anwendungsorientierte Analyseverfahren, Prof. Dr. Michael Scharkow
# Wenn RStudio Ihnen nicht vorschlaegt die Pakete zu installieren:
# install.packages(c("tidyverse", "report", "marginaleffects"))

library(tidyverse)
library(report)
library(marginaleffects)

theme_set(theme_bw())

# Achtung, im Artikel werden nur die Wahlberechtigten analysiert
vb17 = haven::read_sav("data/Voegele2017.sav") %>%
  mutate(female = ifelse(Geschlecht==1,1,0)) %>%
  haven::zap_labels()

# Lineares Modell mit Geschlecht als Moderator
m1 = lm(gesamt ~ schwab + female + schwab:female, data = vb17)
summary(m1)
report::report_table(m1)

# Konditionale Effekte für schwab in Abhängigkeit von female
marginaleffects::comparisons(m1, variable="schwab") %>%
  summary(by = "female")

# Vorausgesagte Werte für typische Fälle
marginaleffects::predictions(m1, variables = c("schwab", "female"))

# Visualisierung
marginaleffects::predictions(m1, variables = c("schwab", "female")) %>%
  ggplot(aes(x = factor(schwab), y = predicted, group= factor(female),
             color = factor(female), ymin = conf.low, ymax = conf.high))+
  geom_pointrange(position = position_dodge(.1))+
  geom_line(position = position_dodge(.1))+
  labs(y = "Gesamtbewertung (vorhergesagt)", x = "Dialekt", color = "Geschlecht (Frauen)")

# Interaktion mit metrischer Moderatorvariable

# In der Formel * statt + für automatische Interaktionseffekte
# Atol ist hier zentriert
m2 = lm(gesamt ~ schwab * atol_centered, data = vb17)
summary(m2)
report_table(m2)

# Konditionale Effekte durch Zentrieren

lm(gesamt ~ schwab * I(atol-1), data = vb17) # atol = 1
lm(gesamt ~ schwab * I(atol-5), data = vb17) # atol = 5

# Conditional effects plot
marginaleffects::plot_cme(m2, effect = "schwab", condition = "atol_centered")

# Vorausgesagte typische Fälle (schwab und 3 Level von atol)
m3 = lm(gesamt ~ schwab *atol, vb17)
marginaleffects::predictions(m3, newdata = datagrid(schwab = 0:1, atol = c(1,3,5)))

# Visualisierung
marginaleffects::predictions(m3, newdata = datagrid(schwab = 0:1, atol = c(1,3,5))) %>%
  ggplot(aes(x = factor(schwab), y = predicted, group= factor(atol),
             color = factor(atol, labels = c("niedrig (1)", "mittel (3)", "hoch (5)")), ymin = conf.low, ymax = conf.high))+
  geom_pointrange(position = position_dodge(.1))+
  geom_line(position = position_dodge(.1))+
  labs(y = "Gesamtbewertung (vorhergesagt)", x = "Dialekt", color = "ATOL Score")
