library(dplyr)
setwd("C:/Users/Administrateur/Documents/FormationDataScientist/FilRouge/DonneesPartageesGit")

data_final= readRDS("data_save.rds")
data_commune=read.csv2("DataCommunes.csv",sep=";",na.string="", header=TRUE)
data_region=read.csv2("DataRegions.csv",sep=";",na.string="", header=TRUE)
data_departement=read.csv2("DataDepartements.csv",sep=";",na.string="", header=TRUE)

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
datafinal_2=data.frame(data_final,Insee.Com)

#### Pareil pour le fichier data_commune, les codes insee sont pas toujours a 5 chiffres
j=1
for (i in data_commune$Insee.Com){
  while (nchar(data_commune$Insee.Com[j])<5){
    data_commune$Insee.Com[j]=paste("0",data_commune$Insee.Com[j],sep="")
  }
  j=j+1
}



# on fait une jointure
datafinal_3 = left_join(datafinal_2,data_commune,by="Insee.Com")

datafinal_3 = leftjoin(datafinal_3,data_region,by="")

datafinal_3 = leftjoin(datafinal_3,data_departement,by="Code.departement")