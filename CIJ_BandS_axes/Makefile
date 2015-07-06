FC = gfortran
FCOPTS = -g -fcheck=all -ffpe-trap=zero,overflow,invalid -Wall
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: CIJ_BandS_axes

install: all
	/bin/cp CIJ_BandS_axes $(BINDIR)/

CIJ_BandS_axes: CIJ_BandS_axes.o 
	$(FC) ${FCOPTS} -o CIJ_BandS_axes -L $(LIBDIR) ${LIBS} CIJ_BandS_axes.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -I $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_BandS_axes *.o *.mod
