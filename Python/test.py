#!/usr/bin/python
# -*-coding:utf-8 -*

import Utilities.calcul as ut
import RWFormats.lecture as rd
import RWFormats.nettoyage as laver
import RWFormats.recuperation as recup
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

latitudes = map(float, recup.recuperation(liste, "lat"))
longitudes = map(float, recup.recuperation(liste, "lon"))
#latitudes, longitudes = ut.regressionLineaire(2, latitudes, longitudes, [], 1)
#print(latitudes)
#print(longitudes)

#tmp = recup.recuperation(liste, "date")
#temps = ut.convertArrayOfTime(tmp)
#print(temps)

#vitesses = ut.calculVitesses(latitudes, longitudes, temps)

m = Basemap(width=12000000,height=9000000,projection='lcc',
            resolution=None,lat_1=10.,lat_2=20,lat_0=30,lon_0=-30.)
m.etopo()

parallels = np.arange(0.,81,10.)
m.drawparallels(parallels,labels=[False,True,True,False])

meridians = np.arange(10.,351.,20.)
m.drawmeridians(meridians,labels=[True,False,False,True])

xpt,ypt = m(longitudes,latitudes)
m.plot(xpt,ypt,'ro')  # plot a blue dot there

plt.show()
