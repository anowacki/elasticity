FC = gfortran
FCOPTS = -g -fbounds-check
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: CIJ_stable

install: all
	/bin/cp CIJ_stable $(BINDIR)/

CIJ_stable: CIJ_stable.o 
	$(FC) ${FCOPTS} -o CIJ_stable -L $(LIBDIR) ${LIBS} CIJ_stable.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -I $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_stable *.o *.mod
