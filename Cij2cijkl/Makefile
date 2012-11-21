FC = gfortran
FCOPTS = 

BINDIR = ~/Applications/bin

all: Cij2cijkl

install: Cij2cijkl
	/bin/cp Cij2cijkl $(BINDIR)/Cij2cijkl

Cij2cijkl: anisotropy_ajn.f90 Cij2cijkl.f90
	$(FC) ${FCOPTS} -o Cij2cijkl anisotropy_ajn.f90 Cij2cijkl.f90
