#!/usr/bin/python
# -*-coding:utf-8 -*

#####################################################
#####################################################
                ### PARTIE LECTURE ###
#####################################################
#####################################################

"""
    Chaque Luth sera identifié dans le dictionnaire par son numero de balise et donnera accès à la liste de données.
    Cette liste contiendra un dictionnaire pour chaque transmission, il contiendra :
        - date, heure, LC, IQ, latitudes et longitudes, infos sur les messages, durée, NOPC, fréquence et altitude. 
"""

def lectureToutDS(pathDSFile, liste):

	with open(pathDSFile,"r") as f:

		for line in f:
			k = filter(None,line.split(" "))

			if k == []: #on évite les lignes vides
				continue

			if len(k) >= 10:
				data = {}
				data["LC"] = k[5]
				data["date"] = k[6]
				data["heure"] = k[7]
				data["lat"] = k[8]
				data["lon"] = k[9]
				data["freq"] = k[11][:9]
				liste.append(data)
			else:
				continue

def lectureToutDiag(pathDiagFile, liste):
    """
        # pathDiagFile est le chemin d'accès au fichier .DIAG
        # data est un dictionnaire qui contiendra les données d'une
        #   seul transmission
        # liste contiendra tous les dictionnaires
    """

    with open(pathDiagFile, "r") as f:

        data = {}
        
        for (num, line) in enumerate(f,1):
            if num % 7 != 0:    #pour éviter la dernière ligne de chiffres

                tmp = line.strip()
                k = filter(None, tmp.split(" "))

                if k == []:     # on évite les lignes vides
                    continue
                
                k = [w for w in k if w != ":"]

                if (k[0].isdigit()):  
                    #data["num"] = k[0]
                    data["date"] = k[2]
                    data["heure"] = k[3]
                    data["LC"] = k[4]
                    data["IQ"] = k[6]

                elif tmp.startswith("Lat"):
                    data["lat1"] = k[1]
                    data["lon1"] = k[3]
                    data["lat2"] = k[5]
                    data["lon2"] = k[7]

                elif tmp.startswith("Nb"):
                    data["nbrMess"] = k[2]
                    data["nbMessSupp120dB"] = k[5]
                    data["bestdB"] = k[8]

                elif tmp.startswith("Pass"):
                    data["passDuration"] = k[2]
                    data["NOPC"] = k[4]

                elif tmp.startswith("Calcul"):
                    data["freq"] = k[2] + k[3]
                    data["altitude"] = k[6]
                else:
                    continue

            else:
                liste.append(data)
                data = {}


def lectureUnCSV(pathCSVFile, liste): # pas encore testé
    """
        pathCSVFile = chemin d'accès au fichier CSV
        liste = contient les dictionnaires contenant les données d'une transmission
    """
    import csv

    #name = pathCSVFile.split("/")[-1].split("-")[0]

    with open(pathCSVFile, "r") as txt:
        f = csv.reader(txt)

        for row in f:   # voir encadrant pour info sur ceux commentés + les données dans CSV que j'ai pas pris
            
            if row == [] or len(row) <= 15:
                continue
			
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


def lectureDossier(folderPath, viveLesLuth):
    """
        # viveLesLuth contiendra un dictionnaire dont chaque entrée, identifié par l'identifiant 
        # de l'émetteur, contiendra la liste correspondante (générée par lectureToutDiag())
        #
        # folderPath est le chemin du répertoire contenant tous les .DIAG 
        # NB : ne pas oublier le "/" à la fin de folderPath
    """

    from os import listdir

    Files = listdir(folderPath)

    for (num, files) in enumerate(Files,1):
        
        filePath = folderPath + Files[num-1]
        tmp = []

        Format = Files[num-1].split(".")[-1].upper()

        if  Format == "DIAG":
            lectureToutDiag(filePath, tmp)
            identifiant = Files[num-1].split(".")[0]

        elif Format == "DS":
            lectureToutDS(filePath,tmp)
            identifiant = Files[num-1].split(".")[0]

        elif Format == "CSV":
            lectureUnCSV(filePath, tmp)
            identifiant = Files[num-1].split("-")[0]
            
        elif Format == "XML":
            # à faire
            continue

        viveLesLuth[identifiant] = tmp



liste = {}
path = "../../tortues/CSV/"
lectureDossier(path, liste)
print(liste)













