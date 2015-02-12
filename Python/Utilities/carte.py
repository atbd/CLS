#!/usr/bin/python
# -*-coding:utf-8 -*

from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import numpy as np

def tracerCarte(longitudes, latitudes):
	"""
		Trace les coordonnées données en arguments.
	"""

	# on centre la carte sur une "coordonnée moyenne"
	monLon = sum(longitudes)/len(longitudes)
	monLat = sum(latitudes)/len(latitudes)

	m = Basemap(width=12000000,height=9000000,projection='lcc', lat_0=monLat, lon_0=monLon, resolution=None)
	m.etopo()

	# Tracé des méridiens et parallèles
	m.drawmeridians(np.arange(10,351,30), labels=[0,1,1,0])
	m.drawparallels(np.arange(0,90,10), labels=[1,0,0,1])

	xpt,ypt = m(longitudes,latitudes)
	m.plot(xpt,ypt,'r-')  

	plt.show()