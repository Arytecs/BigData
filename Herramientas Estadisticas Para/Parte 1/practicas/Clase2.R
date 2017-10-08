x<-seq(-4,4,0.05)
y<-dt(x,9)
plot(x, y, type = "l", col="red", xlab="t 9 g.l.",
     ylab = "f(x)", main = "Función de densidad")
y2<-dchisq(x,9)
plot(x, y2, type = "l", col="red", xlab="t 9 g.l.",
     ylab = "f(x)", main = "Función de densidad")

load("practicas/datos.RData")
#Para no tener que llamar a la variable indicando primero el dataframe
attach(datos1)
summary(GASTO)
sd(GASTO, na.rm = T)
mean(GASTO, na.rm = T)
plot(GASTO)
boxplot(GASTO)

media.gasto<-mean(GASTO, na.rm = T)
S.gasto<-sd(GASTO, na.rm = T)
N.gasto<-length(GASTO)
SE.gasto<-S.gasto/sqrt(N.gasto)

t.negativo<-qt(0.05/2, 131-1)
#Añadimos lower.tail para que me mire en la cola derecha
t.positivo<-qt(0.05/2, 131-1, lower.tail = F)
t.valor<-(media.gasto-10)/SE.gasto
#Cálculo del p-valor
pvalor<-pt(t.valor, 131-1)

chicas<-subset(datos1, SEXO == "mujer")
chicas.gasto<-na.omit(chicas)
chicos<-subset(datos1, SEXO == "varon")
chicos.gasto<-na.omit(chicos)
media.chicas<-mean(chicas$GASTO, na.rm = T)
media.chicos<-mean(chicos$GASTO, na.rm = T)
S.chicas.gasto<-sd(chicas$GASTO, na.rm=T)
S.chicos.gasto<-sd(chicos$GASTO, na.rm = T)


#Ejemplo de test para m (pdf 4 diap 104)
gasto<-na.omit(GASTO)
media.gasto<-mean(gasto, na.rm = T)
S.gasto<-sd(gasto, na.rm=T)
N.gasto<-length(gasto)
media.gasto
S.gasto
N.gasto
t.test(gasto, alternative = "two.sided", mu=9, conf.level = 0.95)
estadistico<-(media.gasto - 9)/(S.gasto/sqrt(N.gasto))
estadistico

#INTERPRETACIÓN
# One Sample t-test --> Estoy haciendo contraste de una muestra
# t es el estadístico
# al ser el p-valor muy pequeño (probabilidad que hay para que haya valores que 
# superen a ese valor)
# Como el p-valor es más pequeño al alpha que habíamos puesto, tengo evidencia para
# pensar que podemos rechazar la hipótesis nula
# Me da un intervalo de confianza. También puedo aceptar o rechazar hipótesis viendo el 
# intervalo de confianza. como el 9 no está en ese intervalo, no lo puedo aceptar.

t.test(gasto, y=NULL, alternative = "greater", mu=9,conf.level = 0.95)
t.test(gasto, y=NULL, alternative = "greater", mu=10,conf.level = 0.95)

#Comparamos medias
var.test(chicas.gasto$GASTO, chicos.gasto$GASTO, alternative="two.sided", ratio=1, 
         conf.level = 0.95)
#Aceptamos que las varianzas son iguales y por lo tanto añadimos el parámetro
# var.equal=T
t.test(chicas.gasto$GASTO, chicos.gasto$GASTO, alternative="two.sided", mu=0, 
       var.equal=T, conflevel=0.95)

#Test con muestras dependientes (apareadas)
t.test(GASTO, GASTO2, alternative="two.sided",
       mu=0, paired=T, var.equal = T, conf.level=0.99)

#Ejemplo ACP
install.packages("corpcor")
install.packages("psych")
install.packages("GPArotation")
library("corpcor")
library("psych")
library("GPArotation")

load("practicas/RAQ.RData")

cor.plot(raqDatos)
raqR<-cor(raqDatos)
sum(raqR<0.3)
round(raqR, 2)
det(raqR) # > 0.00001 -> No hay multicolinealidad

#Test de Bartlett
cortest.bartlett(raqR, dim(raqDatos)[1])
#p-value < 0.05. No podemos aceptar la H0 de que R(matriz de correlacion)=I(matriz
# identidad) -> Nuestros datos son adecuados 
# para el AF
# chisq-> la chi cuadrado. Calcula el estadístico


#Índice KMO
raq.kmo <- kmo(raqDatos) #-> Me da error
mcp1<- principal(raqR, nfactors = 23, rotate = "none")
mcp1
# h porcentaje de variabilidad que comparten

plot(mcp1$values, type = "b", ylab = "Valores propios", xlab =
       "Componente", main = "Screeplot")

mcp2<- principal(raqR, nfactors = 4, rotate = "none")
mcp2
plot(mcp2$values, type = "b", ylab = "Valores propios", xlab =
       "Componente", main = "Screeplot")

mcp3<- principal(raqR, nfactors = 2, rotate = "none")
mcp3
