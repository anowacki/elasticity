FC = gfortran
FFLAGS = -O3
BINDIR = ~/Applications/bin

MOD = ~/Applications/modules/EC_grid.f90

default: all

all: EC_grid_asc2bin EC_grid_bin2asc

install: EC_grid_asc2bin EC_grid_bin2asc
	/bin/cp EC_grid_asc2bin $(BINDIR)/EC_grid_asc2bin
	/bin/cp EC_grid_bin2asc $(BINDIR)/EC_grid_bin2asc

EC_grid_asc2bin: EC_grid_asc2bin.f90
	$(FC) ${FFLAGS} -o EC_grid_asc2bin $(MOD) EC_grid_asc2bin.f90

EC_grid_bin2asc: EC_grid_bin2asc.f90
	$(FC) ${FFLAGS} -o EC_grid_bin2asc $(MOD) EC_grid_bin2asc.f90

.PHONY: clean

clean:
	/bin/rm EC_grid_asc2bin EC_grid_bin2asc