# VL Anwendungsorientierte Analyseverfahren, Prof. Dr. Michael Scharkow
# Wenn RStudio ihnen nicht vorschlägt, die Pakete zu installieren:
# install.packages(c("tidyverse", "report", "performance"))

library(tidyverse)
library(report)
library(performance)
theme_set(theme_bw())

# Multiple Regression

# Beispielstudie: van Erkel, P. F., & Van Aelst, P. (2021). Why don’t we learn from social media? Studying effects of and mechanisms behind social media news use on general surveillance political knowledge. Political Communication, 38(4), 407-425.

vanerkel21 = haven::read_sav("data/VanErkel_2021.sav")
vanerkel21

# Modell 1: Nur Soziodemographie
m1 = lm(PK ~ Gender + Age + Education + Political_interest, data = vanerkel21)
summary(m1)
report::report_table(m1)

# Modell 2: plus Mediennutzung
m2 = lm(PK ~ TV + Newspaper + Websites + Facebook + Twitter +
          Gender + Age +  Education +  Political_interest, data=vanerkel21)
report::report_table(m2)

# Modellvergleich
anova(m1, m2)

# Modellannahmen
performance::check_model(m2)