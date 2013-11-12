FC = gfortran
FCOPTS = 
BINDIR = ~nowacki/Applications/bin
LIBDIR = ~nowacki/Applications/modules/lib
MODDIR = ~nowacki/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: cijkl2Cij

install: cijkl2Cij
	/bin/cp cijkl2Cij $(BINDIR)/cijkl2Cij

cijkl2Cij: cijkl2Cij.o
	$(FC) ${FCOPTS} -o cijkl2Cij -L $(LIBDIR) ${LIBS} cijkl2Cij.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f cijkl2Cij *.o *.mod
