FC = gfortran
FCOPTS = -O3 -fbounds-check
ECGRID = ~/Applications/modules/EC_grid
BINDIR = ~/Applications/bin

all: EC_grid_bin_dump

install: EC_grid_bin_dump
	/bin/cp EC_grid_bin_dump $(BINDIR)/EC_grid_bin_dump

EC_grid_bin_dump: EC_grid.o EC_grid_bin_dump.o
	$(FC) ${FCOPTS} -o EC_grid_bin_dump EC_grid.o EC_grid_bin_dump.o

EC_grid.o: $(ECGRID).f90
	$(FC) ${FCOPTS} -c $(ECGRID).f90

EC_grid_bin_dump.o: EC_grid.o EC_grid_bin_dump.f90
	$(FC) ${FCOPTS} -c EC_grid_bin_dump.f90

.PHONY: clean

clean:
	/bin/rm -f *.o *.mod