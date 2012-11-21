FC = gfortran
FCOPTS = -g -fbounds-check
BINDIR = /Users/nowacki/Applications/bin
MODDIR = /Users/nowacki/Applications/modules/mods
LIBDIR = /Users/nowacki/Applications/modules/lib
LIBS = -lanisotropy_ajn -lEC_grid

all: progs

progs: EC_grid_new_bin

install: all
	/bin/cp -f EC_grid_new_bin $(BINDIR)/

EC_grid_new_bin: EC_grid_new_bin.o 
	$(FC) ${FCOPTS} -o $@ -J$(MODDIR) -L$(LIBDIR) ${LIBS} $^

%.o: %.f90
	$(FC) ${FCOPTS} -c -I$(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f *.o