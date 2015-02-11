#!/usr/bin/python
# -*-coding:utf-8 -*
from numpy import *

def calculDistances(latitudes, longitudes): 
	"""
		Calcul la distance grâce à des listes de toutes les latitudes et longitudes concernées (régatives pour S et W, positives pour N et E)

		Retourne un tableau de toutes les distances (en km)
	"""
	
	""" En dessous : fonctionne mais mieux calculer un par un pour correction loc

	from math import acos, sin, cos, pi

	R = 6378.137 # rayon de la Terre en km(sphère GRS80)
	# R = 6371.598 # (sphère de Picard)

	deltaLon = [j-i for i,j in zip(longitudes[:-1], longitudes[1:])]

	a = [sin(j*pi/180)*sin(i*pi/180) for i,j in zip(latitudes[:-1], latitudes[1:])]

	b = [cos(j*pi/180)*cos(i*pi/180) for i,j in zip(latitudes[:-1], latitudes[1:])]

	c = [j*cos(i*pi/180) for i,j in zip(deltaLon, b)]

	return [R * acos(j+i) for i,j in zip(a,c)]
	"""

	return [calculUneDistance(latitudes[i], latitudes[i+1], longitudes[i], longitudes[i+1]) for i in range(len(latitudes)-1)]


def calculUneDistance(latitude1, latitude2, longitude1, longitude2):
	"""
		Calcul une distance. 
	"""

	from math import acos, sin, cos, pi

	R = 6378.137 # rayon de la Terre en km(sphère GRS80)
	# R = 6371.598 # (sphère de Picard)

	deltaLon = longitude2 - longitude1

	a = sin(latitude1*pi/180)*sin(latitude2*pi/180)
	b = cos(latitude1*pi/180)*cos(latitude2*pi/180)*cos(deltaLon*pi/180)

	return R * acos(a + b)



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
			vit.append(1000*dist[i]/deltaTemps[i])
		else:
			vit.append(0)

	return vit


def convertDateToSecond(dictDate):
	"""
		dictDate est un dictionnaire contenant jour, mois, année, heure, minutes
		Retourne la différence en seconde avec une date référence (1.1.2000 - 00:00:00)
	"""

	import datetime as dt

	ref = dt.datetime(2000, 1, 1, 0, 0, 0)

	aConv = dt.datetime(int(dictDate["annee"]), int(dictDate["mois"]), int(dictDate["jour"]), int(dictDate["heure"]), int(dictDate["min"]), int(dictDate["sec"]))

	return (aConv - ref).total_seconds()


def convertArrayOfTime(arrayOfTime): 
	"""
		D'une liste de dictionnaire "dictDate" donnera une liste de temps en secondes (boucle de convertDateToSecond ?)
	"""

	return [convertDateToSecond(arrayOfTime[i]) for i in range(len(arrayOfTime))]


def kernel(choix,valeur,h):
	"""
		Cette fonction permet de choisir le kernel souhaité pour pondérer le
poids des observations lors de la régression linéaire
choix 1 = epanechnikov
choix 2 = gaussien
choix par défaut = gaussien
	"""
	from math import pi, sqrt, exp
	valeur = array(valeur) 
	h = array(h)

	if choix == 2:
		return 1/sqrt(2*pi)*exp(-1/2*valeur**2)

	elif choix == 1:
		if (valeur<-h or valeur>h):
			return 0
		else:
			return (3/4/h)*(1-(valeur/h)**2)
	else:
		return 1/sqrt(2*pi)*exp(-1/2*valeur**2)


def correctionChoixLoc(formatCommun):
	"""
		Prend en entrée les données (sorties des fichiers) au format commun (liste de dico) ainsi que la fonction recuperation de RWFormats.
		En sortie donne les données corrigées avec seulement une paire de latitudes/longitudes.

		NB : ne sera utile que pour les .DIAG
	"""

	donneeCorrigee = formatCommun

	# initialisation
	latPr = float(donneeCorrigee[0]["lat"])
	lonPr = float(donneeCorrigee[0]["lon"])

	for i in range(len(formatCommun)-1):

		# suivantes pour calculer les distances
		lat = float(donneeCorrigee[i+1]["lat"])
		lon = float(donneeCorrigee[i+1]["lon"])
		lat_im = float(donneeCorrigee[i+1]["lat_image"])
		lon_im = float(donneeCorrigee[i+1]["lon_image"])

		# calcul des distances
		tmp = calculUneDistance(latPr, lat, lonPr, lon)
		tmp_im = calculUneDistance(latPr, lat_im, lonPr, lon_im)

		# si la loc image est la bonne -> remplacement
		if tmp > tmp_im:
			donneeCorrigee[i+1]["lat"] = donneeCorrigee[i+1]["lat_image"]
			donneeCorrigee[i+1]["lon"] = donneeCorrigee[i+1]["lon_image"]

		# suppression des inutiles
		del donneeCorrigee[i+1]["lat_image"]
		del donneeCorrigee[i+1]["lon_image"]

		# "rebouclage"
		latPr = float(donneeCorrigee[i+1]["lat"])
		lonPr = float(donneeCorrigee[i+1]["lon"])

	return donneeCorrigee

def regressionLineaire(choix, formatCommun, seuil): # pas encore testée
	"""
		Cette fonction retire les localisations pour lesquelles la localisation
estimée est trop éloignée de la position mesurée
	"""

	h = 0
	for i in range(len(formatCommun))[1:]:
		h = max(h,formatCommun[i]["lat"]-formatCommun[i-2]["lat"])
	for i in range(len(formatCommun))[1:]:
		h = max(h,formatCommun[i]["lon"]-formatCommun[i-2]["lon"])


	k = []
	donneeRegressee = {}
	lat_clean = []
	lon_clean = []
	date_clean = []
	new_lat = 0
	new_lon = 0
	lat_reg = []
	lon_reg = []
	latitudes = formatCommun["lat"]
	longitudes = formatCommun["lon"]

	for i in range(len(latitudes)-2)[2:]:
		k = kernel(choix,latitudes[i-2:i+2],h)
		for j in range(5):
			new_lat = new_lat + k[j]*latitudes[j]
		new_lat = new_lat/sum(k)
		lat_reg[i] = new_lat

	for i in range(len(longitudes)-2)[2:]:
		k = kernel(choix,longitudes[i-2:i+2],h)
		for j in range(5):
			new_lon = new_lat + k[j]*longitudes[j]
		new_lon = new_lon/sum(k)
		lon_reg[i] = new_lon
		
	for i in range(len(longitudes)-2)[2:]:
		if lat[i]-new_lat[i]<=seuil and lon[i]-new_lon[i]<=seuil:
			lat_clean.append(lat[i])
			lon_clean.append(lon[i])
			date_clean.append(formatCommun["date"][i])
			
	donneeRegresse["lat"] = lat_clean
	donneeRegresse["lon"] = lon_clean
	donneeRegresse["date"] = date_clean
	return donneeRegressee
