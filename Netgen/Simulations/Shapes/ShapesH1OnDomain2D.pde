# 
# Solves 
#
# -lamda*Laplace(u) = 0
#
#  u = u0 = 1.0 ... DRB: Gamma2 und Gamma4
#
#  du/dn = 0 ... NRB: Gamma1 und Gamma3
#

# Load mesh
mesh = TrigsOneDomain2D.vol
#mesh = QuadsOneDomain2D.vol

# coefficient lambda
define coefficient lambda
1,  

define coefficient coeffDirichlet
0, 1, 0, 1, 

define fespace v -type=h1ho -order=1 -dirichlet=[2,4]

define gridfunction u -fespace=v

define linearform f -fespace=v

define bilinearform a -fespace=v -symmetric
laplace lambda

numproc shapetester npst -gridfunction=u
numproc setvalues npsv -gridfunction=u -coefficient=coeffDirichlet -boundary
numproc bvp name -bilinearform=a -linearform=f -gridfunction=u -solver=direct

# Specific visualization options are set
numproc visualization name -subdivision=3 -scalarfunction=u -nonlineartexture -minval=0 -maxval=0.8