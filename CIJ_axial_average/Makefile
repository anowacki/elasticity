FC = gfortran
FCOPTS = -g -fbounds-check
BINDIR = ~nowacki/Applications/bin
LIBDIR = ~nowacki/Applications/modules/lib
MODDIR = ~nowacki/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: CIJ_axial_average

install: all
	/bin/cp CIJ_axial_average $(BINDIR)/

CIJ_axial_average: CIJ_axial_average.o 
	$(FC) ${FCOPTS} -o CIJ_axial_average -L $(LIBDIR) ${LIBS} CIJ_axial_average.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -I $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_axial_average *.o *.mod
