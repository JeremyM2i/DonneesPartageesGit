
setwd("C:/Users/Administrateur/Documents/FormationDataScientist/FilRouge/DonneesPartageesGit")
data_final= readRDS("data_save.rds")
#setwd("//home//jeremy//FormationDataScience//FilRouge//Donnees")#Pathway Linux
fichier=read.csv2("geoflar-communes-2016.csv",sep=";",na.string="", header=TRUE,encoding="UTF-8")
localisation=paste(fichier$Nom.Com,fichier$Nom.Dept)
fichier=data.frame(fichier,localisation)

colonneASupp=c(1,2,3,4,7,8,9,10,11,12,15,18,21)
fichier2=fichier[,-colonneASupp]
fichier2


########### Population par region
region=c()
popRegion=c()
for (i in unique(fichier2$Nom.Reg)){
  #print(i)
  region=c(region,i)
  popRegion=c(popRegion,sum(fichier2$POPULATION[fichier2$Nom.Reg==i][!is.na(fichier2$POPULATION[fichier2$Nom.Reg==i])]))
}
########## superficie par region
region=c()
superfRegion=c()
for (i in unique(fichier2$Nom.Reg)){
  #print(i)
  region=c(region,i)
  superfRegion=c(superfRegion,sum(fichier2$SUPERFICIE[fichier2$Nom.Reg==i][!is.na(fichier2$SUPERFICIE[fichier2$Nom.Reg==i])]))
}
########## densité de pop par region
densitePopRegion=popRegion/superfRegion

dfRegion=data.frame(region,popRegion,densitePopRegion)
dfRegion=dfRegion[-18,]
colnames(dfRegion)=c("Nom.Reg","popRegion","densitePopRegion")

fichier=left_join(fichier,dfRegion,by="Nom.Reg")
###########################################

########## Population par departement
departement=c()
popDep=c()
for (i in unique(fichier2$Nom.Dept)){
  #print(i)
  departement=c(departement,i)
  popDep=c(popDep,sum(fichier2$POPULATION[fichier2$Nom.Dept==i][!is.na(fichier2$POPULATION[fichier2$Nom.Dept==i])]))
}

########## superficie par departement
departement=c()
superfDep=c()
for (i in unique(fichier2$Nom.Dept)){
  #print(i)
  departement=c(departement,i)
  superfDep=c(superfDep,sum(fichier2$SUPERFICIE[fichier2$Nom.Dept==i][!is.na(fichier2$SUPERFICIE[fichier2$Nom.Dept==i])]))
}

########## densité de pop par departement
densitePopDep=popDep/superfDep

dfDepartement=data.frame(departement,popDep,densitePopDep)
dfDepartement=dfDepartement[-100,]
colnames(dfDepartement)=c("Nom.Dept","popDep","densitePopDep")

fichier=left_join(fichier,dfDepartement,by="Nom.Dept")

###################

########### Densité de pop communes
densitePopCommune=fichier2$POPULATION/fichier2$SUPERFICIE

## On réécris le fichier geoflar avec pour chaque ville les pop et densité de la region et du département associées a la commune

write.table(fichier,"geoflar-communes-2016-modifie.csv",sep=";",dec=".")





#### 2eme partie, on ajoute les pop et densiteDePop (presentes dans geoflar) vers notre tableau immobilier (2.6M de lignes)




## Dans le fichier final a 3M de lignes :
#### Les codes communes sont censé avoir 3 chiffres , ex 003 mais ceux en dessous de 100 n'ont que un ou deux chiffres
#donc on rajoute les 0 manquants
j=1
for (i in data_final$Code.commune){
  print(j)
  if (nchar(toString(i))<3 ){data_final$Code.commune[j]=paste("0",toString(i),sep="")}
  if (nchar(toString(data_final$Code.commune[j]))<3 ){data_final$Code.commune[j]=paste("0",toString(i))}
  j=j+1
}
## On colle le code département + le code commune pour avoir le code INSEE  dans le tableau a 3M de lignes
Insee.Com=paste(data_final$Code.departement,data_final$Code.commune,sep="")
datafinal=data.frame(data_final,Insee.Com)

#on retire du fichier geofla les colonnes qu'on ne veut pas ajouter a la fin au fichier a 3M de lignes
colonnesInutiles=c(1,2,3,4,7,8,9,10,11,12,15,16,17,18,20,21,22)
fichier=fichier[,-colonnesInutiles]



data_final=left_join(data_final,fichier,by="Insee.Com")