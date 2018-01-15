algebraic3d

solid box = orthobrick (-0.08, -0.08, -0.08; 0.08, 0.08, 0.08) -bc=1;

solid core = orthobrick (-0.0025, -0.0025, -0.015; 0.0025, 0.0025, 0.015) -bc=2 -maxh=0.0006;

solid coil = cylinder (0, 0, -1; 0, 0, 1; 0.005)
	and not cylinder  (0, 0, -1; 0, 0, 1; 0.004)
	and plane (0, 0, 0.01; 0, 0, 1)
	and plane (0, 0, -0.01; 0, 0, -1) -bc=2; 
	
solid air =  box and not (core or coil);


tlo core -col=[1, 1, 0] -material=core;
tlo coil -col=[0, 1, 0] -material=coil;
tlo air -transparent -material=air;
