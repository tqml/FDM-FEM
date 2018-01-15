#
# Solves the equation -div \epsilon grad u = f in Omega
#
# with boundary conditions
#      u = 0  on Gamma1
#  du/dn = 0  on Gamma2, Gamma3 and Gamma5
#      u = 1  on Gamma4
#
# Note that Dirichlet boundary conditions are prescribed exactly!


# load geometry
geometry = Electrostatics_2Domains.in2d

# and mesh
mesh = Electrostatics_2Domains.vol

define constant epsilon0 = 8.854e-12
define constant epsilon_r = 1.0

# coefficient for laplace with epsilon_r
define coefficient epsilon
(epsilon0), (epsilon_r*epsilon0), 


# coefficient for energy with epsilon_r
define coefficient cenergy
(0.5*epsilon0), (0.5*epsilon_r*epsilon0), 

# coefficient for the robin
define coefficient alphaR
1e6, 0, 0, 1e6, 0, 

# coefficient for the source
define coefficient coef_source
#0.815, 1.0, 
#(x), (x),

#
define coefficient coef_dirichlet
0, 0, 0, 1, 0, 


# define a second order fespace (play around with -order=...)
define fespace v -h1ho -order=5 -dirichlet=[1,4]

# the solution field ...
define gridfunction u -fespace=v -nested

# bilinear form 
define bilinearform a -fespace=v -symmetric
laplace epsilon

define linearform F -fespace=v
#source coef_source


numproc setvalues npsv -coefficient=coef_dirichlet -gridfunction=u -boundary
numproc bvp name -bilinearform=a -linearform=F -gridfunction=u -solver=direct


define bilinearform amass -fespace=v -nonassemble
mass epsilon
define bilinearform alaplace -fespace=v -nonassemble
laplace epsilon

numproc drawflux np5a -bilinearform=amass -solution=u  -label=V
numproc drawflux np5b -bilinearform=alaplace -solution=u  -label=Efield
numproc drawflux np5c -bilinearform=alaplace -solution=u  -label=Dfield -applyd

define bilinearform Energy -fespace=v -symmetric -nonassemble
laplace cenergy
numproc evaluate np1 -bilinearform=Energy -gridfunction=u  -gridfunction2=u


numproc visualization npv1 -scalarfunction=u -subdivision=2 -nolineartexture