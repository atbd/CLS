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

def lectureToutDS(pathDSFile):

    liste = []

    with open(pathDSFile,"r") as f:

        for line in f:
            k = filter(None,line.split(" "))

            if k == []: #on évite les lignes vides
                continue

            if len(k) >= 10:
                data = {}
                dat = {}
                data["LC"] = k[5]
                tmp = k[6].split("-")
                tmp2 = k[7].split(":")
                dat["annee"] = tmp[0]
                dat["mois"] = tmp[1]
                dat["jour"] = tmp[2]
                dat["heure"] = tmp2[0]
                dat["min"] = tmp2[1]
                dat["sec"] = tmp2[2]
                data["date"] = dat
                data["lat"] = k[8]
                data["lon"] = k[9]
                #data["freq"] = k[11][:9]
                liste.append(data)
            else:
                continue

    return liste



def lectureToutDiag(pathDiagFile):
    """
        # pathDiagFile est le chemin d'accès au fichier .DIAG
        # data est un dictionnaire qui contiendra les données d'une
        #   seul transmission
        # liste contiendra tous les dictionnaires
    """

    liste = []

    with open(pathDiagFile, "r") as f:

        data,dat = {},{}

        for (num, line) in enumerate(f,1):
            #if num % 7 != 0:    #pour éviter la dernière ligne de chiffres

            tmp = line.strip()
            k = filter(None, tmp.split(" "))

            #    if k == []:     # on évite les lignes vides
            #        continue

            if k != []:

                k = [w for w in k if w != ":"]

                if (k[0].isdigit() and len(k) > 4):
                    #data["num"] = k[0]
                    tmp = k[2].split(".")
                    tmp2 = k[3].split(":")
                    dat["annee"] = "20"+tmp[2]
                    dat["mois"] = tmp[1]
                    dat["jour"] = tmp[0]
                    dat["heure"] = tmp2[0]
                    dat["min"] = tmp2[1]
                    dat["sec"] = tmp2[2]
                    data["date"] = dat
                    data["LC"] = k[5]
                    #data["IQ"] = k[7]

                elif tmp.startswith("Lat"):

                    if k[1][-1] == "N":
                        data["lat"] = k[1][:-1]
                    else:
                        data["lat"] = "-"+k[1][:-1]

                    if k[3][-1] == "E":
                        data["lon"] = k[3][:-1]
                    else:
                        data["lon"] = "-"+k[3][:-1]

                    if k[5][-1] == "N":
                        data["lat_image"] = k[5][:-1]
                    else:
                        data["lat_image"] = "-"+k[5][:-1]

                    if k[7][-1] == "E":
                        data["lon_image"] = k[7][:-1]
                    else:
                        data["lon_image"] = "-"+k[7][:-1]

                else:
                    continue

            elif (k == [] and num != 1):
                liste.append(data)
                data,dat = {},{}

    return liste


def lectureUnCSV(pathCSVFile):
    """
        pathCSVFile = chemin d'accès au fichier CSV
        liste = contient les dictionnaires contenant les données d'une transmission
    """
    import csv

    #name = pathCSVFile.split("/")[-1].split("-")[0]
    liste = []

    with open(pathCSVFile, "r") as txt:
        f = csv.reader(txt)

        for row in f:   # voir encadrant pour info sur ceux commentés + les données dans CSV que j'ai pas pris
            row = filter(None, row)
            if row == [] or len(row) <= 15 or row[0].startswith("Name"):
                continue
            data = {}
            dat = {}
            tmp = row[1].split("-")
            tmp2 = row[2].split(":")
            dat["annee"] = tmp[2]
            mois = tmp[1].upper()
            if mois == "JAN":
                tmp[1] = "01"
            elif mois == "FEB":
                tmp[1] = "02"
            elif mois == "MAR":
                tmp[1] = "03"
            elif mois == "APR":
                tmp[1] = "04"
            elif mois == "MAY":
                tmp[1] = "05"
            elif mois == "JUN":
                tmp[1] = "06"
            elif mois == "JUL":
                tmp[1] = "07"
            elif mois == "AUG":
                tmp[1] = "08"
            elif mois == "SEP":
                tmp[1] = "09"
            elif mois == "OCT.":
                tmp[1] = "10"
            elif mois == "NOV":
                tmp[1] = "11"
            elif mois == "DEC":
                tmp[1] = "12"
            dat["mois"] = tmp[1]
            dat["jour"] = tmp[0]
            dat["heure"] = tmp2[0]
            dat["min"] = tmp2[1]
            dat["sec"] = tmp2[2]
            data["date"] = dat
            #data["LC"] =
            #data["IQ"] =
            #data["lat1"] = row[9]
            #data["lon1"] = row[10]
            #data["lat2"] = row[12]
            #data["lon2"] = row[13]
            data["nbrMess"] = row[3]
            #data["nbMessSupp120dB"] =
            #data["bestdB"] =
            data["passDuration"] = row[4] # time Offset ?
            #data["NOPC"] =
            #data["freq"] =
            #data["altitude"] =
            #data["LC"] =
            #data["IQ"] =
            data["lat"] = row[9]
            data["lon"] = row[10]
            data["lat_image"] = row[12]
            data["lon_image"] = row[13]
            #data["nbrMess"] = row[3]
            #data["nbMessSupp120dB"] =
            #data["bestdB"] =
            #data["passDuration"] = row[4] # time Offset ?
            #data["NOPC"] =
            #data["freq"] =
            #data["altitude"] =
            liste.append(data)

    return liste


def lectureDossier(folderPath):
    """
        # viveLesLuth contiendra un dictionnaire dont chaque entrée, identifié par l'identifiant
        # de l'émetteur, contiendra la liste correspondante (générée par lectureToutDiag())
        #
        # folderPath est le chemin du répertoire contenant tous les .DIAG
        # NB : ne pas oublier le "/" à la fin de folderPath
    """

    from os import listdir

    viveLesLuth = {}
    Files = listdir(folderPath)

    for (num, files) in enumerate(Files,1):

        filePath = folderPath + Files[num-1]
        tmp = []

        Format = Files[num-1].split(".")[-1].upper()

        if  Format == "DIAG":
            tmp = lectureToutDiag(filePath)
            identifiant = Files[num-1].split(".")[0]

        elif Format == "DS":
            tmp = lectureToutDS(filePath)
            identifiant = Files[num-1].split(".")[0]

        elif Format == "CSV":
            tmp = lectureUnCSV(filePath)
            identifiant = Files[num-1].split("-")[0]

        elif Format == "XML":
            # à faire
            continue

        viveLesLuth[identifiant] = tmp

    return viveLesLuth

# faire une fonction pour lire un fichier quelque soit son format (ou pas si ça fait doublon avec le "lireDossier" qui choisit selon le format)













