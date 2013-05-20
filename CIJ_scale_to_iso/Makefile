FC = gfortran
FCOPTS = -g -fbounds-check
BINDIR = /Users/nowacki/Applications/bin
MODDIR = /Users/nowacki/Applications/modules/mods
LIBDIR = /Users/nowacki/Applications/modules/lib
LIBS = -lanisotropy_ajn -lEmatrixUtils -lspherical_geometry

all: CIJ_scale_to_iso

install: all
	/bin/cp -f CIJ_scale_to_iso $(BINDIR)/

CIJ_scale_to_iso: CIJ_scale_to_iso.o 
	$(FC) ${FCOPTS} -o CIJ_scale_to_iso -J$(MODDIR) -L$(LIBDIR) ${LIBS} CIJ_scale_to_iso.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -I$(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_scale_to_iso *.mod *.o
