FC = gfortran
FCOPTS = -O3
BINDIR = ~nowacki/Applications/bin
LIBDIR = ~nowacki/Applications/modules/lib
MODDIR = ~nowacki/Applications/modules/mods
LIBS = -lEC_grid

default: all

all: EC_grid_asc2bin EC_grid_bin2asc

install: EC_grid_asc2bin EC_grid_bin2asc
	/bin/cp EC_grid_asc2bin $(BINDIR)/EC_grid_asc2bin
	/bin/cp EC_grid_bin2asc $(BINDIR)/EC_grid_bin2asc

EC_grid_asc2bin: EC_grid_asc2bin.o
	$(FC) ${FCOPTS} -o EC_grid_asc2bin -L $(LIBDIR) ${LIBS} EC_grid_asc2bin.o

EC_grid_bin2asc: EC_grid_bin2asc.o
	$(FC) ${FCOPTS} -o EC_grid_bin2asc -L $(LIBDIR) ${LIBS} EC_grid_bin2asc.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f *.o EC_grid_asc2bin EC_grid_bin2asc