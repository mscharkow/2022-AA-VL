* Encoding: UTF-8.

  ***VL4: Mittelwertsvergleiche***


  *** Beispielstudie: Kuempel, A.S. (2019). Getting Tagged, Getting Involved with News?
  A Mixed-Methods Investigation of the Effects and Motives of News-Related Tagging Activities on Social Network Sites
Journal of Communication,69,4. https://doi.org/10.1093/joc/jqz019 ***
  *** Zugrundeliegende Daten: https://osf.io/8td9w/ => Study 1 Tagging_Data.sav ***

  * Fragestellung: Unterscheidet sich die Rezeptionswahrscheinlich in sozialen Netzwerken anhand der Kurationsmodi (Post, Chronik, Tag, DM)?


  *Variablen: UV: Kurationsmodus_SNS, AV: Rezeptionswahrscheinlichkeit*

  *** Deskriptive Statistik ***

  *** Haeufigkeiten UV ***

  FREQUENCIES VARIABLES=Kurationsmodus_SNS.


*** Beschreibung AV ***

  DESCRIPTIVES VARIABLES=Rezeptionswahrscheinlichkeit
/STATISTICS=MEAN STDDEV VARIANCE MIN MAX.

*** Histogramm ***

  GGRAPH
/GRAPHDATASET NAME="graphdataset" VARIABLES=Rezeptionswahrscheinlichkeit MISSING=LISTWISE
REPORTMISSING=NO
/GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
SOURCE: s=userSource(id("graphdataset"))
DATA: Rezeptionswahrscheinlichkeit=col(source(s), name("Rezeptionswahrscheinlichkeit"))
GUIDE: axis(dim(1), label("Rezeptionswahrscheinlichkeit"))
GUIDE: axis(dim(2), label("Haeufigkeit"))
GUIDE: text.title(label("Einfaches Histogramm von Rezeptionswahrscheinlichkeit"))
ELEMENT: interval(position(summary.count(bin.rect(Rezeptionswahrscheinlichkeit))),
                  shape.interior(shape.square))
END GPL.

*** Deskriptive Statistik nach Gruppen ***

  MEANS TABLES=Rezeptionswahrscheinlichkeit BY Modus_Tag
/CELLS=MEAN COUNT STDDEV.

*** Analyse der Unterschiede ***
  *** Unterschiede zwischen zwei Auspraegungen => t-test mit unabhaengigen Stichproben ***

  T-TEST GROUPS=Modus_Tag(1 2)
/VARIABLES=Rezeptionswahrscheinlichkeit.

*** Ergebnis: Die Rezeptionswahrscheinlichkeit unterscheidet in den Kurationsmodi Chronik (M = 2.88, SD = 1.20) und Tag (M = 3.51, SD = 1.32) (t(291) = - 5.08, p<.001) ***

  *** GLM statt T-Test ***

  REGRESSION
/DEPENDENT Rezeptionswahrscheinlichkeit
/METHOD=ENTER Modus_Tag.

* Diagrammerstellung.
GGRAPH
/GRAPHDATASET NAME="graphdataset" VARIABLES=Modus_Tag
MEAN(Rezeptionswahrscheinlichkeit)[name="MEAN_Rezeptionswahrscheinlichkeit"] MISSING=LISTWISE
REPORTMISSING=NO
/GRAPHSPEC SOURCE=INLINE
/FRAME OUTER=NO INNER=NO
/GRIDLINES XAXIS=NO YAXIS=NO
/STYLE GRADIENT=NO.
BEGIN GPL
SOURCE: s=userSource(id("graphdataset"))
DATA: Modus_Tag=col(source(s), name("Modus_Tag"), unit.category())
DATA: MEAN_Rezeptionswahrscheinlichkeit=col(source(s), name("MEAN_Rezeptionswahrscheinlichkeit"))
GUIDE: axis(dim(1), label("Kurationsmodus_SNS=Tag"))
GUIDE: axis(dim(2), label("Mittelwert Rezeptionswahrscheinlichkeit"))
GUIDE: text.title(label("Streudiagramm von Rezeptionswahrscheinlichkeit Schritt: ",
                        "Kurationsmodus_SNS=Tag"))
