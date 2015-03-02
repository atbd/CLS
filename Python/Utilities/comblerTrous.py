# -*- coding: utf-8 -*-

import os # On importe le module os
import numpy as np

def comblerTrous(estim1,estim2,pasEchantillonnage,recuperation,convertArrayOfTime,convertSecondToDatetime):

    cpt = 0
    temps1 = convertArrayOfTime(recuperation(estim1,'date'))
    temps1 = map(int,temps1)
    temps2 = convertArrayOfTime(recuperation(estim2,'date'))    
    temps2 = map(int,temps2)
    temps1 = map(int,convertArrayOfTime(recuperation(estim1,'date')))
    temps2 = map(int,convertArrayOfTime(recuperation(estim2,'date')))    
    classe = recuperation(estim1,'LC')
    latEstim1 = map(float,recuperation(estim1,'lat'))
    lonEstim1 = map(float,recuperation(estim1,'lon'))
    latEstim2 = map(float,recuperation(estim2,'lat'))
    lonEstim2 = map(float,recuperation(estim2,'lon'))

    matr=np.zeros((10000,3))

    for l in xrange(len(classe)):
        if (classe[l]=='A'):
            classe[l]=-1.0
        
        elif(classe[l]=='B'):
            classe[l]=-2.0
        
        elif(classe[l]=='Z'):
            classe[l]=-3.0
        
        else:
            classe[l]=float(classe[l]) 


    matr[0][0] = temps2[0]
    matr[0][1] = latEstim2[0]
    matr[0][2] = lonEstim2[0]


    for i in xrange(1,len(estim2)):

        if(temps2[i] - temps2[i-1])>pasEchantillonnage:

            for j in xrange(pasEchantillonnage,temps2[i]-temps2[i-1]-1,pasEchantillonnage):

                tpsEsti = j + temps2[i-1]
                lat1 = matr[cpt][1]
                lon1 = matr[cpt][2]
                tps1 = matr[cpt][0]

                for k in xrange(len(estim1)):

                    if temps1[k]>tpsEsti:
                        if temps1[k]>temps2[i]:
                            if classe[k]>=1:
                                lat2 = latEstim1[k]
                                lon2 = lonEstim1[k]
                                tps2 = temps1[k]

                            else:
                                lat2 = latEstim2[i]
                                lon2 = lonEstim2[i]
                                tps2 = temps2[i]
                        else:

                            lat2 = latEstim2[i]
                            lon2 = lonEstim2[i]
                            tps2 = temps2[i]

                        break
                            
                aLat = (lat2 - lat1) / (tps2 - tps1)
                bLat = (lat1 * tps2 - lat2 * tps1) / (tps2 - tps1)

                aLon = (lon2 - lon1) / (tps2 - tps1)
                bLon = (lon1 * tps2 - lon2 * tps1) / (tps2 - tps1)

                estiLat = aLat * tpsEsti + bLat     
                estiLon = aLon * tpsEsti + bLon 

                cpt = cpt+1
                
                matr[cpt][0] = temps2[i-1]+j
                matr[cpt][1] = estiLat
                matr[cpt][2] = estiLon

            cpt = cpt+1
            matr[cpt][0] = temps2[i]
            matr[cpt][1] = latEstim2[i]
            matr[cpt][2] = lonEstim2[i]

        else:

            cpt = cpt+1
            matr[cpt][0] = temps2[i]
            matr[cpt][1] = latEstim2[i]
            matr[cpt][2] = lonEstim2[i]

    if (temps1[len(estim1)-1] - temps2[len(estim2)-1])>pasEchantillonnage:

        for j in xrange(pasEchantillonnage,temps1[len(estim1)-1] - temps2[len(estim2)-1],pasEchantillonnage):

            tpsEsti = j+temps2[len(estim2)-1]
            lat1 = matr[cpt][1]
            lon1 = matr[cpt][2]
            tps1 = matr[cpt][0]

            for k in xrange(len(estim1)):

                if temps1[k]>tpsEsti:

                    lat2 = latEstim1[k]
                    lon2 = lonEstim1[k]
                    tps2 = temps1[k]
                    break
            aLat = (lat2 - lat1) / (tps2 - tps1)
            bLat = (lat1 * tps2 - lat2 * tps1) / (tps2 - tps1)  

            aLon = (lon2 - lon1) / (tps2 - tps1)
            bLon = (lon1 * tps2 - lon2 * tps1) / (tps2 - tps1)

            estiLat = aLat * tpsEsti + bLat
            estiLon = aLon * tpsEsti + bLon

            cpt = cpt+1
            matr[cpt][0]=tpsEsti
            matr[cpt][1]=estiLat
            matr[cpt][2]=estiLon


    
    nouveListe = []

    for i in xrange(cpt):

        dico ={}
        dico["date"]=convertSecondToDatetime(matr[i][0])
        dico["lat"]=matr[i][1]
        dico["lon"]=matr[i][2]
        nouveListe.append(dico)
    
    return nouveListe   
            



            





                                




