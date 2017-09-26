
import numpy

n=5

A = numpy.random.rand( n, n ) * 20
A = numpy.floor( A )
A = A.astype( int )

print( A )

x = numpy.random.rand( n ) * 20
x = numpy.floor( x )
x = x.astype( int )

print( x )

b = numpy.dot(A,x)

print( b )

f=open( 'system.txt', 'w' )
f.write( "%d\n" % n )
for i in range(n):
    for j in range(n):
        f.write( " %5d" % A[i,j] )
    f.write( " %5d\n" % b[i] )

f.write( "SOLUTION: " )
for i in range(n):
    f.write( " %5d" % x[i] )
f.write( "\n" )
f.close()
