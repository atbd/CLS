#!/usr/bin/python
# -*-coding:utf-8 -*

import Utilities.calcul as ut
import Utilities.suppVitesseExcess as sup
import Utilities.carte as mp
import RWFormats.lecture as rd
import RWFormats.nettoyage as laver
import RWFormats.recuperation as recup

#fichierTest1 = open("fichierTest1.txt", "w")
#fichierTest2 = open("fichierTest2.txt", "w")

# pour les cartes
# from mpl_toolkits.basemap import Basemap
# import matplotlib.pyplot as plt
# import numpy as np

path ="/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DIAG/25532.DIAG"
#path ="/home/jcombani/3A/Projet long/tortues/DIAG/10248.DIAG"
#path = "/Users/Benoit/Documents/GitHub/CLS/tortues/DIAG/10248.DIAG"

#path ="/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DIAG/25532.DIAG"
#path ="/home/jcombani/3A/Projet long/tortues/DIAG/10248.DIAG"
#path2 = "/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DIAG/TEST1.DIAG"
#path = "/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DIAG/TEST - Copie.DIAG"
liste = rd.lectureToutDiag(path)
print(len(liste))
"""
liste = laver.monsieurPropre(liste, "lat")
liste = ut.correctionChoixLoc(liste)
liste = sup.suppVitesseExcess(liste,recup.recuperation,ut.convertArrayOfTime,ut.calculVitesses,3)

lat = map(float, recup.recuperation(liste,'lat'))
lon = map(float, recup.recuperation(liste,'lon'))
tps = ut.convertArrayOfTime(recup.recuperation(liste,"date"))
vit = ut.calculVitesses(lat,lon,tps)

#res = ut.kalman(lat, lon, vit)
#print(res[2][0])
#lats = [res[i][0] for i in range(len(res))]
#lons = [res[i][1] for i in range(len(res))]

liste2 = rd.lectureToutDiag(path2)
lats = map(float, recup.recuperation(liste2, "lat"))
lons = map(float, recup.recuperation(liste2, "lon"))

mp.tracerCarte([lon,lons],[lat,lats],["r","b"])
"""
"""
for j in range(len(liste)):
	fichierTest1.write(str(lat[j]))
	fichierTest1.write("\n")
	fichierTest2.write(str(lon[j]))
	fichierTest2.write("\n")

fichierTest1.close()
fichierTest2.close()
"""

# liste = ut.regressionLineaire(2, liste, 0.02, recup.recuperation)
# print(len(liste))
# latitudes = map(float, recup.recuperation(liste, "lat"))
# longitudes = map(float, recup.recuperation(liste, "lon"))
# #print(latitudes)
# #print(longitudes)

# mp.tracerCarte(longitudes, latitudes)
"""
print(len(liste))

latitudes = map(float, recup.recuperation(liste, "lat"))
longitudes = map(float, recup.recuperation(liste, "lon"))

liste = ut.regressionLineaire(1, liste, 0.2, recup.recuperation)
print(len(liste))

latitudes2 = map(float, recup.recuperation(liste, "lat"))
longitudes2 = map(float, recup.recuperation(liste, "lon"))

mp.tracerCarte([longitudes, longitudes2],[latitudes, latitudes2], ["b", "r"])
"""

