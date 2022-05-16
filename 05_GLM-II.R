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

# Nullmodell
model_null = lm(Rezeptionswahrscheinlichkeit ~ 1, data = kuempel2019)
summary(model_null)

# Lineares Modell mit Dummy-Prädiktor Modus_Tag
model_lm1 = lm(Rezeptionswahrscheinlichkeit ~ Modus_Tag, data = kuempel2019)
summary(model_lm1)

# Modellvergleich mit Nullmodell
anova(model_null, model_lm1)

# Lineares Modell mit Factor Modus (automatische Dummy-Codierung)
model_lm2 = lm(Rezeptionswahrscheinlichkeit ~ Modus, data = kuempel2019)
summary(model_lm2)

# Modellvergleich mit Model 1
anova(model_lm1, model_lm2)

# Bonusaufgabe ------------------------------------------------------------
# Quelle: https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-07-07/readme.md

# Für SPSS-Nutzer: coffee.sav im data Ordner

coffee_ratings <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-07/coffee_ratings.csv')
coffee_ratings

# Unterscheiden sich die Bewertungen (total_cup_points) in Abhängigkeit der Kaffeesorte (species)?
# Spezifizieren und interpretieren sie ein einfaches GLM, einen T-Test oder eine ANOVA.
# Super-Sonder-Bonus: Visualisieren sie die geschätzten Randmittelwerte durch Anpassung des Codes aus Sitzung 4.