GUIDE: text.footnote(label("Fehlerbalken: 95% CI"))
SCALE: linear(dim(2), include(0))
ELEMENT: point(position(Modus_Tag*MEAN_Rezeptionswahrscheinlichkeit))
END GPL.

*** Mehr als zwei Mittelwerte vergleichen ***

  MEANS TABLES=Rezeptionswahrscheinlichkeit BY Kurationsmodus_SNS
/CELLS=MEAN COUNT STDDEV.

*** Unterschiede zwischen mehr als zwei Auspraegungen der UV, nicht mit mehreren T-Test wegen Alpha-Fehler-Kumulation, sondern mit der Varianzanalyse***


  *** Univariate Varianzanalyse, Posthoc-Test mit GT2-Hochberg Korrektur, vorhergesagte MW ausgeben lassen***

  UNIANOVA Rezeptionswahrscheinlichkeit BY Kurationsmodus_SNS
/POSTHOC=Kurationsmodus_SNS(GT2)
/EMMEANS=TABLES(Kurationsmodus_SNS) COMPARE ADJ(LSD)
/DESIGN=Kurationsmodus_SNS.

*** Die Rezeptionswahrscheinlichkeit unterscheidet sich innerhalb der Kurationsmodi (F(3,520) = 10.17, p<.001) ***

  *** Alternative Methode, Regression mit GLM ***

  REGRESSION
/DEPENDENT Rezeptionswahrscheinlichkeit
/METHOD=ENTER Modus_Post Modus_Chronik Modus_Tag Modus_DM.

*** Ergebnis auch das gleiche wie oben. Referenzgruppe ist die die nicht als Variable eingefuehrt wurde,
vergleiche Regressionskoeffizienten mit Post-Hoc Tests des ersten Kurationsmodus "Post" (Interzept in der Regression) in ANOVA***

  *** Boxplots mit den Kategorien ***
  * Diagrammerstellung.

GGRAPH
/GRAPHDATASET NAME="graphdataset" VARIABLES=Kurationsmodus_SNS
MEANCI(Rezeptionswahrscheinlichkeit, 95)[name="MEAN_Rezeptionswahrscheinlichkeit"
                                         LOW="MEAN_Rezeptionswahrscheinlichkeit_LOW" HIGH="MEAN_Rezeptionswahrscheinlichkeit_HIGH"]
MISSING=LISTWISE REPORTMISSING=NO
/GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
SOURCE: s=userSource(id("graphdataset"))
DATA: Kurationsmodus_SNS=col(source(s), name("Kurationsmodus_SNS"), unit.category())
DATA: MEAN_Rezeptionswahrscheinlichkeit=col(source(s), name("MEAN_Rezeptionswahrscheinlichkeit"))
DATA: LOW=col(source(s), name("MEAN_Rezeptionswahrscheinlichkeit_LOW"))
DATA: HIGH=col(source(s), name("MEAN_Rezeptionswahrscheinlichkeit_HIGH"))
GUIDE: axis(dim(2), label("Mittelwert Rezeptionswahrscheinlichkeit"))
GUIDE: text.title(label("Gruppierter Boxplot Mittelwert von Rezeptionswahrscheinlichkeit ",
                        "Schritt: Urne: Stimulus"))
GUIDE: text.subsubtitle(label("n = 524"))
SCALE: cat(dim(1), include("0", "1", "2", "3"))
SCALE: linear(dim(2), include(0))
ELEMENT: point(position(Kurationsmodus_SNS*MEAN_Rezeptionswahrscheinlichkeit))
ELEMENT: interval(position(region.spread.range(Kurationsmodus_SNS*(LOW+HIGH))),
                  shape.interior(shape.ibeam))
END GPL.
