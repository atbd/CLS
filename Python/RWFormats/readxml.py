# -*- coding: utf-8 -*-

def readxml(pathXmlFile):

    with open(pathXmlFile, "r") as f:
        data = {}       

        for line in f:

            tmp = line.strip()

            
            if tmp.startswith("<vitesse_max"):

                k = filter(None, tmp.split("<"))
                k = k[0].split(">")
                data[k[0]] = k[1]

            elif tmp.startswith("<pas_redi"):
                k = filter(None, tmp.split("<"))
                k = k[0].split(">")
                data[k[0]] = k[1]

            elif tmp.startswith("<ecart"):
                k = filter(None, tmp.split("<"))
                k = k[0].split(">")
                data[k[0]] = k[1]

            elif tmp.startswith("<periode"):
                k = filter(None, tmp.split("<"))
                k = k[0].split(">")
                data[k[0]] = k[1]

            elif tmp.startswith("<min_estim1"):
                k = filter(None, tmp.split("<"))
                k = k[0].split(">")
                data[k[0]] = k[1] 

            elif tmp.startswith("<min_estim2"):
                k = filter(None, tmp.split("<"))
                k = k[0].split(">")
                data[k[0]] = k[1]

            elif tmp.startswith("<demi_fenetre_min_estim1"):
                k = filter(None, tmp.split("<"))
                k = k[0].split(">")
                data[k[0]] = k[1]

            elif tmp.startswith("<demi_fenetre_max_estim1"):
                k = filter(None, tmp.split("<"))
                k = k[0].split(">")
                data[k[0]] = k[1]

            elif tmp.startswith("<demi_fenetre_min_estim2"):
                k = filter(None, tmp.split("<"))
                k = k[0].split(">")
                data[k[0]] = k[1]

            elif tmp.startswith("<demi_fenetre_max_estim2"):
                k = filter(None, tmp.split("<"))
                k = k[0].split(">")
                data[k[0]] = k[1]

            elif tmp.startswith("<nb_pt_demi_fenetre_estim1"):
                k = filter(None, tmp.split("<"))
                k = k[0].split(">")
                data[k[0]] = k[1]

            elif tmp.startswith("<nb_pt_demi_fenetre_estim2"):
                k = filter(None, tmp.split("<"))
                k = k[0].split(">")
                data[k[0]] = k[1]

    return data



#path = "../../XML/DefautParametres.xml"
#print(readxml(path))

         
                
     
                    
                
                 
        
        
