FC = gfortran
FCOPTS = -O2


BINDIR = ~nowacki/Applications/bin

all: EC_rot3 EC_rot3_xyz

install: all
	cp -f EC_rot3 EC_rot3_xyz $(BINDIR)/

EC_rot3: constants.o anisotropy_ajn.o EC_rot3.f90
	$(FC) ${FCOPTS} -c EC_rot3.f90
	$(FC) ${FCOPTS} -o EC_rot3 EC_rot3.o constants.o anisotropy_ajn.o

EC_rot3_xyz: constants.o anisotropy_ajn.o EC_grid.o EC_rot3_xyz.f90 EC_grid.o
	$(FC) ${FCOPTS} -c EC_rot3_xyz.f90
	$(FC) ${FCOPTS} -o EC_rot3_xyz EC_rot3_xyz.o constants.o anisotropy_ajn.o EC_grid.o

EC_grid.o: EC_grid.f90
	$(FC) ${FCOPTS} -c EC_grid.f90

%.o: %.f90
	$(FC) ${FCOPTS} -c $*.f90

clean:
	/bin/rm -f *.o *.mod EC_rot3 EC_rot3_xyz
