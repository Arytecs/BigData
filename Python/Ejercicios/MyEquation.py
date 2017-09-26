
import numpy


def load_equation_system( filename ):
    f=open(filename, 'r' )
    # Reads 'n', the number of equations
    line=f.readline()
    tokens=line.split()
    n = int(tokens[0])
    # Creates the Numpy arrays for A and b
    A = numpy.zeros( [n,n] )
    b = numpy.zeros( n )
    for row in range(n):
        line=f.readline()
        tokens=line.split()
        for column in range(n):
            A[row,column] = int(tokens[column])
        b[row] = int(tokens[-1])
    f.close()

    return A,b
