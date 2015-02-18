#!/usr/bin/python
# -*-coding:utf-8 -*

import Utilities.calcul as ut
import Utilities.suppVitesseExcess as sup
import Utilities.carte as mp
import RWFormats.lecture as rd
import RWFormats.nettoyage as laver
import RWFormats.recuperation as recup

from mpl_toolkits.basemap import Basemap

def toutEnUn(path):
    """
        Servira à tracer la carte sur la GUI. 
    """
    #TODO: faire pour tout les formats

    if len(path) != 0: 
        Format = path.split(".")[-1].toUpper()

        if Format == "DIAG":
            liste = rd.lectureToutDiag(path)
            liste = laver.monsieurPropre(liste, "lat")
            liste = ut.correctionChoixLoc(liste)

        elif Format == "DS":
            liste = rd.lectureToutDS(path)

        elif Format == "CSV":
            liste = rd.lectureUnCSV(path)

        else:
            print("Format de fichier non supporté.")
            
        liste = sup.suppVitesseExcess(liste,recup.recuperation,ut.convertArrayOfTime,ut.calculVitesses,3)
        #liste = ut.regressionLineaire(1, liste, 0.2, recup.recuperation)

        latitudes = map(float, recup.recuperation(liste, "lat"))
        longitudes = map(float, recup.recuperation(liste, "lon"))

    return latitudes, longitudes

