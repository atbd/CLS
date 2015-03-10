#!/usr/bin/python
# -*-coding:utf-8 -*

import Utilities.calcul as ut
import Utilities.suppVitesseExcess as sup
import Utilities.carte as mp
import RWFormats.lecture as rd
import RWFormats.nettoyage as laver
import RWFormats.recuperation as recup
import Utilities.comblerTrous as combl
import Utilities.estimation2 as est

from mpl_toolkits.basemap import Basemap

def filtrageDate(debut, fin, listeAChanger):
    """
    Pour le filtrage par date.
    """
    liste = listeAChanger

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

    return liste

def lectureListesEtId(path):
    """
        Fait la lecture à partir du path puis renvoi la liste de dico à la gui + identifiant.
    """
    if len(path) != 0:
        pathSplit = path.split(".")
        Format = pathSplit[-1].toUpper()
        identifiant = pathSplit[-2].split("/")[-1]

        if Format == "DIAG":
            liste = rd.lectureToutDiag(path)
            liste = laver.monsieurPropre(liste, "lat")
            liste = ut.correctionChoixLoc(liste)

        elif Format == "DS":
            liste = rd.lectureToutDS(path)

        elif Format == "CSV":
            liste = rd.lectureUnCSV(path)
            liste = ut.correctionChoixLoc(liste)

        else:
            print("Format de fichier non supporté.")

    return liste, identifiant


def toutEnUn(listeATraiter, debut, fin, choixFiltre, param):
    """
        Servira à tracer la carte sur la GUI.
    """
    liste = filtrageDate(debut, fin, listeATraiter)

    liste = sup.suppVitesseExcess(liste,recup.recuperation,ut.convertArrayOfTime,ut.calculVitesses,float(param["vitesse_max"])) # marche pas avec CSV: pas de LC
    
    if choixFiltre == 0 or choixFiltre == 1: # gauss ou epa
        liste = ut.regressionLineaire(choixFiltre + 1, liste, 0.2, recup.recuperation)
    elif choixFiltre == 2: # kalman
        liste = ut.kalman(liste, recup.recuperation, ut.convertArrayOfTime, ut.calculVitesses)
    
    liste = est.estimation2(liste, int(param["demi_fenetre_min_estim2"]), int(param["demi_fenetre_max_estim2"]), int(param["nb_pt_demi_fenetre_estim2"]), int(param["periode"]), int(param["min_estim2"]), recup.recuperation, ut.convertArrayOfTime, ut.kernel, combl.comblerTrous, ut.convertSecondToDatetime)

    latitudes = map(float, recup.recuperation(liste, "lat"))
    longitudes = map(float, recup.recuperation(liste, "lon"))
    temps = recup.recuperation(liste,"date")

    return latitudes, longitudes, temps

def saveRes(filesName, listLong, listLat, temps):
    """
        Créera un fichier .res pour chaque tracé sur la carte.
    """
    for i in xrange(len(filesName)):
        vitTotal = ut.calculVitesses(listLat[i], listLong[i], ut.convertArrayOfTime(temps[i]))
        vitLat, vitLon, direction = ut.vitLatEtLon(listLat[i], listLong[i], ut.convertArrayOfTime(temps[i]))

        with open("res/" + filesName[i] + ".res", "w") as f:
            f.write("Day    Time    Lon    Lat    VitLat(m/s)    VitLon(m/s)    Direction (degrees)    VitTotal (m/s)\n")
            for x in xrange(len(listLong[i]) - 1):
                f.write("%s.%s.%s    %s:%s:%s    %s    %s    %s    %s    %s    %s\n" % (temps[i][x]["jour"], temps[i][x]["mois"], temps[i][x]["annee"], temps[i][x]["heure"], temps[i][x]["min"], temps[i][x]["sec"], listLong[i][x], listLat[i][x], vitLat[x], vitLon[x], direction[x], vitTotal[x]))



































