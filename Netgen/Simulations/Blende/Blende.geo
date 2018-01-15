algebraic3d

solid Plane1 = plane (0, 0, 0; 1, 0, 0) -bc=1;
solid Plane2 = plane (0.9, 0, 0; 1, 0, 0) -bc=3;
solid Plane3 = plane (1.1, 0, 0; 1, 0, 0) -bc=3;
solid Plane4 = plane (2.0, 0, 0; 1, 0, 0) -bc=2;

solid Plane21 = plane (0.8, 0, 0; 1, 0, 0);
solid Plane31 = plane (1.2, 0, 0; 1, 0, 0);

solid Cyl1 = cylinder (-1, 0, 0; 1, 0, 0; 1) -bc=2;
solid Cyl2 = cylinder (-1, 0, 0; 2, 0, 0; 0.2) -bc=3;
solid Cyl3 = cylinder (-1, 0, 0; 2, 0, 0; 1) -bc=2;

solid zyl1 = Cyl1 and not Plane1 and Plane2;
solid zyl2 = Cyl2 and not Plane21 and Plane31;
solid zyl3 = Cyl3 and not Plane3 and Plane4;

solid Blende = zyl1 or zyl2 or zyl3;

tlo Blende -col=[0, 1, 0] -material=matcoil; 
