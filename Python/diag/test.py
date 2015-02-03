# -*-coding:utf-8 -*

# Lecture des .DIAG
# data = dictionnaire avec les données

def lectureUnDiag(diagFile, data):
    # with open(pathDiagFile,"r") as diagFile:
    # cette ligne pour la fct "lectureToutDiag()"

    # Première ligne est juste "/r/n"
    diagFile.seek(2,1)

    # Chaque loc est composé de 6 lignes
    for line in range(6):

        tmp = diagFile.readline().split(" ")

        if line == 0:
            data["num"] = tmp[1]
            data["date"] = tmp[5]
            data["heure"] = tmp[6]
            data["LC"] = tmp[10]
            data["IQ"] = tmp[14]
        elif line == 1:
            data["lat1"] = tmp[9]
            data["lon1"] = tmp[14]
            data["lat2"] = tmp[19]
            data["lon2"] = tmp[24]
        elif line == 2:
            data["nbrMess"] = tmp[9]
            data["db"] = tmp[12].split(">")[1]
            data["bestdb"] = tmp[19]
        elif line == 3:
            data["passDuration"] = tmp[9]
            data["NOPC"] = tmp[14]
        elif line == 4:
            data["freq"] = tmp[9] + tmp[10]
            data["altitude"] = tmp[19]
        else:
            continue


def lectureToutDiag(pathDiagFile):
