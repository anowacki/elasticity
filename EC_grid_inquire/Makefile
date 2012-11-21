FC = gfortran
BINDIR = ~nowacki/Applications/bin
FFLAGS = -O3 -fbounds-check
MODS = ~nowacki/Applications/modules/EC_grid.f90

default: EC_grid_inquire EC_grid_inquire_bin

install: EC_grid_inquire EC_grid_inquire_bin
	/bin/cp EC_grid_inquire EC_grid_inquire_bin $(BINDIR)/

EC_grid_inquire: $(MODS) EC_grid_inquire.f90 
	$(FC) ${FFLAGS} -o EC_grid_inquire $(MODS) EC_grid_inquire.f90

EC_grid_inquire_bin: $(MODS) EC_grid_inquire_bin.f90 
	$(FC) ${FFLAGS} -o EC_grid_inquire_bin $(MODS) EC_grid_inquire_bin.f90
