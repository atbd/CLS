#!/usr/bin/python
# -*-coding:utf-8 -*

def monsieurPropre(formatCommun, key):
	"""
		formatCommun : liste de dico pour une tortue/élephant
		Nettoyage des données :
			- enlever "???" en coord des fichiers diag
			- enlever loc vide
			- ...

		Retourne le tableau nettoyé.
	"""

	# pour fichiers diag
	tmp = []

	for i in range(len(formatCommun)):
		if "?" in formatCommun[i][key]:
			continue
		else:
			tmp.append(formatCommun[i])

	return tmp
