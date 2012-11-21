FC = gfortran
FCOPTS = -g -fbounds-check
BINDIR = /Users/nowacki/Applications/bin
MODDIR = /Users/nowacki/Applications/modules/mods
LIBDIR = /Users/nowacki/Applications/modules/lib
LIBS = -lanisotropy_ajn -lEmatrixUtils -lspherical_geometry

all: CIJ_iso_av

install: all
	/bin/cp -f CIJ_iso_av $(BINDIR)/

CIJ_iso_av: CIJ_iso_av.o 
	$(FC) ${FCOPTS} -o CIJ_iso_av -J$(MODDIR) -L$(LIBDIR) ${LIBS} CIJ_iso_av.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -I$(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f *.o