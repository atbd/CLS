# -*-coding:Latin-1 -*
import os # On importe le module os

def suppVitesseExcess(liste,recuperation,convertArrayOfTime,calculVitesses,vitesseMax):

    # Récupération des classes
    listeClasse = recuperation(liste,'LC')

    modif = 1   
 

    while (modif==1): # Tant qu'il reste des points avec des vitesse excessives
        

        
        modif = 0
        
        # Conversion des classes str en float pour pouvoir faire des comparaisons
        listeClasse = recuperation(liste,'LC')
        for j in range(len(listeClasse)):
            if (listeClasse[j]=='A'):
                listeClasse[j]=-1.0
            elif(listeClasse[j]=='B'):
                listeClasse[j]=-2.0
            elif(listeClasse[j]=='Z'):
                listeClasse[j]=-3.0
            else:
                listeClasse[j]=float(listeClasse[j]) 

        # Récupération des latitudes,longitudes et dates des points 

        lat = recuperation(liste,'lat')
        lon = recuperation(liste,'lon') 
        date = recuperation(liste,'date')    
         

        for i in range(2,len(liste)):            

            # Calcul de l'instant précédent 
            instant1 = convertArrayOfTime([date[i-1]])            

            # Calcul de l'instant courant
            
            instant2 = convertArrayOfTime([date[i]])

            # Calcul de la vitesse

            temp = calculVitesses(map(float,[lat[i-1],lat[i]]),map(float,[lon[i-1],lon[i]]),map(int,[instant1[0],instant2[0]]))
            
            if temp[0]>vitesseMax: # Si la vitesse de la localisation courante est excessive

                modif = 1

                if (listeClasse[i-1]<listeClasse[i] and listeClasse[i]>0): # Si la loc precedente est de moins bonne classe et que la 
                                                                           # meilleure est superieure a 0 (les classes de loc ne renseignent 
                                                                           # sur l'erreur que quand leur valeur est positive)
                    # On élimine la localisation précèdente
                    liste[i-1]["lat"]=9999

                elif (listeClasse[i-1]>listeClasse[i] and listeClasse[i-1]>0):

                    # On élimine la localisation courante 
                    liste[i]["lat"]=9999

                else: # Sinon, si les deux classes sont égales, on calcule les vitesses précédente et suivante

                    if (i<len(liste)-1):

                        # Calcul de l'instant précèdent l'observation précèdente

                        instant3 = convertArrayOfTime([date[i-2]])

                        if (instant3!=instant1):

                            vitesse1 = calculVitesses(map(float,[lat[i-2],lat[i-1]]),map(float,[lon[i-2],lon[i-1]]),map(int,[instant3[0],instant1[0]]))[0]

                        else:

                            vitesse1 = 0

                        # Calcul de l'observation suivante
                        
                        
                        instant4 = convertArrayOfTime([date[i+1]])

                        
                        if (instant4!=instant2):

                            vitesse2 = calculVitesses(map(float,[lat[i],lat[i+1]]),map(float,[lon[i],lon[i+1]]),map(int,[instant2[0],instant4[0]]))[0]

                        else:

                            vitesse2 = 0

                        if vitesse1 >= vitesse2: # Si la vitesse précèdente est supérieure à la vitesse suivante
                            
                            # On supprime la localisation précèdente
                            liste[i-1]["lat"]=9999 

                        else:

                            # On supprime la localisation courante
                            liste[i]["lat"]=9999                 
                
        liste = [w for w in liste if str(w['lat'])!= "9999"] # On met à jour la liste, une fois que les localisations sont supprimées
        


            
        

    return liste    


#os.system("pause")




