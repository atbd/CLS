#!/usr/bin/python
# -*-coding:utf-8 -*

import Utilities.calcul as ut
import Utilities.suppVitesseExcess as sup
import Utilities.carte as mp
import RWFormats.lecture as rd
import RWFormats.nettoyage as laver
import RWFormats.recuperation as recup

# pour les cartes
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import numpy as np

path ="/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DIAG/10248.DIAG"

liste = rd.lectureToutDiag(path)
liste = laver.monsieurPropre(liste, "lat")
liste = ut.correctionChoixLoc(liste)
liste = sup.suppVitesseExcess(liste,recup.recuperation,ut.convertArrayOfTime,ut.calculVitesses,3)
#print(liste)

#liste = ut.regressionLineaire(1, liste, 0.1, recup.recuperation)
latitudes = map(float, recup.recuperation(liste, "lat"))
longitudes = map(float, recup.recuperation(liste, "lon"))
#print(latitudes)
#print(longitudes)

mp.tracerCarte(longitudes, latitudes)

