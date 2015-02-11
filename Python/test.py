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

liste = rd.lectureToutDiag(path)
liste = laver.monsieurPropre(liste, "lat")
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

lon, lat = longitudes, latitudes # Location of Boulder
#lon, lat = [-50.9, -51.2], [6.5,6.3]
# convert to map projection coords.
# Note that lon,lat can be scalars, lists or numpy arrays.
xpt,ypt = m(lon,lat)
# convert back to lat/lon
lonpt, latpt = m(xpt,ypt,inverse=True)
m.plot(xpt,ypt,'ro')  # plot a blue dot there

plt.show()
