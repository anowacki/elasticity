FC = gfortran
FCOPTS = -g -fbounds-check -Wall
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lEC_grid

all: progs

progs: EC_grid_interp_bin

install: all
	/bin/cp EC_grid_interp_bin $(BINDIR)/

EC_grid_interp_bin: EC_grid_interp_bin.o 
	$(FC) ${FCOPTS} -o $@ -J $(MODDIR) -L $(LIBDIR) ${LIBS} $^

%.o: %.f90
	$(FC) ${FCOPTS} -c -I $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f EC_grid_interp_bin *.o