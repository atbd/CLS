#!/usr/bin/python
# -*-coding:utf-8 -*

import Utilities.calcul as ut
import RWFormats.lecture as rd
import RWFormats.nettoyage as laver
import RWFormats.recuperation as recup

path ="/Users/atnd/Documents/ENSEEIHT/ProjetLong/CLS/tortues/DIAG/10248.DIAG"

liste = rd.lectureToutDiag(path)
liste = laver.monsieurPropre(liste, "lat")

latitudes = map(float, recup.recuperation(liste, "lat")) # changer lat1 -> lat plus tard
longitudes = map(float, recup.recuperation(liste, "lon")) # lon1 -> lon

tmp = recup.recuperation(liste, "date")
temps = ut.convertArrayOfTime(tmp)
#print(temps)

vitesses = ut.calculVitesses(latitudes, longitudes, temps)

print(vitesses)
