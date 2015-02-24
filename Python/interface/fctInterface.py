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

    if len(path) != 0: 
        Format = path.split(".")[-1].toUpper()

        if Format == "DIAG":
            liste = rd.lectureToutDiag(path)
            
            if debut != 0:
                for i in range(len(liste)):
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
                for i in range(len(liste)):
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
                for i in range(len(liste)):
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

    return latitudes, longitudes

