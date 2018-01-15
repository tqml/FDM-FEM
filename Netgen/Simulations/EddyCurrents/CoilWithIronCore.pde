#
# Coil with iron core considering eddy currents
#
# Dirichlet boundary conditions are prescribed by penalization
#
# Domain 1: core
# Domain 2: coil
# Domain 3: air
#


define constant geometryorder = 7
define constant heapsize = 50000000


geometry = CoilWithIronCore.geo #in m
mesh = CoilWithIronCore.vol


# Penalization factor
define constant alphaPenalty = 1e10
define constant pi = 3.1415
#frequency
define constant freq = 50
#vacuum permeability
define constant mu0 = (4*pi*1.0e-7) # in Vs/(A cm)
#relative permeability
define constant muer_fe = 1000.0
#electric conductivity
define constant sigma_fe = (2.0e6) # in S/m
#regularization factor
define constant reg = 1e-1
#prescribed current density
define constant J0 = (1.0e6) # in A/m2 -> theta = J0*1e-3*2e-2(m^2) = 20A


define fespace v -type=hcurlho -order=2 -nograds -eliminate_internal  -complex


define gridfunction u -fespace=v  -novisual


#linearform
define coefficient cs material # J0 is peak value
	core (0,0,0)
	coil ((J0*(-y)/sqrt(x*x+y*y)),(J0*x/sqrt(x*x+y*y)), 0)
	air (0,0,0)
define linearform f -fespace=v
sourceedge cs


#bilinearform
define coefficient nu material
	core (1.0/(muer_fe*mu0))
	coil (1.0/mu0)
	air (1.0/mu0)
	
define coefficient omegasigma material
	core (2*pi*freq*sigma_fe)
	coil (2*pi*freq*reg)
	air  (2*pi*freq*reg)
	
define coefficient CoeffRobin0
(alphaPenalty), 0, 

define bilinearform a -fespace=v -symmetric  -eliminate_internal 
curlcurledge nu 
massedge omegasigma -imag
robinedge CoeffRobin0


#solver
define preconditioner c -type=multigrid -bilinearform=a -cylce=1 -smoother=block -blocktype=1 -coarsetype=direct -coarsesmoothingsteps=5
numproc bvp np1 -bilinearform=a -linearform=f -gridfunction=u -preconditioner=c  -prec=1.e-9 -direct


#visualization
define bilinearform acurl -fespace=v -nonassemble
curlcurledge nu
define bilinearform amass -fespace=v -nonassemble
massedge omegasigma -definedon=1
numproc drawflux npdf1 -bilinearform=acurl -solution=u  -label=B-field
numproc drawflux npdf2 -bilinearform=acurl -solution=u  -label=H-field -applyd
numproc drawflux npdf3 -bilinearform=amass -solution=u  -label=A-field
numproc drawflux npdf4 -bilinearform=amass -solution=u  -label=J-field -applyd
numproc visualization npvis  -scalarfunction=B-field -clipvec=[0,1,0] -evaluate=abs -scalarfun -clipsolution=scalar 


#losses =  0.5 * int J*E' = 0.5 * int sigma E*E' = 0.5 * int omega*sigma A*A' 
define coefficient closs
(0.5*2*pi*freq*2*pi*freq*sigma_fe), 0.0, 0.0, 

define bilinearform losses -fespace=v -symmetric -nonassemble
massedge closs -definedon=1
numproc evaluate np1 -bilinearform=losses -gridfunction=u  -gridfunction2=u -hermitsch

#energy =  0.5 * int B*B'/mu
define coefficient cenergy
(0.5/(muer_fe*mu0)), (0.5/mu0), (0.5/mu0)
define bilinearform energy -fespace=v -symmetric -nonassemble
curlcurledge cenergy
numproc evaluate np2 -bilinearform=energy -gridfunction=u -gridfunction2=u -hermitsch 