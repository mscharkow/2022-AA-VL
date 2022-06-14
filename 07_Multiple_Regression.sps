* Encoding: UTF-8.

***Multiple Regression***

  ***Beispielstudie: van Erkel, P. F., & Van Aelst, P. (2021). Why don’t we learn from social media? Studying effects of and mechanisms behind social media news***

  *** Modell 1: nur Soziodemographie ***

  REGRESSION
/DEPENDENT PK
/METHOD=ENTER Gender Age Education Political_interest.


*** Modell 2: + Mediennutzung ***

  REGRESSION
/STATISTICS ANOVA CHANGE
/DEPENDENT PK1
/METHOD=ENTER Gender Age Education Political_interest
/METHOD=ENTER TV Newspaper Websites Facebook Twitter.

*** Modellannahmen Modell 2 ***

  REGRESSION
/STATISTICS COEFF OUTS R ANOVA COLLIN TOL CHANGE
/DEPENDENT PK1
/METHOD=ENTER TV Newspaper Websites Facebook Twitter
/METHOD=ENTER Gender Age Education Political_interest
/SCATTERPLOT=(*ZRESID ,*ZPRED)
/RESIDUALS DURBIN HISTOGRAM(ZRESID).
