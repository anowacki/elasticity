FC = gfortran
FCOPTS = -O3 -fbounds-check
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lEC_grid

all: default

default: EC_grid_inquire EC_grid_inquire_bin

install: EC_grid_inquire EC_grid_inquire_bin
	/bin/cp EC_grid_inquire EC_grid_inquire_bin $(BINDIR)/

EC_grid_inquire: $(MODS) EC_grid_inquire.o
	$(FC) ${FCOPTS} -o EC_grid_inquire -L $(LIBDIR) ${LIBS} EC_grid_inquire.o

EC_grid_inquire_bin: $(MODS) EC_grid_inquire_bin.o
	$(FC) ${FCOPTS} -o EC_grid_inquire_bin -L $(LIBDIR) ${LIBS} EC_grid_inquire_bin.o

%.o:%.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f EC_grid_inquire EC_grid_inquire_bin *.mod *.o
