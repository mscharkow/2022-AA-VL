* Encoding: UTF-8.
*** GLM I - Grundlagen ***
*** Studie:Auty, S. and Lewis, C. (2004), Exploring children's choice: The reminder effect of product placement.***
    *Psychology & Marketing, 21: 697-713. https://doi.org/10.1002/mar.20025*

*** Fragestellung: Hängt die Wahl von Coca Cola oder Pepsi damit zusammen, ob Personen einen Film mit Produktplatzierung von Pepsi gesehen haben? ***

** Daten: AutyLewis2004.sav ***

*** Deskriptive Analyse - Häufigkeiten ***

FREQUENCIES pepsi_placement pepsi_chosen.

*** Für die Analyse lassen sich verschiedene Variationen des GLMs verwenden, die alle eine gemeinsame Logik haben ***

*** Zusammenhangshypothese: H1: pepsi_chosen hängt mit Placement zusammen ***

*** Chi-2 ***

CROSSTABS
  /TABLES=pepsi_placement BY pepsi_chosen
  /STATISTICS=CHISQ.

*** Ergebnis: Die pepsi_chosen hängt damit zusammmen, ob man ein Produktplacement gesehen hat (chi2 = 4.14, p<.05) ***

*** T-Test ***

T-TEST GROUPS=pepsi_placement(0 1)
  /VARIABLES=pepsi_chosen.

*** Ergebnis: Die pepsi_chosen unterscheidet sich signifikant (T= -2.06, p<.05) zwischen Leuten, die ein Placement (M = .43, SD = .50) und kein Placement
    (M = .63, SD = .49) sahen. ***

*** ANOVA***

UNIANOVA pepsi_chosen BY pepsi_placement
  /DESIGN=pepsi_placement.

*** Ergebnis: Produkt-Placement hat einen signifikanten Einfluss (Haupteffekt) (F = 4.23, p<.05) auf pepsi_chosen und erklärt 3% (r2 adj. = .03) der
    Varianz ***
*** Bei dem Anova Befehl erhält man nicht automatisch eine Parameterschätzung. Diese kann man unter Optionen hinzufügen ***



*** Lineare Regression ***

REGRESSION
  /DEPENDENT pepsi_chosen
  /METHOD=ENTER pepsi_placement.

*** Ergebnis: Produkt-Placement hat einen signifikanten Einfluss (Haupteffekt) (F = 4.23, p<.05) auf pepsi_chosen,
     und erklärt 3% (r2 adj. = .03) der Varianz. genau gleich wie ANOVA. Nur erhalten wir hir noch eine Parameterschätzung "inklusive".***
*** Wenn Leute ein Placements sahen, stieg ihre pepsi_chosen für Pepsi um .2 (b = .20, p<.05). ***