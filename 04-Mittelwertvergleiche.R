# VL Anwendungsorientierte Analyseverfahren, Prof. Dr. Michael Scharkow
# Wenn RStudio ihnen nicht vorschlägt, die Pakete zu installieren:
# install.packages(c("tidyverse", "report", "marginaleffects"))

library(tidyverse)
library(report)
library(marginaleffects)

# Mittelwertvergleiche

# Beispielstudie: Kümpel, A.S. (2019). Getting Tagged, Getting Involved with News?
# A Mixed-Methods Investigation of the Effects and Motives of News-Related Tagging Activities on Social Network Sites
# Journal of Communication,69,4, 373–395. https://doi.org/10.1093/joc/jqz019

kuempel2019 = haven::read_sav("data/Kuempel_2019.sav") %>%
  mutate(Kurationsmodus_SNS = as_factor(Kurationsmodus_SNS), # Gruppierungsvariable als Factor
         Kurationsmodus_SNS = relevel(Kurationsmodus_SNS, "Chronik")) %>%  # Referenzgruppe
  haven::zap_labels() # Probleme mit Variablenlabels, daher loeschen

# Gruppenmittelwerte
kuempel2019 %>%
  report_sample(select = "Rezeptionswahrscheinlichkeit", group_by = "Kurationsmodus_SNS")

# ANOVA in R
model_anova = aov(Rezeptionswahrscheinlichkeit ~ Kurationsmodus_SNS, kuempel2019)
summary(model_anova)

# Zusammenfassung mit report Paket
report_table(model_anova)
report_text(model_anova)

# Randmittel und Kontraste mit dem modelbased Paket
marginalmeans(model_anova) %>% summary()
comparisons(model_anova, contrast_factor = "pairwise") %>% summary()

# Lineares Modell mit Factor (automatische Dummy-Codierung)
model_lm1 = lm(Rezeptionswahrscheinlichkeit ~ Kurationsmodus_SNS, kuempel2019)
summary(model_lm1)
report_table(model_lm1)

# Randmittel und Kontraste mit dem modelbased Paket
marginalmeans(model_lm1)
comparisons(model_lm1, contrast_factor = "pairwise") %>% summary()

# Bonus: Grafik
marginalmeans(model_lm1)  %>%
  tidy() %>%
  ggplot(aes(x = value, y = estimate,
             ymin = conf.low, ymax = conf.high)) +
  geom_pointrange()+
  coord_cartesian(ylim = c(1,5))+
  labs(x = "Kurationsmodus", y = "Rezeptionswahrscheinlichkeit")+
  theme_bw()
