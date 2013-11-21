FC = gfortran
FCOPTS = -Wall -fbounds-check -frange-check -g -ggdb -O3
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIB = -lanisotropy_ajn -lEC_grid

default: all

all: EC_grid_rotate_bin

install: EC_grid_rotate_bin
	/bin/cp EC_grid_rotate_bin $(BINDIR)/

EC_grid_rotate_bin: EC_grid_rotate_bin.o
	$(FC) ${FCOPTS} -o $@ -J $(MODDIR) -L $(LIBDIR) ${LIB} $^

EC_grid_rotate_bin.o: EC_grid_rotate_bin.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $^

.PHONY: clean

clean:
	/bin/rm -f EC_grid_rotate_bin *.mod *.o
