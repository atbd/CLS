#!/usr/bin/python
# -*-coding:utf-8 -*

def calculDistances(latitudes, longitudes):
	"""
		Calcul la distance grâce à des listes de toutes les latitudes et longitudes concernées (régatives pour S et W, positives pour N et E)

		Retourne un tableau de toutes les distances (en km)
	"""

	from math import acos, sin, cos, pi
	#import numpy as np

	R = 6378.137 # rayon de la Terre (sphère GRS80)
	# R = 6371.598 # (sphère de Picard)

	#deltaLat = [j-i for i,j in zip(latitudes[:-1], latitudes[1:])]
	deltaLon = [j-i for i,j in zip(longitudes[:-1], longitudes[1:])]

	a = [sin(j*pi/180)*sin(i*pi/180) for i,j in zip(latitudes[:-1], latitudes[1:])]

	b = [cos(j*pi/180)*cos(i*pi/180) for i,j in zip(longitudes[:-1], longitudes[1:])]

	c = [j*cos(i*pi/180) for i,j in zip(deltaLon, b)]

	return [R * acos(j+i) for i,j in zip(a,c)]



def calculVitesses(latitudes, longitudes, temps):
	"""
		latitudes et longitudes pareil que fonction au-dessus
		temps = liste contenant toutes les heures de transmission (en secondes)

		vitesses ("vit") sera en m/s
	"""

	deltaTemps = [(j-i) for i,j in zip(temps[:-1], temps[1:])]

	dist = calculDistances(latitudes, longitudes)

	vit = []

	for i in range(len(deltaTemps)):

		if deltaTemps[i] != 0:
			vit.append(1000 * dist[i]/deltaTemps[i])
		else:
			vit.append(0)

	#return [1000 * j/i for i,j in zip(deltaTemps, dist) if i != 0]
	return vit


def convertDateToSecond(dictDate):
	"""
		dictDate est un dictionnaire contenant jour, mois, année, heure, minutes
		Retourne la différence en seconde avec une date référence (1.1.2000 - 00:00:00)
	"""

	import datetime as dt

	ref = dt.datetime(2000, 1, 1, 0, 0, 0)

	aConv = dt.datetime(dictDate["annee"], dictDate["mois"], dictDate["jour"], dictDate["heure"], dictDate["min"], dictDate["sec"])

	return (aConv - ref).total_seconds()


def arrayOfTime():
	"""
		D'une liste de dictionnaire "dictDate" donnera une liste de temps en secondes (boucle de convertDateToSecond ?)
	"""










