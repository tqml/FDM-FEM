# 
# Solves -lamda*Laplace(u) + c*u = f
#
# und geeignete Randbedingungen
#

# Load geometry
# geometry = TwoDomains2D.in2d

# Load mesh
mesh = TwoDomains2D.vol


# Dirichlet boundary conditions are modelled by penalization
define constant alphaPenalty = 1e6

# coefficients for heat conductivity
define coefficient lambda
1, 1, 

# coefficients for heat transfer
define coefficient q
10, 10,  

# coefficients for heat intensity
define coefficient fsource
1, 1,  

# Umgebungstemperatur alphab
define constant alphab = 0.5

# Umgebungstemperatur ub
define constant ub = 50

# coefficient for Visualization
define coefficient one
1.0, 1.0, 


define coefficient CoeffRobin
0, (alphaPenalty), 0, (alphaPenalty), 0,  
#0, 0, 0, (alphaPenalty), 0,  

define coefficient CoeffRobinCauchy
0, (alphab), 0, (alphaPenalty), 0,  

define coefficient CoeffNeumann
0, (alphaPenalty), 0, (alphaPenalty), 0,

define coefficient CoeffNeumannCauchy
0, (alphab*ub), 0, (alphaPenalty), 0, 

define coefficient coeffDirichlet
0, (-1), 0, (1), 0, 

# define a linear fespace
define fespace v -type=h1ho -order=2 #-dirichlet=[2,4]

define gridfunction u -fespace=v

define bilinearform a -fespace=v -symmetric
laplace lambda
mass q
#robin CoeffRobin
robin CoeffRobinCauchy

define linearform f -fespace=v
#neumann CoeffNeumann
neumann CoeffNeumannCauchy
#source fsource



#numproc shapetester npst -gridfunction=u

#numproc setvalues npsv -gridfunction=u -coefficient=coeffDirichlet -boundary

#define preconditioner c -type=direct -bilinearform=a -inverse=sparsecholesky
#numproc bvp np1 -bilinearform=a -linearform=f -gridfunction=u -preconditioner=c -solver=cg -prec=-1 #-solver=direct
numproc bvp name -bilinearform=a -linearform=f -gridfunction=u -solver=direct #-inverse=pardiso

define bilinearform amass -fespace=v -symmetric -nonassemble
mass q
define bilinearform agrad -fespace=v -symmetric -nonassemble
laplace lambda


numproc drawflux np1 -bilinearform=amass -solution=u  -label=u
numproc drawflux np1 -bilinearform=amass -solution=u  -label=cu -applyd
numproc drawflux np2 -bilinearform=agrad -solution=u  -label=gradu
numproc drawflux np3 -bilinearform=agrad -solution=u  -label=flux -applyd
