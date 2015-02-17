#!/usr/bin/python
# -*-coding:utf-8 -*

import Utilities.calcul as ut
import Utilities.suppVitesseExcess as sup
import Utilities.carte as mp
import RWFormats.lecture as rd
import RWFormats.nettoyage as laver
import RWFormats.recuperation as recup
from PyQt4.QtGui import QFileDialog

from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import numpy as np

"""
def toutEnUn(): #Servira à tracer la carte sur la GUI.

    # choix du fichier
    path = list(QtWidgets.QFileDialog.getOpenFileName())[0]
    #path = list(QtWidgets.QFileDialog.getOpenFileNames(None, "Choix un ou plusieurs fichiers", "", "(*.DIAG *.DS *.CSV)"))
    print(path)

    if len(path) != 0: 
        # pour diag
        liste = rd.lectureToutDiag(path)
        liste = laver.monsieurPropre(liste, "lat")
        liste = ut.correctionChoixLoc(liste)
        liste = sup.suppVitesseExcess(liste,recup.recuperation,ut.convertArrayOfTime,ut.calculVitesses,3)
        liste = ut.regressionLineaire(1, liste, 0.2, recup.recuperation)


        # pour tout
        latitudes = map(float, recup.recuperation(liste, "lat"))
        longitudes = map(float, recup.recuperation(liste, "lon"))


        mp.tracerCarte([longitudes],[latitudes], ["r"])

"""

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

def toutEnUn():
    """
        Servira à tracer la carte sur la GUI. 
    """
    # TODO: faire pour plusieurs fichiers

    # choix du fichier
    path = QFileDialog.getOpenFileName(None, "Choix de ou des fichier(s)", "", "(*.DIAG *.DS *.CSV)")
    #path = QtWidgets.QFileDialog.getOpenFileNames(None, "Choix un ou plusieurs fichiers", "", "(*.DIAG *.DS *.CSV)")
    #print(path)
    #input("Appuyez sur ENTREE pour fermer ce programme...")

    if len(path) != 0: 
        # pour diag
        liste = rd.lectureToutDiag(path)
        liste = laver.monsieurPropre(liste, "lat")
        liste = ut.correctionChoixLoc(liste)
        liste = sup.suppVitesseExcess(liste,recup.recuperation,ut.convertArrayOfTime,ut.calculVitesses,3)
        liste = ut.regressionLineaire(1, liste, 0.2, recup.recuperation)


        # pour tout
        latitudes = map(float, recup.recuperation(liste, "lat"))
        longitudes = map(float, recup.recuperation(liste, "lon"))


        #m = tracerCarte([longitudes],[latitudes], ["r"])

    return latitudes, longitudes

