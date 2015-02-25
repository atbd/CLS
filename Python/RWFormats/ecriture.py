#!/usr/bin/python
# -*-coding:utf-8 -*

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





