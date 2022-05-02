# VL Anwendungsorientierte Analyseverfahren, Prof. Dr. Michael Scharkow

library(tidyverse)
theme_set(theme_minimal())

#  Studie: Auty, S. and Lewis, C. (2004), Exploring children's choice: The reminder effect of product placement.
#  Psychology & Marketing, 21: 697-713. https://doi.org/10.1002/mar.20025
#
#  Fragestellung: Hängt die Präferenz für Cola oder Pepsi damit zusammen, ob Personen einen Film mit Produktplatzierung von Pepsi gesehen haben?

# Daten laten -------------------------------------------------------------
autylewis04 = haven::read_sav("data/AutyLewis2004.sav")
autylewis04

# Häufigkeiten und Prozentwerte in den beiden Gruppen ---------------------------------------
autylewis04 %>%
  group_by(pepsi_placement) %>%
  count(pepsi_chosen)

autylewis04 %>%
  group_by(pepsi_placement) %>%
  summarise(m = mean(pepsi_chosen), sd = sd(pepsi_chosen))

# Chi-Quadrat Test --------------------------------------------------------
table(autylewis04$pepsi_placement, autylewis04$pepsi_chosen) %>%
  chisq.test(correct = FALSE)

# Ergebnis: Die Produktwahl hängt damit zusammmen, ob man ein Product Placement gesehen hat (Chi^2 = 4.14, p<.05)

# Bivariate Korrelation ---------------------------------------------------
cor.test(autylewis04$pepsi_placement, autylewis04$pepsi_chosen)

# Ergebnis: Die Produktwahl hängt damit zusammmen, ob man ein Product Placement gesehen hat (r = .20, p<.05)

# T-Test ------------------------------------------------------------------
t.test(pepsi_chosen ~ pepsi_placement, data = autylewis04, var.equal = TRUE)

# Ergebnis: Die Produktwahl unterscheidet sich signifikant (T= -2.06, p<.05) zwischen Leuten, die ein Placement (M = .63) und kein Placement (M = .43) sahen.

# Einfaktorielle Varianzanalyse (ANOVA) -----------------------------------
aov(pepsi_chosen ~ pepsi_placement, data = autylewis04) %>%
  summary()

# Product Placement hat einen signifikanten Einfluss (Haupteffekt) (F(1,103) = 4.23, p<.05) auf Produktwahl.

# Lineare Regression ------------------------------------------------------
lm(pepsi_chosen ~ pepsi_placement, data = autylewis04) %>%
  summary()

# Product Placement hat einen signifikanten Einfluss (Haupteffekt) (F(1,103) = 4.23, p<.05) auf Produktwahl.
# Bei Probanden, die ein Placements sahen, wahr die Wahrscheinlichkeit, zu Pepsi zu greifen 20% höher (b = .20, p<.05).