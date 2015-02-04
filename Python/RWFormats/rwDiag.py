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


def lectureDossierDiag(folderPath, viveLesLuth):
    # viveLesLuth contiendra un dictionnaire dont chaque entrée, identifié par l'identifiant 
    # de l'émetteur, contiendra la liste correspondante (générée par lectureToutDiag())
    #
    # folderPath est le chemin du répertoire contenant tous les .DIAG 
    # NB : ne pas oublier le "/" à la fin de folderPath

    from os import listdir

    diagFiles = listdir(folderPath)

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

    """ data (dictionnaire) doit contenir :
            - l'identifiant, date, heure, LC et IQ
            - lat1, lat2, lon1, lon2
            - nbr message + >120dB + bestLevel
            - Pass duration et NOPC
            - freq et altitude
            - autres chiffres ?
    """
    firstLine = " %s  Date : %s %s  LC : %s  IQ : %s \n" % (data["identifiant"], data["date"], data["heure"], data["LC"], data["IQ"])

    secondLine = "      Lat1 : %s  Lon1 : %s  Lat2 : %s  Lon2 : %s \n" % (data["lat1"], data["lon1"], data["lat2"], data["lon2"])

    thirdLine = "      Nb mes : %s  Nb mes>-120dB : %s  Best level : %s dB\n" % (data["nbrMess"], data["nbMessSupp120dB"], data["bestdB"])

    fourthLine = "      Pass duration : %ss  NOPC : %s\n" % (data["passDuration"], data["NOPC"])
    
    fifthLine = "      Calcul freq : %s Hz   Altitude :   %s m\n" % (data["freq"], data["altitude"])
    
    sixthLine = "                 00          00          00          00\n" # sais pas encore
    
    total = "\n" + firstLine + secondLine + thirdLine + fourthLine + fifthLine + sixthLine

    return total



def ecritureDIAG(liste, nomFichier): # pas encore testé

    """
        Cette fonction écrira les données sous format ARGOS dans un .DIAG (nommé selon l'identifiant de la tortue).
        liste est la liste contenant tous les dictionnaires de transmission.
    """
    fichier = "../../DIAG/" # voir comment ça se passe si on appelle la fonction depuis un autre .py dans un autre dossier. Si ça marche pas, mettre le chemin en argument.

    with open(fichier + nomFichier, "w") as f:
        for i in liste:
            tmp = ecritureUneTransmission(liste[i])
            f.write(tmp)

















