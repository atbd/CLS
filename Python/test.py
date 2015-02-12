#!/usr/bin/python
# -*-coding:utf-8 -*

import Utilities.calcul as ut
import Utilities.suppVitesseExcess as sup
import RWFormats.lecture as rd
import RWFormats.nettoyage as laver
import RWFormats.recuperation as recup

#path ="/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DIAG/10248.DIAG"
path ="/Users/Benoit/Documents/GitHub/CLS/tortues/DIAG/10248.DIAG"

liste = rd.lectureToutDiag(path)
liste = laver.monsieurPropre(liste, "lat")
liste = ut.correctionChoixLoc(liste)
liste = sup.suppVitesseExcess(liste,recup.recuperation,ut.convertArrayOfTime,ut.calculVitesses,0.5)

latitudes = map(float, recup.recuperation(liste, "lat")) 
longitudes = map(float, recup.recuperation(liste, "lon")) 

tmp = recup.recuperation(liste, "date")
temps = ut.convertArrayOfTime(tmp)

vitesses = ut.calculVitesses(latitudes, longitudes, temps)
print(vitesses)
