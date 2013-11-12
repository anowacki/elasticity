FC = gfortran
FCOPTS = -O2
BINDIR = ~nowacki/Applications/bin
LIBDIR = ~nowacki/Applications/modules/lib
MODDIR = ~nowacki/Applications/modules/mods
LIBS = -lconstants -lanisotropy_ajn -lEC_grid

all: EC_rot3 EC_rot3_xyz

install: all
	cp EC_rot3 EC_rot3_xyz $(BINDIR)/

EC_rot3: EC_rot3.o
	$(FC) ${FCOPTS} -o EC_rot3 -L $(LIBDIR) ${LIBS} EC_rot3.o

EC_rot3_xyz: EC_rot3_xyz.o
	$(FC) ${FCOPTS} -o EC_rot3_xyz -L $(LIBDIR) ${LIBS} EC_rot3_xyz.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

clean:
	/bin/rm -f *.o *.mod EC_rot3 EC_rot3_xyz
