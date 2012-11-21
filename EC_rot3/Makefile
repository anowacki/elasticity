all: EC_rot3 EC_rot3_xyz

EC_rot3: constants.o anisotropy_ajn.o EC_rot3.f90
	gfortran -c EC_rot3.f90
	gfortran -o EC_rot3 EC_rot3.o constants.o anisotropy_ajn.o

EC_rot3_xyz: constants.o anisotropy_ajn.o EC_grid.o EC_rot3_xyz.f90 EC_grid.o
	gfortran -c EC_rot3_xyz.f90
	gfortran -o EC_rot3_xyz EC_rot3_xyz.o constants.o anisotropy_ajn.o EC_grid.o

EC_grid.o: EC_grid.f90
	gfortran -c EC_grid.f90

clean:
	/bin/rm EC_rot3.o