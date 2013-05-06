FC = gfortran
FCOPTS = -g -fbounds-check -Wall
BINDIR = /Users/nowacki/Applications/bin
MODDIR = /Users/nowacki/Applications/modules/mods
LIBDIR = /Users/nowacki/Applications/modules/lib
LIBS = -lEC_grid

all: progs

progs: EC_grid_interp_bin

install: all
	/bin/cp -f EC_grid_interp_bin $(BINDIR)/

EC_grid_interp_bin: EC_grid_interp_bin.o 
	$(FC) ${FCOPTS} -o $@ -J$(MODDIR) -L$(LIBDIR) ${LIBS} $^

%.o: %.f90
	$(FC) ${FCOPTS} -c -I$(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f EC_grid_interp_bin *.o