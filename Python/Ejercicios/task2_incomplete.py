
import numpy
import MyEquation

A,b = MyEquation.load_equation_system( 'system.txt' )
print(A,b)
# Here you have to solve A * x = b, look at in the linear algebra package of numpy for the solution

x = numpy.linalg.solve(A, b)
print( x )
