#!/usr/bin/python
# -*-coding:utf-8 -*

import Utilities.calcul as ut
import Utilities.suppVitesseExcess as sup
import Utilities.carte as mp
import RWFormats.lecture as rd
import RWFormats.nettoyage as laver
import RWFormats.recuperation as recup

<<<<<<< HEAD
# pour les cartes
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import numpy as np

#path ="/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DIAG/10248.DIAG"
path ="/home/jcombani/3A/Projet long/tortues/DIAG/10248.DIAG"

=======
path ="/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DIAG/25532.DIAG"
>>>>>>> d18dfe69e834f3efd7a9d5c00d9e0fa76bec559b

liste = rd.lectureToutDiag(path)
liste = laver.monsieurPropre(liste, "lat")
liste = ut.correctionChoixLoc(liste)
liste = sup.suppVitesseExcess(liste,recup.recuperation,ut.convertArrayOfTime,ut.calculVitesses,3)
print(len(liste))

latitudes = map(float, recup.recuperation(liste, "lat"))
longitudes = map(float, recup.recuperation(liste, "lon"))

liste = ut.regressionLineaire(1, liste, 0.2, recup.recuperation)
print(len(liste))

latitudes2 = map(float, recup.recuperation(liste, "lat"))
longitudes2 = map(float, recup.recuperation(liste, "lon"))


mp.tracerCarte([longitudes, longitudes2],[latitudes, latitudes2], ["b", "r"])

