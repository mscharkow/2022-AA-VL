* Encoding: UTF-8.
*** Encoding: UTF-8.

*** Encoding: UTF-8.
 ***

***VL5: GLM II***


*** Beispielstudie: Kuempel, A.S. (2019). Getting Tagged, Getting Involved with News?
    A Mixed-Methods Investigation of the Effects and Motives of News-Related Tagging Activities on Social Network Sites
    Journal of Communication,69,4. https://doi.org/10.1093/joc/jqz019 ***
*** Zugrundeliegende Daten: https://osf.io/8td9w/ => Study 1 Tagging_Data.sav ***

* Fragestellung: Unterscheidet sich die Rezeptionswahrscheinlich in sozialen Netzwerken anhand der Kurationsmodi (Post, Chronik, Tag, DM)?

*** Erstellung Dummy ***

SPSSINC CREATE DUMMIES VARIABLE=Kurationsmodus_SNS
ROOTNAME1=Modus
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

RENAME VARIABLES (Modus_1 Modus_2 Modus_3 Modus_4 = Modus_Post Modus_Chronik Modus_Tag Modus_DM).


*Variablen: UV: Modus_tag AV: Rezeptionswahrscheinlichkeit*

REGRESSION
  /DEPENDENT Rezeptionswahrscheinlichkeit
  /METHOD=ENTER Modus_Tag.

*** Variablen UV: Modi, AV: Rezeptionswahrscheinlichkeit ***

compute Modi = 0.
if (Modus_Post = 1) Modi = 1.
if (Modus_Chronik = 1) Modi = 2.
if (Modus_Tag = 1) Modi = 3.
if (Modus_DM = 1) Modi = 4.

freq Modi.

REGRESSION
  /DEPENDENT Rezeptionswahrscheinlichkeit
  /METHOD=ENTER Modi.

*** Bonus **

*** Umcodieren der String-Variablen in numerische (geht automatisch) ***

AUTORECODE VARIABLES=species
  /INTO species_neu
  /PRINT.


regression
    /DEPENDENT total_cup_points
    /Method=Enter species_neu.