FC = gfortran
FCOPTS = 
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: Cij2cijkl

install: Cij2cijkl
	/bin/cp Cij2cijkl $(BINDIR)/Cij2cijkl

Cij2cijkl: Cij2cijkl.o
	$(FC) ${FCOPTS} -o Cij2cijkl -L $(LIBDIR) ${LIBS} Cij2cijkl.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f Cij2cijkl *.mod *.o
