# 
# Solves -sigma*Laplace(u) = 0
#
# Boundary conditions
#
# u0 = 0
# u1 = 1
# du/dn = 0

# Load geometry
geometry = StaticFlow2D.in2d

# Load mesh
mesh = StaticFlow2D.vol


# coefficients for conductivity
define coefficient sigma
100.1, 2.2, 

# voltage ground plane
define constant u0 = 0 

# voltage trace
define constant u1 = 1.0 

# voltages
define coefficient voltages
(u0), (u1), 0, 0, 

# coefficient for Visualization
define coefficient one
1.0, 1.0, 


# define a linear fespace
define fespace v -type=h1ho -order=3 -dirichlet=[1,2]

define gridfunction u -fespace=v

define bilinearform a -fespace=v -symmetric
laplace sigma

define linearform f -fespace=v


#numproc shapetester npst -gridfunction=u

numproc setvalues npsv -gridfunction=u -coefficient=voltages -boundary
numproc bvp name -bilinearform=a -linearform=f -gridfunction=u -solver=direct #-inverse=pardiso

define bilinearform amass -fespace=v -symmetric -nonassemble
mass one
define bilinearform agrad -fespace=v -symmetric -nonassemble
laplace sigma


numproc drawflux np1 -bilinearform=amass -solution=u  -label=Vpot
numproc drawflux np2 -bilinearform=agrad -solution=u  -label=Efield
numproc drawflux np3 -bilinearform=agrad -solution=u  -label=Jfield -applyd


define bilinearform Losses -fespace=v -symmetric -nonassemble
laplace sigma
numproc evaluate np1 -bilinearform=Losses -gridfunction=u  -gridfunction2=u
define bilinearform Losses1 -fespace=v -symmetric -nonassemble
laplace sigma -definedon=1
numproc evaluate np1 -bilinearform=Losses1 -gridfunction=u  -gridfunction2=u

