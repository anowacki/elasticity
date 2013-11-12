FC = gfortran
FCOPTS = 
BINDIR = ~nowacki/Applications/bin
LIBDIR = ~nowacki/Applications/modules/lib
MODDIR = ~nowacki/Applications/modules/mods
LIBS = -lEC_grid

all: EC_grid_21to36

install: EC_grid_21to36
	cp -f EC_grid_21to36 $(BINDIR)/

EC_grid_21to36: swap2136.o
	$(FC) -o EC_grid_21to36 -L $(LIBDIR) ${LIBS} swap2136.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f EC_grid_21to36 *.mod *.o
