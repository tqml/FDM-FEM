#
# Solves the equation -div \epsilon grad u = f in Omega
#
# with boundary conditions
#      u = 0  on Gamma1
#  du/dn = 0  on Gamma2 and Gamma3
#      u = 1  on Gamma4
#
# Note that Dirichlet boundary conditions are prescribed by penalization!


# load geometry
geometry = Electrostatics.in2d

# and mesh
mesh = Electrostatics.vol


define constant epsilon0 = 8.854e-12
define constant epsilon_r = 1.0


# coefficient for laplace with epsilon_r
define coefficient epsilon
(epsilon0*epsilon_r),

# coefficient for energy with epsilon_r
define coefficient cenergy
(0.5*epsilon0*epsilon_r), 


# Dirichlet boundary conditions are implemented by penalty:
# large value on Gamma1 and Gamma4


# coefficient for the robin
define coefficient alphaR
1e6, 0, 0, 1e6,

# coefficient for the source
define coefficient coef_source
0.815,
#(x),

# coefficient for the neumann
define coefficient alphaN
0, 0, 0, 1e6


# define a second order fespace (play around with -order=...)
define fespace v -h1ho -order=5

# the solution field ...
define gridfunction u -fespace=v -nested

# bilinear form. 
define bilinearform a -fespace=v -symmetric
laplace epsilon
robin alphaR


define linearform F -fespace=v
#source coef_source
neumann	alphaN


# define preconditioner c -type=direct -bilinearform=a
# define preconditioner c -type=local -bilinearform=a
# define preconditioner c -type=multigrid -bilinearform=a -smoothingsteps=1 


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


#numproc visualization npv1 -scalarfunction=u -subdivision=2 -nolineartexture