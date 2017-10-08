load("./practicas/JaenIndicadores.RData")
str(Datos)
summary(Datos)
Tabla<-table(Datos$Tipo)
Tabla
Tabla.rel<-prop.table(Tabla)
Tabla.rel
Tabla.rel<-round(Tabla.rel*100,2)
summary(Datos$agua.hab)
fivenum(Datos$agua.hab)
min<-min(Datos$agua.hab, na.rm = TRUE)
max<-max(Datos$agua.hab, na.rm = TRUE)
media<-mean(Datos$agua.hab, na.rm = TRUE)
mediana<-median(Datos$agua.hab, na.rm = TRUE)
#MODA
moda<-Tabla[which(Tabla == max(Tabla))[1]]
moda
percentiles<-quantile(Datos$agua.hab, na.rm = TRUE)
percentiles2<-quantile(Datos$agua.hab, na.rm = TRUE, probs = c(0.05,0.95))
varianza<-var(Datos$agua.hab, na.rm = T)
desviaciontipica<-sd(Datos$agua.hab, na.rm = T)
q1.Tasa<-quantile(Datos$agua.hab, na.rm = T, probs = 0.25)
q3.Tasa<-quantile(Datos$agua.hab, na.rm = T, probs = 0.75)
ri<-q1.Tasa-q3.Tasa
#Coeficiente de variación
sd(Datos$agua.hab,na.rm=TRUE)
sd(Datos[,c("agua.hab","elec.hab","res.hab")],na.rm=TRUE)/mean(Datos[,c("agua.hab","elec.hab","res.hab")],na.rm=TRUE)

install.packages(e1071)

library(e1071)
skewness(Datos$agua.hab,na.rm=TRUE)
