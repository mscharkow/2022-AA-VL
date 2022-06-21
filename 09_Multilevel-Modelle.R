# VL Anwendungsorientierte Analyseverfahren, Prof. Dr. Michael Scharkow
# Wenn RStudio Ihnen nicht vorschlaegt die Pakete zu installieren:
# install.packages(c("tidyverse", "report", "marginaleffects", "lme4))

library(tidyverse)
library(report)
library(lme4)
library(marginaleffects)

theme_set(theme_bw())


uni_fb = haven::read_sav("data/Faehnrich_2020.sav")
uni_fb

# Nullmodell
m0 = lmer(comments_count ~ 1 + (1 | uni), data = uni_fb)
summary(m0)

# Vorausgesagte Mittelwerte (inkl. varying intercepts)
marginaleffects::marginalmeans(m0)

# Falsches lineares Modell
m1_falsch = lm(comments_count ~ 1 + topic_interact, data = uni_fb)
summary(m1_falsch)

# Lineares Modell mit varying intercepts
m1 = lmer(comments_count ~ 1 + topic_interact + (1|uni), data = uni_fb)
summary(m1)
report::report_table(m1)

# Modell mit Level-2-Prädiktor
m2 = lmer(comments_count ~ 1 + topic_interact + uni_fans + (1|uni), data = uni_fb)
summary(m2)
report::report_table(m2)