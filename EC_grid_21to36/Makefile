FC = gfortran
FCOPTS = 
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lEC_grid

all: EC_grid_21to36

install: EC_grid_21to36
	cp EC_grid_21to36 $(BINDIR)/

EC_grid_21to36: swap2136.o
	$(FC) ${FCOPTS} -o EC_grid_21to36 -L $(LIBDIR) ${LIBS} swap2136.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f EC_grid_21to36 *.mod *.o
