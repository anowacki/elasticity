FC = gfortran
FCOPTS = 

BINDIR = ~/Applications/bin

all: cijkl2Cij

install: cijkl2Cij
	/bin/cp cijkl2Cij $(BINDIR)/cijkl2Cij

cijkl2Cij: anisotropy_ajn.f90 cijkl2Cij.f90
	$(FC) ${FCOPTS} -o cijkl2Cij anisotropy_ajn.f90 cijkl2Cij.f90
