#!/usr/bin/python
# -*-coding:utf-8 -*

def recuperation(formatCommun, key):
	"""
		Prend le format commun en entrée (liste de dico pour une tortue), la clé permet de sélectionner le type de valeur.
		key possible : lat1, lon1, lat2, lon2, date, LC...
	"""

	return [formatCommun[i][key] for i in range(len(formatCommun))]
