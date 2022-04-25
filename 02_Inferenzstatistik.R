# VL Anwendungsorientierte Analyseverfahren, Prof. Dr. Michael Scharkow

library(tidyverse)
theme_set(theme_minimal())

# Alpha-Fehler ------------------------------------------------------------
# Simulation eines T-Tests für zwei Stichproben

# IQ ist verteilt mit M = 100, SD = 15
# Population von Mainz
iq_population = rnorm(n = 220000, mean = 100, sd = 15)
summary(iq_population)

# Wir ziehen zwei Stichproben
sample_a = sample(iq_population, size = 20)
summary(sample_a)

sample_b = sample(iq_population, size = 20)
summary(sample_b)

# T-Test
t.test(sample_a, sample_b, var.equal = T)

# Wir vergleichen 100 Mal zwei 20er Stichproben und speichern den p-Wert

p_vals = replicate(n = 100, {t.test(x = sample(iq_population, 20),
                           y = sample(iq_population, 20),
                           var.equal = T)$p.value})

p_vals
qplot(p_vals)

# Wieviele p-Werte sind signifikant (Alpha-Fehler)?
sum(p_vals <= .05)

# Was sollte herauskommen, wenn wir statt 100 gleich 10.000 Simulationen machen?
# Was sollte sich am Alpha-Fehler mit größeren Stichproben ändern?


# Beta-Fehler ------------------------------------------------------------

# JGU-Studierende sind etwas schlauer im Schnitt
iq_jgu = rnorm(n = 31000, mean = 110, sd = 15)
summary(iq_jgu)

# Wir vergleichen 20 Studierende mit 20 anderen Mainzern

t.test(sample(iq_jgu, size = 20),
       sample(iq_population, size = 20),
       var.equal = T)

# Wir vergleichen 100 Mal zwei 20er Stichproben und speichern den p-Wert

p_vals2 = replicate(n = 100, {t.test(x = sample(iq_jgu, 20),
                                    y = sample(iq_population, 20),
                                    var.equal = T)$p.value})

p_vals2
qplot(p_vals2)

# Wieviele p-Werte sind nicht-signifikant (Beta-Fehler)?
sum(p_vals2 > .05)

# Was sollte sich am Beta-Fehler mit größeren Stichproben ändern?
