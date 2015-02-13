#!/usr/bin/python
# -*-coding:utf-8 -*

from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import numpy as np

def tracerCarte(listLongitudes, listLatitudes, couleurs):
	"""
		Les arguments sont des listes de liste de longitudes et de latitudes, cela permet de tracer plusieurs trajectoires sur une seule carte.
	"""

	# on centre la carte sur une "coordonnée moyenne" (du premier élément des listes)
	monLon = sum(listLongitudes[0])/len(listLongitudes[0])
	monLat = sum(listLatitudes[0])/len(listLatitudes[0])

	m = Basemap(width=12000000,height=9000000,projection='lcc', lat_0=monLat, lon_0=monLon, resolution=None)
	m.etopo()

	# Tracé des méridiens et parallèles
	m.drawmeridians(np.arange(10,351,30), labels=[0,1,1,0])
	m.drawparallels(np.arange(0,90,10), labels=[1,0,0,1])

	for i in range(len(listLongitudes)):

		xpt,ypt = m(listLongitudes[i],listLatitudes[i])
		m.plot(xpt, ypt,couleurs[i]+'-')

	plt.show()