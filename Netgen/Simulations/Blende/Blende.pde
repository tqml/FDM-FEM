#
# Blende
#

geometry = Blende.geo
mesh = Blende.vol

define constant geometryorder = 4
define constant heapsize = 50000000

define constant lamda = 0.5
define constant twopi = 6.283185307


#define constant omega = 1
define constant Einc = 1

# Penalty
define coefficient alphaP
0, 0, 1e6

# Robin
define coefficient alphaR
(-twopi/lamda), (-twopi/lamda), 0

# Neumann
define coefficient alphaN1
0, 0, 0
define coefficient alphaN2
(-twopi/lamda*exp(-(y*y+z*z)/0.3)), 0, 0
#1, 0, 0
define coefficient alphaN3
0, 0, 0

# Stiffness
define coefficient alphaS
1.0

# Mass
define coefficient alphaM
(-twopi/lamda*twopi/lamda)

#define fespace v -hcurlho -order=3  -nograds   -eliminate_internal -complex
#define gridfunction u -fespace=v  -novisual
define fespace v -type=hcurlho -order=3 -complex
define gridfunction u -fespace=v  -nestet

define linearform f -fespace=v
neumannedge alphaN1 alphaN2 alphaN3 -imag

define bilinearform a -fespace=v -symmetric -linearform=f -eliminate_internal 
#define bilinearform a -fespace=v
curlcurledge alphaS 
massedge alphaM #-order=2
robinedge alphaR -imag
robinedge alphaP


#define bilinearform acurl -fespace=v -symmetric -nonassemble
define bilinearform acurl -fespace=v -nonassemble
curlcurledge alphaS 


#define preconditioner c -type=multigrid -bilinearform=a  -smoother=block
#define preconditioner c -type=multigrid -bilinearform=a -cylce=1 -smoother=block 
-blocktype=1 -coarsetype=direct -coarsesmoothingsteps=5  -notest
#define preconditioner c -type=local -bilinearform=a -test 
define preconditioner c -type=direct -bilinearform=a #-inverse=pardiso


numproc bvp np1 -bilinearform=a -linearform=f -gridfunction=u -preconditioner=c  -prec=1.e-9
# numproc bvp np1 -bilinearform=a -linearform=f -gridfunction=u  -solver=direct # -preconditioner=c  -prec=1.e-9


#numproc drawflux np5a -bilinearform=acurl -solution=u  -label=B-field
numproc drawflux np5 -bilinearform=acurl -solution=u
#numproc drawflux np5b -bilinearform=acurl -solution=u  -label=H-field -applyd


# p=, ? its, err = ??1.65647e-11, ??18.92 sec
