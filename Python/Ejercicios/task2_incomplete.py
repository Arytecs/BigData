
import numpy
import MyEquation
import subprocess

#Creamos el fichero system.txt llamando al siguiente archivo
subprocess.call(["python", "equation-system-generator.py"])
#Leemos el archivo que nos devolverá la matriz A y el vector b
A,b = MyEquation.load_equation_system( 'system.txt' )
print(A,b)
#numpy.linalg.solve --> Nos devuelve la solución de una equación 
lineal de matrices de la forma Ax=b
x = numpy.linalg.solve(A, b)
print( "Solution: ", x )
