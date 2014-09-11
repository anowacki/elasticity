FC = gfortran
FCOPTS = 
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: CIJ_phasevels

install: CIJ_phasevels
	/bin/cp CIJ_phasevels $(BINDIR)/

CIJ_phasevels: CIJ_phasevels.o
	$(FC) ${FCOPTS} -o CIJ_phasevels -L $(LIBDIR) ${LIBS} CIJ_phasevels.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_phasevels *.mod *.o
