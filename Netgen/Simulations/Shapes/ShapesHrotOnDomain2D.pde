# 
# Solves curl (lambda curl u) = 0
#
# u_tang = (1,0)^T... DRB: Gamma1 und Gamma3 
#
# u_tang = (0,0)^T... DRB: Gamma2 und Gamma4 
#


#mesh = TrigsOneDomain2D.vol
mesh = QuadsOneDomain2D.vol


# Dirichlet boundary conditions are modelled by penalization
define constant alphaPenalty = 1e10

# coefficient lambda
define coefficient lambda
1.0,

# coefficient for regularization
define coefficient epsreg
1e-6, 

define coefficient CoeffRobin
(alphaPenalty), (alphaPenalty), (alphaPenalty), (alphaPenalty),

define constant a0 = 1.0

define coefficient CoeffNeumann0x   
(alphaPenalty*a0), 0, (alphaPenalty*a0), 0,
define coefficient CoeffNeumann0y
0, 0, 0, 0,

define coefficient coeffDirichlet
1, 0, 1, 0, 


define fespace v -hcurlho -order=0 -dirichlet=[1,2,3,4]

define gridfunction u -fespace=v

define bilinearform a -fespace=v -symmetric
curlcurledge lambda
massedge epsreg
#robinedge CoeffRobin

define linearform f -fespace=v
#neumannedge CoeffNeumann0x CoeffNeumann0y

numproc shapetester npst -gridfunction=u
numproc setvalues npsv -gridfunction=u -coefficient=coeffDirichlet -boundary
numproc bvp np1 -bilinearform=a -linearform=f -gridfunction=u -solver=direct

# Specific visualization options are set
numproc visualization vis1 -vectorfunction=u -subdivision=3 -minval=0 -maxval=5
