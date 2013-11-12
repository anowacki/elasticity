FC = gfortran
FCOPTS = -g -fbounds-check
BINDIR = ~nowacki/Applications/bin
LIBDIR = ~nowacki/Applications/modules/lib
MODDIR = ~nowacki/Applications/modules/mods
LIBS = -lanisotropy_ajn -lEC_grid


all: progs

progs: EC_grid_new_bin

install: all
	/bin/cp EC_grid_new_bin $(BINDIR)/

EC_grid_new_bin: EC_grid_new_bin.o 
	$(FC) ${FCOPTS} -o $@ -J $(MODDIR) -L $(LIBDIR) ${LIBS} $^

%.o: %.f90
	$(FC) ${FCOPTS} -c -I $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f *.o EC_grid_new_bin