# -*- coding: utf-8 -*-

import numpy as np
from numpy.linalg import inv

def estimation2(liste,tailleDemiFen,tailleDemiFenMax,nbPtDemiFen,PasEchantillonnage,minEstim2,recuperation,convertArrayOfTime,kernel,comblerTrous,convertSecondToDatetime):

    cpteurEstim = 0
    nouvListe=[]
    cpteurPt = 0
    lat = recuperation(liste,'lat')
    lon = recuperation(liste,'lon')
    temps = convertArrayOfTime(recuperation(liste,'date'))
    LC = recuperation(liste,'LC')
    tailleDeminFenSave = tailleDemiFen
    ecartCumule = [0]*len(liste)
    estim=np.zeros((5*len(liste),4))
    K=np.zeros(len(liste))
    X=np.zeros((len(liste),2))
    YLat=np.zeros(len(liste))
    YLon=np.zeros(len(liste))
    #print(len(X))


    for p in xrange(1,len(liste)):
        ecartCumule[p] = ecartCumule[p-1] + (temps[p]-temps[p-1])
    
    deuxiemeTemps = ecartCumule[1]
    avantDernierTemps = ecartCumule[len(liste)-2]
    ecartCumule=map(int,ecartCumule)

    repartitionPtOk = 0

    estim[cpteurEstim][0] = temps[0]
    estim[cpteurEstim][1] = lat[0]
    estim[cpteurEstim][2] = lon[0]
    estim[cpteurEstim][3] = 0

    pasEstim = 0

    for i in xrange(int(PasEchantillonnage),ecartCumule[len(liste)-1],int(PasEchantillonnage)):

        while (repartitionPtOk==0 and pasEstim==0):

            cpteurPt=0
            cpteurPtGauche=0
            cpteurPtDroite=0
            cpteurLC=0


            for j in xrange(len(liste)):

                if (ecartCumule[j]>(i-tailleDemiFen) and ecartCumule[j]<(i+tailleDemiFen)):

                    cpteurPt = cpteurPt + 1


                    K[cpteurPt] = kernel(1,i-ecartCumule[j],tailleDemiFen)
                    X[cpteurPt][0] = 1
                    X[cpteurPt][1] = ecartCumule[j] - i
                    YLat[cpteurPt] = lat[j]
                    YLon[cpteurPt] = lon[j]

                    cpteurLC = LC[j]

                    if ((ecartCumule[j]-i)>0):

                        cpteurPtDroite = cpteurPtDroite+1

                    else:

                        cpteurPtGauche=cpteurPtGauche+1


                else:

                    if((ecartCumule[j]-i)>tailleDemiFen):

                        break

            if ((i-tailleDemiFen)<=deuxiemeTemps or (i+tailleDemiFen)>= avantDernierTemps):

                pasEstim = 1

            else:

                if (cpteurPt>=minEstim2) and (cpteurPtDroite>=nbPtDemiFen) and (cpteurPtGauche>=nbPtDemiFen):

                    repartitionPtOk=1
                else:

                    tailleDemiFen = tailleDemiFen + 1800

                if tailleDemiFen>tailleDemiFenMax:

                    if ((cpteurPtDroite>=1) and (cpteurPtGauche>=1) and (cpteurPt>=2)) or (i<deuxiemeTemps) or (i>avantDernierTemps):

                        repartitionPtOk = 1

                    else:

                        pasEstim = 1

        if pasEstim==0:

            cpteurEstim = cpteurEstim + 1

            Ka = np.diag(K)


            solLat = np.dot(np.dot(np.eye(1,2),inv(np.dot(np.transpose(X),np.dot(Ka,X)))),np.dot(np.transpose(X),np.dot(Ka,YLat)))
            estim[cpteurEstim][0] = i+temps[0]
            estim[cpteurEstim][1] = solLat

            solLon = np.dot(np.dot(np.eye(1,2),inv(np.dot(np.transpose(X),np.dot(Ka,X)))),np.dot(np.transpose(X),np.dot(Ka,YLon)))
            estim[cpteurEstim][2] = solLon

        tailleDemiFen = tailleDeminFenSave

        K=np.zeros(len(liste))
        X=np.zeros((len(liste),2))
        YLat=np.zeros(len(liste))
        YLon=np.zeros(len(liste))

        repartitionPtOk = 0
        pasEstim = 0

    nouvListe = [{"date":convertSecondToDatetime(estim[k][0]), "lat":estim[k][1], "lon":estim[k][2]} for k in xrange(len(estim))]
    nouvListe = [w for w in nouvListe if int(w["lat"]) != 0]
    nouvListe = comblerTrous(liste,nouvListe,PasEchantillonnage,recuperation,convertArrayOfTime,convertSecondToDatetime)

    return nouvListe
































