FC = gfortran
FCOPTS = -O3 -fbounds-check
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lEC_grid

all: EC_grid_bin_dump

install: EC_grid_bin_dump
	/bin/cp EC_grid_bin_dump $(BINDIR)/EC_grid_bin_dump

EC_grid_bin_dump: EC_grid_bin_dump.o
	$(FC) ${FCOPTS} -o EC_grid_bin_dump -L $(LIBDIR) ${LIBS} EC_grid_bin_dump.o

EC_grid_bin_dump.o: EC_grid_bin_dump.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) EC_grid_bin_dump.f90

.PHONY: clean

clean:
	/bin/rm -f *.o *.mod EC_grid_bin_dump