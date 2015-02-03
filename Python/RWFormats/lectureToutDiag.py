#!/usr/bin/python
# -*-coding:utf-8 -*

def lectureToutDiag(pathDiagFile, liste):
# pathDiagFile est le chemin d'accès au fichier .DIAG
# data est un dictionnaire qui contiendra les données d'une
#   seul transmission
# liste contiendra tous les dictionnaires

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
                    data["db"] = k[4].split(">")[1]
                    data["bestdb"] = k[8]

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


def lectureDossierDiag(folderPath, viveLesLuth):
# viveLesLuth contiendra un dictionnaire dont chaque entrée, identifié par l'identifiant 
# de l'émetteur, contiendra la liste correspondante (générée par lectureToutDiag())
#
# folderPath est le chemin du répertoire contenant tous les .DIAG 
# NB : ne pas oublier le "/" à la fin de folderPath

    from os import listdir

    diagFiles = listdir(folderPath)
    print(diagFiles)

    for (num, files) in enumerate(diagFiles,1):
        
        filePath = folderPath + diagFiles[num-1]
        tmp = []
        lectureToutDiag(filePath, tmp)

        identifiant = diagFiles[num-1].split(".")[0]

        viveLesLuth[identifiant] = tmp




























