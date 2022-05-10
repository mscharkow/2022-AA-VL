# VL Anwendungsorientierte Analyseverfahren, Prof. Dr. Michael Scharkow
# Wenn RStudio ihnen nicht vorschlägt, die Pakete zu installieren:
# install.packages(c("tidyverse", "report", "marginaleffects"))

library(tidyverse)
library(marginaleffects)

# Mittelwertvergleiche

# Beispielstudie: Kümpel, A.S. (2019). Getting Tagged, Getting Involved with News?
# A Mixed-Methods Investigation of the Effects and Motives of News-Related Tagging Activities on Social Network Sites
# Journal of Communication,69,4, 373–395. https://doi.org/10.1093/joc/jqz019

kuempel2019 = haven::read_sav("data/Kuempel_2019.sav") %>%
  mutate(Kurationsmodus_SNS = as_factor(Kurationsmodus_SNS), # Gruppierungsvariable als Factor
         Kurationsmodus_SNS = relevel(Kurationsmodus_SNS, "Chronik")) %>%  # Referenzgruppe
  haven::zap_labels() %>%
  mutate(Modus_Tag = ifelse(Kurationsmodus_SNS=="Tag", "1 (ja)", "0 (nein)")) %>%
  select(Modus = Kurationsmodus_SNS, Modus_Tag, Rezeptionswahrscheinlichkeit)

kuempel2019

# Gruppenmittelwerte
kuempel2019 %>%
  group_by(Modus_Tag) %>%
  summarise(n = n(), m = mean(Rezeptionswahrscheinlichkeit), sd = sd(Rezeptionswahrscheinlichkeit))

# T-Test in R
t.test(Rezeptionswahrscheinlichkeit ~ Modus_Tag, data = kuempel2019, var.equal = TRUE)

model_lm1 = lm(Rezeptionswahrscheinlichkeit ~ Modus_Tag, data = kuempel2019)
summary(model_lm1)

# Vorhergesagte Mittelwerte
marginalmeans(model_lm1) %>%
  summary()


# ANOVA in R
model_anova = aov(Rezeptionswahrscheinlichkeit ~ Modus, kuempel2019)
summary(model_anova)


# Randmittel und Kontraste mit dem modelbased Paket
marginalmeans(model_anova) %>%
  summary()
comparisons(model_anova, contrast_factor = "pairwise") %>%
  summary()

# Lineares Modell mit Factor (automatische Dummy-Codierung)
model_lm2 = lm(Rezeptionswahrscheinlichkeit ~ Modus, kuempel2019)
summary(model_lm2)

# Randmittel und Kontraste mit dem modelbased Paket
marginalmeans(model_lm2)
comparisons(model_lm2, contrast_factor = "pairwise") %>%
  summary()

# Bonus: Grafik
marginalmeans(model_lm2)  %>%
  tidy() %>%
  ggplot(aes(x = value, y = estimate,
             ymin = conf.low, ymax = conf.high)) +
  geom_pointrange()+
  coord_cartesian(ylim = c(1,5))+
  labs(x = "Kurationsmodus", y = "Rezeptionswahrscheinlichkeit",
       title ="Vorhergesagte Rezeptionswahrscheinlichkeit nach Kurationsmodus")+
  theme_bw()
