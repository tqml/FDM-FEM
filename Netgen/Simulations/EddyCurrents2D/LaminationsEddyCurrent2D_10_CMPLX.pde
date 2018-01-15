# 
# Solves curl u = 0
#
# with appriate boundary conditions
#


#shared = NonLinEddyNewton2D
shared = ErrorAnalysis


define constant heapsize = 100000000
#define constant testout = test.out

# and mesh
#mesh = Laminations2D_10.vol
#mesh = LaminationsTwoDomains2D1_10.vol
#mesh = LaminationsTwoDomains2D1_20.vol
#mesh = LaminationsTwoDomains2D1_40.vol
#mesh = LaminationsTwoDomains2D1_80.vol

#mesh = Laminates_10_2Domains_d2_2D.vol
#mesh = Laminates_10_2Domains_d2_2D_sym.vol

#mesh = LaminationsTwoDomains2D1_10.vol

#mesh = Laminates_10_2Domains_2D.vol
mesh = Laminates_10_2Domains_2D_py.vol
#mesh = Laminates_10_2Domains_fine_2D_py.vol


define constant freq = 50.0
define constant pi = 3.141592654

# permeability of vacuum
define constant mue0 = 12.5664e-7

# relative permeability 1
define constant muer1 = 1000.0

# relative permeability 2
define constant muer2 = 1.0

# conductivity sigma
define constant sigma = 2.0e6

# Dirichlet boundary conditions are modelled by penalization
define constant alphaPenalty = 1e10

# coefficient for CurlCurl
define coefficient nue
(1/mue0/muer1), (1/mue0/muer2), 

# coefficient for Energy
define coefficient cenergy
(0.5*1/mue0/muer1), (1/mue0/muer2), 


# coefficient for omegasigma
define coefficient omegasigma
(2.0*pi*freq*sigma), 1e-9, 

define coefficient omegasigmavis
(2.0*pi*freq*sigma), 0.0, 


# coefficient for Losses
define coefficient closs
(0.5*2.0*pi*freq*2.0*pi*freq*2.0e6), 1e-9, 

# coefficient for Visualization
define coefficient one
1.0, 1.0, 


define coefficient CoeffRobin
0, (alphaPenalty), (alphaPenalty), (alphaPenalty), (alphaPenalty),   

define constant a0 = 0.01

define coefficient CoeffNeumann0x   
0, (alphaPenalty*a0), 0, (-alphaPenalty*a0), 0, 
define coefficient CoeffNeumann0y
0, 0, (alphaPenalty*a0), 0, (-alphaPenalty*a0), 

define coefficient Ax
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, # linear

define coefficient Ay
(x), (x), (x), (x), (x), (x), (x), (x), (x), (x), # linear


define fespace v -hcurlho -order=2 -complex #-print

define gridfunction u -fespace=v -addcoef # -novisual

define bilinearform a -fespace=v -symmetric #-printelmat -print
curlcurledge nue
massedge omegasigma -imag
robinedge CoeffRobin

define linearform f -fespace=v
neumannedge CoeffNeumann0x CoeffNeumann0y
#sourceedge Ax Ay

numproc bvp np1 -bilinearform=a -linearform=f -gridfunction=u -solver=direct

define bilinearform acurl -fespace=v -symmetric -nonassemble
curlcurledge nue
define bilinearform amass -fespace=v -symmetric -nonassemble
massedge omegasigmavis -definedon=1

numproc drawflux np5a -bilinearform=acurl -solution=u  -label=B
#numproc drawflux np5b -bilinearform=acurl -solution=u  -label=H -applyd
numproc drawflux np5c -bilinearform=amass -solution=u  -label=A
numproc drawflux np5d -bilinearform=amass -solution=u  -label=J -applyd

numproc visualization npvis  -scalarfunction=J  -evaluate=abs -clipsolution=scalar -subdivision=6 #-clipvec=[0,0,-1]

# Losses P
define bilinearform Losses1 -fespace=v -symmetric -nonassemble
massedge closs -definedon=1
numproc evaluate np1 -bilinearform=Losses1 -gridfunction=u  -gridfunction2=u -hermitsch
define bilinearform Losses2 -fespace=v -symmetric -nonassemble
massedge closs -definedon=2
numproc evaluate np2 -bilinearform=Losses2 -gridfunction=u  -gridfunction2=u -hermitsch

# Magnetic energy W
define bilinearform MagEnergy1 -fespace=v -symmetric -nonassemble
curlcurledge cenergy -definedon=1
numproc evaluate np1 -bilinearform=MagEnergy1 -gridfunction=u  -gridfunction2=u -hermitsch
define bilinearform MagEnergy2 -fespace=v -symmetric -nonassemble
curlcurledge cenergy -definedon=2
numproc evaluate np2 -bilinearform=MagEnergy2 -gridfunction=u  -gridfunction2=u -hermitsch


define coefficient fac
1.0, 1.0, 
define bilinearform aeamass -fespace=v -symmetric -printelmat #-print
massedge fac
define bilinearform aeastiff -fespace=v -symmetric #-printelmat -print
curlcurledge one

numproc NumProcWriteRefSolution npout -bilinearform=aeamass -linearform=f -gridfunction=u -iform=ecpvp2d -domainnr=0 
numproc drawflux np5d -bilinearform=aeamass -solution=u  -label=Jea -applyd


# Losses P
define bilinearform Losses1 -fespace=v -symmetric -nonassemble
massedge closs -definedon=1
numproc evaluate np1 -bilinearform=Losses1 -gridfunction=u  -gridfunction2=u -hermitsch
define bilinearform Losses2 -fespace=v -symmetric -nonassemble
massedge closs -definedon=2
numproc evaluate np2 -bilinearform=Losses2 -gridfunction=u  -gridfunction2=u -hermitsch


### Begin: Check the Volume

define coefficient one
1.0, 1.0, 1.0, 

define coefficient pen
(alphaPenalty), (alphaPenalty), (alphaPenalty), 

define fespace v1 -h1ho -order=1 
define gridfunction u1 -fespace=v1

define linearform f1 -fespace=v1
source pen
#neumann one

define bilinearform a1 -fespace=v1 -symmetric -linearform=f1
mass pen

numproc bvp np1 -bilinearform=a1 -linearform=f1 -gridfunction=u1 -solver=direct

define bilinearform Volume1 -fespace=v1 -symmetric -nonassemble
mass one -definedon=1
numproc evaluate np2 -bilinearform=Volume1 -gridfunction=u1  -gridfunction2=u1
define bilinearform Volume2 -fespace=v1 -symmetric -nonassemble
mass one -definedon=2
numproc evaluate np2 -bilinearform=Volume2 -gridfunction=u1  -gridfunction2=u1

### End: Check the Volume


### Projection of solution u into uvis:
define fespace vis -hcurlho -order=2 -complex -definedon=1 #-print
define gridfunction uvis -fespace=vis  # -novisual
#define coefficient uviscoeff
#(u) 
numproc setvalues npsv -gridfunction=uvis -coefficient=u




