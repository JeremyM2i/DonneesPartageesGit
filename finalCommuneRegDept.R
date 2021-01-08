
setwd("C:/Users/Administrateur/Documents/FormationDataScientist/FilRouge/DonneesPartageesGit")
#setwd("//home//jeremy//FormationDataScience//FilRouge//Donnees")#Pathway Linux
fichier=read.csv2("geoflar-communes-2016.csv",sep=";",na.string="", header=TRUE,encoding="UTF-8")

names(fichier)
colonneASupp=c(1,2,3,4,7,8,9,10,11,12,15,18,21)
fichier2=fichier[,-colonneASupp]
fichier2
attach(fichier2)

########### Densité de pop communes
densitePopCommune=POPULATION/SUPERFICIE

########### Population par region
region=c()
popRegion=c()
for (i in unique(Nom.Reg)){
  print(i)
  region=c(region,i)
  popRegion=c(popRegion,sum(fichier2$POPULATION[fichier2$Nom.Reg==i][!is.na(fichier2$POPULATION[fichier2$Nom.Reg==i])]))
}
########## superficie par region
region=c()
superfRegion=c()
for (i in unique(Nom.Reg)){
  print(i)
  region=c(region,i)
  superfRegion=c(superfRegion,sum(fichier2$SUPERFICIE[fichier2$Nom.Reg==i][!is.na(fichier2$SUPERFICIE[fichier2$Nom.Reg==i])]))
}
########## densité de pop par region
densitePopRegion=popRegion/superfRegion


###########################################

########## Population par departement
departement=c()
popDep=c()
for (i in unique(Nom.Dept)){
  #print(i)
  departement=c(departement,i)
  popDep=c(popDep,sum(fichier2$POPULATION[fichier2$Nom.Dept==i][!is.na(fichier2$POPULATION[fichier2$Nom.Dept==i])]))
}

########## superficie par departement
departement=c()
superfDep=c()
for (i in unique(Nom.Dept)){
  print(i)
  departement=c(departement,i)
  superfDep=c(superfDep,sum(fichier2$SUPERFICIE[fichier2$Nom.Dept==i][!is.na(fichier2$SUPERFICIE[fichier2$Nom.Dept==i])]))
}

########## densité de pop par departement
densitePopDep=popDep/superfDep


dfRegion=data.frame(region,popRegion,densitePopRegion)
dfRegion=dfRegion[-18,]
dfDepartement=data.frame(Code.Dept,departement,popDep,densitePopDep)
dfDepartement=dfDepartement[-100,]
dfCommune=data.frame(Insee.Com,Nom.Com,POPULATION,densitePopCommune)

###################

print(dfCommune)
print(dfDepartement)
print(dfRegion)

write.table(dfCommune,"DataCommunes.csv",sep=";",dec=".")
write.table(dfDepartement,"DataDepartements.csv",sep=";",dec=".")
write.table(dfRegion,"DataRegions.csv",sep=";",dec=".")
