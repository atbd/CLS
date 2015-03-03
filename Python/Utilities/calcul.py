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

def vitLat(latitudes, temps, f):
    vitesseLat = []
    for i in range(len(latitudes)-1):
        vitesseLat.append((latitudes[i+1]-latitudes[i])/(f(temps[i+1])-f(temps[i])))

    return vitesseLat

def vitLon(longitudes, temps; f):
    vitesseLon = []
    for i in range(len(longitudes)-1):
        vitesseLon.append((longitudes[i+1]-longitudes[i])/(f(temps[i+1])-f(temps[i])))

    return vitesseLon

def calculDistances(latitudes, longitudes):
    """
        Calcul la distance grâce à des listes de toutes les latitudes et longitudes concernées (régatives pour S et W, positives pour N et E)

        Retourne un tableau de toutes les distances (en km)
    """

    return [calculUneDistance(latitudes[i], latitudes[i+1], longitudes[i], longitudes[i+1]) for i in xrange(len(latitudes)-1)]


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

    for i in xrange(len(deltaTemps)):

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

    return [convertDateToSecond(arrayOfTime[i]) for i in xrange(len(arrayOfTime))]


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

    for i in xrange(len(formatCommun)-1):

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

    #h sert à délimiter le support du noyau d'epanechnikov
    tmp = []
    tpm={"lat":map(float,f(formatCommun, "lat")), "lon":map(float,f(formatCommun, "lon")), "date":f(formatCommun, "date"), "LC":f(formatCommun, "LC")}
    h = max([j-i for i,j in zip(tpm["lon"][:-2], tpm["lon"][2:])] + [j-i for i,j in zip(tpm["lat"][:-2], tpm["lat"][2:])])

    for i in xrange(len(formatCommun)):
            if tpm["LC"][i]=="A":
                tpm["LOC"]=1
            elif tpm["LC"][i]=="B":
                tpm["LOC"]=1
            elif tpm["LC"][i]=="Z":
                tpm["LOC"]=1
            elif tpm["LC"][i]=="1":
                tpm["LOC"]=2
            elif tpm["LC"][i]=="2":
                tpm["LOC"]=3
            elif tpm["LC"][i]=="3":
                tpm["LOC"]=7
            elif tpm["LC"][i]=="0":
                tpm["LOC"]=1.1
            else:
                tpm["LOC"]=0

    for i in xrange(2, len(formatCommun)-2): #on itère sur tous les points de la courbe sauf les 2 premiers et les derniers (à cause de la taille de la fenêtre)
        new_lat, new_lon, sum_lat, sum_lon = 0., 0., 0., 0.

        # initialisation
        a = kernel(choix, tpm["lat"][i] - tpm["lat"][i-2], h)
        b = kernel(choix, tpm["lon"][i] - tpm["lon"][i-2], h)

        for l in xrange(5): #on calcule les poids associés à chacune des positions dans la fenêtre (2 à gauche et 2 à droite) du point considéré, puis la position de ce point
            a, new_lat, sum_lat = kernel(choix, tpm["lat"][i] - tpm["lat"][i+l-2], h), new_lat + a*tpm["lat"][i+l-2], sum_lat + a
            b, new_lon, sum_lon = kernel(choix, tpm["lon"][i] - tpm["lon"][i+l-2], h), new_lon + b*tpm["lon"][i+l-2], sum_lon + b

        if sqrt((tpm["lat"][i]-(new_lat/sum_lat))**2 + (tpm["lon"][i]-(new_lon/sum_lon))**2) <= seuil: #on teste si la distance entre le point considéré et son estimée est inférieure à un seuil
            tmp += [{"lat":tpm["lat"][i+2], "lon":tpm["lon"][i+2], "date":tpm["date"][i+2], "LC":tpm["LC"][i+2]}]

    return [formatCommun[0], formatCommun[1]] + tmp + [formatCommun[-2], formatCommun[-1]]

def kalman(formatCommun ,f ,convertArrayOfTime, calculVitesses):
    import numpy as np
    from pykalman import KalmanFilter

    # recup temps
    temps = convertArrayOfTime(f(formatCommun, "date"))

    #for i in xrange(len(formatCommun)):
    lat=map(float,f(formatCommun, "lat"))
    lon=map(float,f(formatCommun, "lon"))

    # calcul vit
    vit = calculVitesses(lat, lon, temps)

    kf = KalmanFilter(initial_state_mean=[5,-50,0], n_dim_obs=3)
    measures = zip(lat,lon,vit)
    kf = kf.em(measures)
    (smoothed_state_means, smoothed_state_covariances) = kf.smooth(measures)
    for i in xrange(len(formatCommun) - 1):
        formatCommun[i]["lat"]=smoothed_state_means[i][0]
        formatCommun[i]["lon"]=smoothed_state_means[i][1]

    return formatCommun
