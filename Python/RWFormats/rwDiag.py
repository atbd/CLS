#!/usr/bin/python
# -*-coding:utf-8 -*

#####################################################
#####################################################
                ### PARTIE LECTURE ###
#####################################################
#####################################################

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
                    data["nbMessSupp120dB"] = k[5]
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


#####################################################
#####################################################
                ### PARTIE ÉCRITURE ###
#####################################################
#####################################################


def ecritureUneTransmission(data): # pas encore testé

""" data doit contenir :
        - l'identifiant, date, heure, LC et IQ
        - lat1, lat2, lon1, lon2
        - nbr message + >120dB + bestLevel
        - Pass duration et NOPC
        - freq et altitude
        - autres chiffres ?
"""
    firstLine = " %d  Date : %s %s  LC : %d  IQ : %d \n" % (data["identifiant"], data["date"], data["heure"], data["LC"], data["IQ"])

    secondLine = "      Lat1 : %s  Lon1 : %s  Lat2 : %s  Lon2 : %s \n" % (data["lat1"], data["lon1"], data["lat2"], data["lon2"])

    thirdLine = "      Nb mes : %d  Nb mes>-120dB : %d  Best level : %d dB\n" % (data["nbrMess"], data["nbMessSupp120dB"], data["bestdb"])

    fourthLine = "      Pass duration : %ds  NOPC : %d\n" % (data["passDuration"], data["NOPC"])
    
    fifthLine = "      Calcul freq : %s Hz   Altitude :   %d m\n" % (data["freq"], data["altitude"])
    
    sixthLine = "                 00          00          00          00\n" # sais pas encore
    
    total = "\n" + firstLine + secondLine + thirdLine + fourthLine + fifthLine + sixthLine

    return total





















