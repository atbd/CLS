#!/usr/bin/python
# -*-coding:utf-8 -*

import Utilities.calcul as ut
import Utilities.suppVitesseExcess as sup
import Utilities.carte as mp
import RWFormats.lecture as rd
import RWFormats.nettoyage as laver
import RWFormats.recuperation as recup

from mpl_toolkits.basemap import Basemap

def toutEnUn(path, debut=0, fin=0):
    """
        Servira à tracer la carte sur la GUI.
    """
    #path = map(str, path)

    #print(path)

    if len(path) != 0:
        pathSplit = path.split(".")
        Format = pathSplit[-1].toUpper()
        identifiant = pathSplit[-2].split("/")[-1]

        if Format == "DIAG":
            liste = rd.lectureToutDiag(path)

            if debut != 0:
                for i in xrange(len(liste)):
                    tmp = ut.convertDateToSecond(liste[i]["date"])
                    if tmp >= debut:
                        liste = liste[i:]
                        break

            if fin != 0:
                for i in xrange(1,len(liste)):
                    tmp = ut.convertDateToSecond(liste[-i]["date"])
                    if tmp <= fin:
                        liste = liste[:-i+1]
                        break

            liste = laver.monsieurPropre(liste, "lat")
            liste = ut.correctionChoixLoc(liste)

        elif Format == "DS":
            liste = rd.lectureToutDS(path)

            if debut != 0:
                for i in xrange(len(liste)):
                    tmp = ut.convertDateToSecond(liste[i]["date"])
                    if tmp >= debut:
                        liste = liste[i:]
                        break

            if fin != 0:
                for i in xrange(1,len(liste)):
                    tmp = ut.convertDateToSecond(liste[-i]["date"])
                    if tmp <= fin:
                        liste = liste[:-i+1]
                        break

        elif Format == "CSV":
            liste = rd.lectureUnCSV(path)

            if debut != 0:
                for i in xrange(len(liste)):
                    tmp = ut.convertDateToSecond(liste[i]["date"])
                    if tmp >= debut:
                        liste = liste[i:]
                        break

            if fin != 0:
                for i in xrange(1,len(liste)):
                    tmp = ut.convertDateToSecond(liste[-i]["date"])
                    if tmp <= fin:
                        liste = liste[:-i+1]
                        break

            liste = ut.correctionChoixLoc(liste)

        else:
            print("Format de fichier non supporté.")

        liste = sup.suppVitesseExcess(liste,recup.recuperation,ut.convertArrayOfTime,ut.calculVitesses,3) # marche pas avec CSV: pas de LC
        liste = ut.regressionLineaire(1, liste, 0.2, recup.recuperation)

        latitudes = map(float, recup.recuperation(liste, "lat"))
        longitudes = map(float, recup.recuperation(liste, "lon"))
        #temps = [ut.convertDateToSecond(i) for i in recup.recuperation(liste,"date")]
        temps = recup.recuperation(liste,"date")

    return latitudes, longitudes, str(identifiant), temps

def saveRes(filesName, listLong, listLat, temps):
    """
        Créera un fichier .res pour chaque tracé sur la carte.
    """
    for i in xrange(len(filesName)):
        with open("res/" + filesName[i] + ".res", "w") as f:
            f.write("Day    Time    Lon    Lat\n") # voir quel autre section rajouter (vitesse?)
            for x in xrange(len(listLong[i])):
                f.write("%s.%s.%s   %s:%s:%s    %s    %s\n" % (temps[i][x]["jour"], temps[i][x]["mois"], temps[i][x]["annee"], temps[i][x]["heure"], temps[i][x]["min"], temps[i][x]["sec"], listLong[i][x], listLat[i][x]))



































