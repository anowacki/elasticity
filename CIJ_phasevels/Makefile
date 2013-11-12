FC = gfortran
FCOPTS = 
BINDIR = ~nowacki/Applications/bin
LIBDIR = ~nowacki/Applications/modules/lib
MODDIR = ~nowacki/Applications/modules/mods
LIBS = -lanisotropy_ajn -lEmatrixUtils

all: CIJ_phasevels

install: CIJ_phasevels
	/bin/cp -f CIJ_phasevels $(BINDIR)/

CIJ_phasevels: CIJ_phasevels.o
	$(FC) ${FCOPTS} -o CIJ_phasevels -L $(LIBDIR) ${LIBS} CIJ_phasevels.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_phasevels *.mod *.o
