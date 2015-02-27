#!/usr/bin/python
# -*-coding:utf-8 -*
"""
pykalman depends on the following modules,

    numpy (for core functionality)
    scipy (for core functionality)
    Sphinx (for generating documentation)
    numpydoc (for generating documentation)
    nose (for running tests)
"""

def calculDistances(latitudes, longitudes):
	"""
		Calcul la distance grâce à des listes de toutes les latitudes et longitudes concernées (régatives pour S et W, positives pour N et E)

		Retourne un tableau de toutes les distances (en km)
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


def convertSecondToDatetime(totalSecond):
    """
        Cette fonction prend en entrée le résultat d'un .total_seconds() et ressort un dico au format "date" du format commun.
    """
    import datetime as dt

    ref = dt.datetime(2000,1,1,0,0,0)
    date = ref + dt.timedelta(seconds=totalSecond)

    return {"annee":date.year, "mois":date.month, "jour":date.day, "heure":date.hour, "min":date.minute, "sec":date.second}

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
		D'une liste de dictionnaire "dictDate" donnera une liste de temps en secondes (boucle de convertDateToSecond)
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

def regressionLineaire(choix, formatCommun, seuil, f):
	"""
		Cette fonction retire les localisations pour lesquelles la localisation
estimée est trop éloignée de la position mesurée
	"""
	from math import pi, sqrt, exp
	h = 0 #h sert à délimiter le support du noyau d'epanechnikov
	for i in range(len(formatCommun))[1:]:
		h = max(h,float(formatCommun[i]['lon'])-float(formatCommun[i-2]['lon']),float(formatCommun[i]['lat'])-float(formatCommun[i-2]['lat']))

	donneeRegressee = []
	lat_clean = []
	lon_clean = []
	date_clean = []
	lc_clean = []
	lat_reg = []
	lon_reg = []

	for i in range(2): #on rajoute les 2 premières positions
		tpm={}
		tpm["lat"]=f(formatCommun, "lat")[i]
		tpm["lon"]=f(formatCommun, "lon")[i]
		tpm["date"]=f(formatCommun, "date")[i]
		tpm["LC"]=f(formatCommun, "LC")[i]
		donneeRegressee.append(tpm)

	for i in range(len(f(formatCommun, "lat"))-2)[2:]: #on itère sur tous les points de la courbe sauf les 2 premiers et les derniers (à cause de la taille de la fenêtre)
		new_lat = 0.
		new_lon = 0.
		k = []
		p = []

		for l in range(5): #on calcule les poids associés à chacune des positions dans la fenêtre (2 à gauche et 2 à droite) du point considéré, puis la position de ce point
			k.append(kernel(choix,float(f(formatCommun, "lat")[i]) - float(f(formatCommun, "lat")[i+l-2]), h))
			p.append(kernel(choix,float(f(formatCommun, "lon")[i]) - float(f(formatCommun, "lon")[i+l-2]), h))
			new_lat = new_lat + k[l]*float(f(formatCommun, "lat")[i+l-2])
			new_lon = new_lon + p[l]*float(f(formatCommun, "lon")[i+l-2])
		new_lat = new_lat/sum(k)
		lat_reg.append(new_lat)
		new_lon = new_lon/sum(p)
		lon_reg.append(new_lon)

		tmp={}
		if sqrt((float(f(formatCommun, "lat")[i])-lat_reg[i-2])**2 + (float(f(formatCommun, "lon")[i])-lon_reg[i-2])**2) <=seuil: #on teste si la distance entre le point considéré et son estimée est inférieure à un seuil
			tmp["lat"]=(f(formatCommun, "lat")[i+2])
			tmp["lon"]=(f(formatCommun, "lon")[i+2])
			tmp["date"]=(f(formatCommun, "date")[i+2])
			tmp["LC"]=(f(formatCommun, "LC")[i+2])
			donneeRegressee.append(tmp)

	for i in range(2): #on rajoute les 2 dernières positions
		m=2-i
		tpm={}
		tpm["lat"]=f(formatCommun, "lat")[-m]
		tpm["lon"]=f(formatCommun, "lon")[-m]
		tpm["date"]=f(formatCommun, "date")[-m]
		tpm["LC"]=f(formatCommun, "LC")[-m]
		donneeRegressee.append(tpm)

	return donneeRegressee

def kalman(formatCommun,vit,f):
	import numpy as np
	#from scipy import *
	#from Sphinx import *
	#from numpydoc import *
	#from nose import *
	from pykalman import KalmanFilter
	for i in range(len(formatCommun)):
		lat=f(formatCommun, "lat")[i]
		lon=f(formatCommun, "lon")[i]

	kf = KalmanFilter(initial_state_mean=[5,-50,0], n_dim_obs=3)
	measures = zip(lat,lon,vit)
	kf = kf.em(measures)
	(smoothed_state_means, smoothed_state_covariances) = kf.smooth(measures)
	for i in range(len(formatCommun)):
		formatCommun[i]["lat"]=smoothed_state_means[i][0]
		formatCommun[i]["lon"]=smoothed_state_means[i][1]
	
	return formatCommun
