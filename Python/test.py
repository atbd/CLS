#!/usr/bin/python
# -*-coding:utf-8 -*

import Utilities.calcul as ut
<<<<<<< HEAD
import Utilities.suppVitesseExcess as sup
=======
import Utilities.carte as mp
>>>>>>> origin/master
import RWFormats.lecture as rd
import RWFormats.nettoyage as laver
import RWFormats.recuperation as recup

<<<<<<< HEAD
#path ="/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DIAG/10248.DIAG"
path ="/Users/Benoit/Documents/GitHub/CLS/tortues/DIAG/10248.DIAG"

liste = rd.lectureToutDiag(path)
liste = laver.monsieurPropre(liste, "lat")
liste = ut.correctionChoixLoc(liste)
liste = sup.suppVitesseExcess(liste,recup.recuperation,ut.convertArrayOfTime,ut.calculVitesses,0.5)
=======
# pour les cartes
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import numpy as np

path ="/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DIAG/25532.DIAG"
#path ="/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DS/119853.DS"

liste = rd.lectureToutDiag(path)
#liste = rd.lectureToutDS(path)
>>>>>>> origin/master

liste = laver.monsieurPropre(liste, "lat") #juste pour les diag
liste = ut.correctionChoixLoc(liste)
#print(liste)
#liste = ut.regressionLineaire(2, liste, 0.1, recup.recuperation)
latitudes = map(float, recup.recuperation(liste, "lat"))
longitudes = map(float, recup.recuperation(liste, "lon"))
#print(latitudes)
#print(longitudes)

<<<<<<< HEAD
tmp = recup.recuperation(liste, "date")
temps = ut.convertArrayOfTime(tmp)

vitesses = ut.calculVitesses(latitudes, longitudes, temps)
print(vitesses)
=======
#tmp = recup.recuperation(liste, "date")
#temps = ut.convertArrayOfTime(tmp)
#print(temps)

#vitesses = ut.calculVitesses(latitudes, longitudes, temps)

mp.tracerCarte(longitudes, latitudes)
>>>>>>> origin/master
