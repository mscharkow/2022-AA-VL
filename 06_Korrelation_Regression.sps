* Encoding: UTF-8.

***VL6: Korrelation & bivariate Regression ***

***Studie: Johannes, N., Dienlin, T., Bakhshi, H. et al. No effect of different types of media on well-being
    Sci Rep 12, 61 (2022). https://doi.org/10.1038/s41598-021-03218-7***
*** Daten: https://osf.io/f3qjv/ => wave1.csv ***

*** Vorbereitung der Variablen ***

*Zentrieren und Standardisieren von Alter und games_time ***

*Zentrieren ***

aggregate outfile * mode addvariables
/mean_age = mean(age).

compute age_centered = age - mean_age.

*** Standardisieren ***

DESCRIPTIVES VAR=age games_time
/SAVE.

RENAME VARIABLES (Zage Zgames_time = age_z games_time_z).

*** Korrelationen***

CORRELATIONS
  /VARIABLES= tv_time games_time music_time age
  /PRINT=TWOTAIL NOSIG LOWER.


*** Scatterplot ***

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=age games_time MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: age=col(source(s), name("age"))
  DATA: games_time=col(source(s), name("games_time"))
  GUIDE: axis(dim(1), label("age"))
  GUIDE: axis(dim(2), label("games_time"))
  GUIDE: text.title(label("Streudiagramm von games_time Schritt: age"))
  ELEMENT: point(position(age*games_time))
END GPL.

*** Bivariate Regression ***

REGRESSION
  /DEPENDENT games_time
  /METHOD=ENTER age.


*** Zentrierte X Variable ***

REGRESSION
  /DEPENDENT games_time
  /METHOD=ENTER age_z.

*** Visualisierung der vorhergesagten Werte ***

* Diagrammerstellung.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=age PRE_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: age=col(source(s), name("age"))
  DATA: PRE_1=col(source(s), name("PRE_1"))
  GUIDE: axis(dim(1), label("age"))
  GUIDE: axis(dim(2), label("Unstandardized Predicted Value"))
  GUIDE: text.title(label("Streudiagramm von Unstandardized Predicted Value Schritt: age"))
  ELEMENT: point(position(age*PRE_1))
END GPL.