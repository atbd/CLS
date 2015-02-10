# -*-coding:Latin-1 -*
import os # On importe le module os

def suppVitesseExcess(listeVitesse,listePosition,listeTemps,listeClasse,vitesseMax):

    i = len(listeVitesse) - 1
    
    
    while i!=1:

        if listeVitesse[i]>vitesseMax:

            
            if (listeClasse[i-1]<listeClasse[i] & listeClasse[i]>0):
                del listePosition[i-1]
            elif (listeClasse[i-1]>listeClasse[i] & listeClasse[i-1]>0):
                del listePosition[i]
            else:
                if (listeTemps[i-2]!=listeTemps[i-1]):
                    vitesse1=(listePosition[i-1] - listePosition[i-2])/(listeTemps[i-1] - listeTemps[i-2])
                else:
                    vitesse1=0
                if (listeTemps[i-1]!=listeTemps[i]):
                    vitesse2=(listePosition[i] - listePosition[i-1])/(listeTemps[i] - listeTemps[i-1])
                else:
                    vitesse2=0
                if vitesse1>=vitesse2:
                    listePosition[i-1]=listePosition[i]
                
        i=i-1
        

    return listePosition    


A = suppVitesseExcess([1,2,3,4,5,6,7,8],[1,10,11,14,15,16,44,33],[1,3,5,7,9,11,13,15],[1,2,3,4,4,5,7,8],2.8)
print(A)
os.system("pause")




