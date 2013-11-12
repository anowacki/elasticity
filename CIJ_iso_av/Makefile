FC = gfortran
FCOPTS = -g -fbounds-check
BINDIR = ~nowacki/Applications/bin
LIBDIR = ~nowacki/Applications/modules/lib
MODDIR = ~nowacki/Applications/modules/mods
LIBS = -lanisotropy_ajn -lEmatrixUtils -lspherical_geometry

all: CIJ_iso_av

install: all
	/bin/cp -f CIJ_iso_av $(BINDIR)/

CIJ_iso_av: CIJ_iso_av.o 
	$(FC) ${FCOPTS} -o CIJ_iso_av -L $(LIBDIR) ${LIBS} CIJ_iso_av.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -I $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_iso_av *.o *.mod
