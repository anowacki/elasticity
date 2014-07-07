FC = gfortran
FCOPTS = -O2
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn

default: Au EC_grid2Au.bash

install: Au EC_grid2Au.bash
	/bin/cp Au $(BINDIR)/
	/bin/cp EC_grid2Au.bash $(BINDIR)/EC_grid2Au

Au: Au.o
	$(FC) $(FCOPTS) -o Au -L $(LIBDIR) ${LIBS} Au.o

%.o: %.f90
	$(FC) $(FCOPTS) -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm Au *.mod *.o
