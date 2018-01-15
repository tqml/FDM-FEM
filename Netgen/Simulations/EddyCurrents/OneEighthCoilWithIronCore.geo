algebraic3d

solid box = orthobrick (-0.08, -0.08, -0.08; 0.08, 0.08, 0.08) -bc=1;

solid core = orthobrick (-0.0025, -0.0025, -0.015; 0.0025, 0.0025, 0.015) -bc=2 -maxh=0.0004;

solid coil = cylinder (0, 0, -1; 0, 0, 1; 0.005)
	and not cylinder  (0, 0, -1; 0, 0, 1; 0.004)
	and plane (0, 0, 0.01; 0, 0, 1)
	and plane (0, 0, -0.01; 0, 0, -1) -bc=2;

solid air =  box and not (core or coil);


solid planex = plane(0,0,0;-1,0,0)  -bc=3;
solid planey = plane(0,0,0; 0,-1,0) -bc=3;
solid planez = plane(0,0,0; 0, 0, -1) -bc=4;

solid cut = planex and planey and planez; # for one eighth of the whole domain

solid coil_part = coil and cut;
		
solid core_part = core and cut;

solid air_part = air and cut;


tlo core_part -col=[1, 1, 0] -material=core;
tlo coil_part -col=[0, 1, 0] -material=coil;
tlo air_part -transparent -material=air;


