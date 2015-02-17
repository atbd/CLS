#!/usr/bin/python
# -*-coding:utf-8 -*
# from numpy import *

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

	if (a+b>1):
		return 0
	else:
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
	valeur = float(valeur) 
	h = float(h)

	if choix == 2:
		res = 1.0/sqrt(2.0*pi)*exp(-1.0/2.0*valeur**2)
		return res

	elif choix == 1:
		if (valeur<-h or valeur>h):
			return 0.0
		else:
			res = (3.0/4.0/h)*(1.0-(valeur/h)**2)
			return res
	else:
		res = 1.0/sqrt(2.0*pi)*exp(-1.0/2.0*valeur**2)
		return res


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

def regressionLineaire(choix, formatCommun, seuil, f): # pas encore testée
	"""
		Cette fonction retire les localisations pour lesquelles la localisation
estimée est trop éloignée de la position mesurée
	"""

	h = 0
	for i in range(len(formatCommun))[1:]:
		h = max(h,float(formatCommun[i]['lat'])-float(formatCommun[i-2]['lat']))
	for i in range(len(formatCommun))[1:]:
		h = max(h,float(formatCommun[i]['lon'])-float(formatCommun[i-2]['lon']))

	donneeRegressee = []
	lat_clean = []
	lon_clean = []
	date_clean = []
	lc_clean = []
	lat_reg = []
	lon_reg = []
	#latitudes = formatCommun['lat']
	#longitudes = formatCommun['lon']

	for i in range(len(f(formatCommun, "lat"))-2)[2:]:
		new_lat = 0.
		new_lon = 0.
		k = []
		p = []
		for l in range(5):
			k.append(kernel(choix,float(f(formatCommun, "lat")[i]) - float(f(formatCommun, "lat")[i+l-2]), h))
			p.append(kernel(choix,float(f(formatCommun, "lon")[i]) - float(f(formatCommun, "lon")[i+l-2]), h))
		for j in range(5):
			new_lat = new_lat + k[j]*float(f(formatCommun, "lat")[i+j-2])
			new_lon = new_lon + p[j]*float(f(formatCommun, "lon")[i+j-2])
		new_lat = new_lat/sum(k)
		lat_reg.append(new_lat)
		new_lon = new_lon/sum(p)
		lon_reg.append(new_lon)

	for i in range(len(lon_reg)):
		if float(f(formatCommun, "lat")[i+2])-lat_reg[i]<=seuil and float(f(formatCommun, "lon")[i+2])-lon_reg[i]<=seuil:
			lat_clean.append(f(formatCommun, "lat")[i+2])
			lon_clean.append(f(formatCommun, "lon")[i+2])
			date_clean.append(f(formatCommun, "date")[i+2])
			lc_clean.append(f(formatCommun, "LC")[i+2])
	
	for i in range(len(lat_clean)):
		tmp={}
		tmp["lat"]=lat_clean[i]
		tmp["lon"]=lon_clean[i]
		tmp["date"]=date_clean[i]
		tmp["LC"]=lc_clean[i]	
		donneeRegressee.append(tmp)

	#print(len(lon_reg))
	#print(len(f(formatCommun, "lon")))
	
	return donneeRegressee
