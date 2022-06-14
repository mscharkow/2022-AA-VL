* Encoding: UTF-8.
***VL 6: Moderation***
***Studie: Vögele, C. & Bachl, M. (2017). Der Einfluss des Dialekts auf die Bewertung von Politikern
SCM Studies in Communication and Media, 6(2), 196–215. https://doi.org/10.5771/2192-4007-2017-2-196***
*** Daten: https://osf.io/72azd/***

*** Fragestellungen:
1. Wird der Einfluss eines schwäbischen Akzents auf die Bewertung einen Politikers durch das Geschlecht der Person moderiert? ***
2. Wird der Einfluss eines schwäbischen Akzents auf die Bewertung einen Politikers durch die Voreinstellung gegenüber dem Akzent moderiert? ***

* Deskriptive Statistik nach Experimentalbedingung*

SORT CASES  BY schwab.
SPLIT FILE LAYERED BY schwab.

FREQUENCIES VARIABLES=Geschlecht
  /ORDER=ANALYSIS.

DESCRIPTIVES VARIABLES= gesamt
  /STATISTICS=MEAN STDDEV MIN MAX.

Split file off.

* Filtern der Personen, die nicht BW wählen dürfen*

USE ALL.
COMPUTE filter_$=(Filter_Wahlberechtigung = 1).
FILTER BY filter_$.

*** Erstellung der Interaktionsvariablen***

*** Recodierung der Geschlechtsvariable um männlich als Referenz zu haben ***

recode Geschlecht (1 = 1) (2 = 2) (else = SYSMIS) into Geschlecht.

compute schwab_geschlecht = schwab * Geschlecht.

freq schwab_geschlecht.


* Zentrierung von atol ***

aggregate outfile * mode addvariables
/mean_atol = mean(atol).

compute atol_centered = atol - mean_atol.

*** Erstellung der zweiten Interaktionsvariabel schwab * atol ***

compute schwab_atol = schwab * atol.


*** Regressionsmodelle ***

*** 1. Effekt von Nutzung des Akzents (Schwab, dichotom), Geschlecht (dichotom) und der Interaktion (schwab_geschlecht) auf den Gesamteindruck des Politikers***

REGRESSION
  /DEPENDENT gesamt
  /METHOD=ENTER schwab Geschlecht schwab_geschlecht.

*** Das Modell ist signifikant (F(3,320) = 6.41, p<.001) und erklärt 5 % (r2 adj. = 0.048) der Varianz der Gesamtbewertung. Die Nutzung eines schwäbischen Akzents keinen nicht-zufälligen
 Einfluss (b = -.39, p=.20), das Geschlecht hat einen positiven Einfluss (b=.27, p<.05), und die Interaktion ist nicht signifikant (b=.09, p= .64) ***

*** Interpretation der konditionalen Effekte mit Process ***
1. Process ist ein Add-on, dass eine komfortable Analyse von Interaktionseffekten ermöglicht. Dafür Process herunterladen www.processmacro.org/download.html
2. Die .sps Datei öffnen, alles markieren und ausführen
3. Process ist bereit zur Anwendung
4. Diese Schritte müssen bei Neustart von SPSS wiederholt werden ***

*** Process kann auch als Menü in SPSS eingerichtet werden (siehe processmacro.org für Hinweise) aber eigentlich ist die Syntax komfortabler,
    zur Erklärung der Syntax
    y: AV,
    x: UV,
    w:Moderator,
    model:Welches Modell soll gerechnet werden, da gibt es auch eine Übersicht auf processmacro (kleiner
    Tipp: 1 ist ein Moderator, 4 ist ein Mediator),
    intprobe: Welches Signiveau soll geprüft werden, brauchen wir normalerweise nicht, nur hier, weil der Effekt nicht signifikant ist,
    longname: Variablen dürfen bei Process normalerweise nur 8 Zeichen haben, mit longname wird das ignoriert***

*** Es gibt noch andere Befehle, die alle hier erklärt werden (das Buch ist als Ebook in der Bibliothek verfügbar)
    https://www.guilford.com/books/Introduction-to-Mediation-Moderation-and-Conditional-Process-Analysis/Andrew-Hayes/9781462549030 ***

** 1. Effekt von Nutzung des Akzents (Schwab, dichotom), Geschlecht und der Interaktion (schwab_geschlecht) auf den Gesamteindruck (gesamt) des Politikers***

process y=gesamt /x=schwab /w=Geschlecht /model=1 /intprobe = 1 /longname =1.

*** Interpretation nur beispielhaft, weil der Int-Effekt ja nicht signfikant ist. Auf weibliche Personen hat die Nutzung des schwäbischen Akzents nicht so eine negative Wirkung (b = -.23) wie
    auf männliche Personen (b = -.29).***

** 2. Effekt von Nutzung des Akzents (Schwab, dichotom), Voreinstellung gegenüber dem Akzent (zentriert) und der Interaktion (schwab_atol) auf den Gesamteindruck (gesamt) des Politikers***

REGRESSION
  /DEPENDENT gesamt
  /METHOD=ENTER schwab atol_centered schwab_atol_centered.

*** Das Modell ist signifikant (F(3,320) = 6.65, p<.001) und erklärt 5 % (r2 adj. = 0.05) der Varianz der Gesamtbewertung. Die Nutzung eines schwäbischen Akzents hat
 einen Einfluss (b = -.25, p<.01), die Voreinstellung hat keinen  Einfluss (b=-.06, p=.48), und die Interaktion ist signifikant (b=.35, p<.01) ***

*** Mit moments werden die Effekte an - 1SD, M, + 1SD geprüft ***

process y=gesamt /x=schwab /w=atol_centered /model=1 /longname =1 /moments = 1.

*** Interpretation: Der Interaktion ist bei - 1SD der Voreinstellung negativ (b= -.51, p<.01),
    bei M signifikant negativ (b = .20, p< .05) und bei +1SD positiv (b=.11, p=.39) aber nicht signifikant. Das heißt eine negative Voreinstellung (- 1SD)
    und eine mittlere Voreinstellung (M) haben einen negativen Effekt auf die Beziehung zwischen Nutzung des Akzents und der Bewertung ***
