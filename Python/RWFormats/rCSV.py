#!/usr/bin/python
# -*-coding:utf-8 -*

#####################################################
#####################################################
                ### PARTIE LECTURE ###
#####################################################
#####################################################

def lectureUnCSV(pathCSVFile, liste): # pas encore testé
	"""
		pathCSVFile = chemin d'accès au fichier CSV
		liste = contient les dictionnaires contenant les données d'une transmission
	"""
	import csv

	#name = pathCSVFile.split("/")[-1].split("-")[0]

	with open("pathCSVFile", "r") as txt:
		f = csv.reader(txt)

		for row in f:	# voir encadrant pour info sur ceux commentés + les données dans CSV que j'ai pas pris
			
			data = {}
			row = filter(None, row)
			
			data["date"] = row[1]
			data["heure"] = row[2]
			#data["LC"] = 
			#data["IQ"] = 
			data["lat1"] = row[9]
			data["lon1"] = row[10]
			data["lat2"] = row[12]
			data["lon2"] = row[13]
			data["nbrMess"] = row[3]
			#data["nbMessSupp120dB"] = 
			#data["bestdB"] = 
			data["passDuration"] = row[4] # time Offset ?
			#data["NOPC"] = 
			#data["freq"] = 
			#data["altitude"] = 

			liste.append(data)


def lectureDossierCSV(pathDossierCSV, viveLesLuth):
	# viveLesLuth contiendra un dictionnaire dont chaque entrée, identifié par l'identifiant 
    # de l'émetteur, contiendra la liste correspondante (générée par lectureUnCSV())
    #
    # folderPath est le chemin du répertoire contenant tous les .CSV
    # NB : ne pas oublier le "/" à la fin de pathDossierCSV

    from os import listdir

    csvFiles = listdir(pathCSVFile)

    for (num, files) in enumerate(csvFiles,1):
        
        filePath = folderPath + csvFiles[num-1]
        tmp = []
        lectureUnCSV(filePath, tmp)

        identifiant = csvFiles[num-1].split("-")[0]

        viveLesLuth[identifiant] = tmp






























