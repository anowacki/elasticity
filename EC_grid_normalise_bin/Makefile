FC = gfortran
FCOPTS = -O3 -fbounds-check
BINDIR = ~nowacki/Applications/bin
MODDIR = ~nowacki/Applications/modules/mods
LIBDIR = ~nowacki/Applications/modules/lib
LIBS = -lEC_grid

default: EC_grid_normalise_bin

install: EC_grid_normalise_bin
	/bin/cp EC_grid_normalise_bin $(BINDIR)/

EC_grid_normalise_bin: EC_grid_normalise_bin.f90 
	$(FC) ${FCOPTS} -o $@ -J $(MODDIR) -L $(LIBDIR) ${LIBS} $^

.PHONY: clean

clean:
	/bin/rm -f EC_grid_normalise_bin *.o *.mod
