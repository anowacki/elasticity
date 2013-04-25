FC = gfortran
BINDIR = ~nowacki/Applications/bin
FFLAGS = -O3 -fbounds-check
MODS = ~nowacki/Applications/modules/EC_grid.f90
B = ../bin

default: EC_grid_normalise_bin

EC_grid_normalise_bin: $B/EC_grid_normalise_bin

install: EC_grid_normalise_bin
	/bin/cp $B/EC_grid_normalise_bin $(BINDIR)/

$B/EC_grid_normalise_bin: $(MODS) EC_grid_normalise_bin.f90 
	$(FC) ${FFLAGS} -o $B/EC_grid_normalise_bin $(MODS) EC_grid_normalise_bin.f90
