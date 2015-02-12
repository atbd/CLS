#!/usr/bin/python
# -*-coding:utf-8 -*

import Utilities.calcul as ut
import Utilities.carte as mp
import RWFormats.lecture as rd
import RWFormats.nettoyage as laver
import RWFormats.recuperation as recup

# pour les cartes
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import numpy as np

path ="/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DIAG/25532.DIAG"
#path ="/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DS/119853.DS"

liste = rd.lectureToutDiag(path)
#liste = rd.lectureToutDS(path)

liste = laver.monsieurPropre(liste, "lat") #juste pour les diag
liste = ut.correctionChoixLoc(liste)
#print(liste)
liste = ut.regressionLineaire(1, liste, 0.1, recup.recuperation)
#latitudes = map(float, recup.recuperation(liste, "lat"))
#longitudes = map(float, recup.recuperation(liste, "lon"))
#print(latitudes)
#print(longitudes)

#tmp = recup.recuperation(liste, "date")
#temps = ut.convertArrayOfTime(tmp)
#print(temps)

#vitesses = ut.calculVitesses(latitudes, longitudes, temps)

mp.tracerCarte(longitudes, latitudes)
