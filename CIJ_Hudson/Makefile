FC = gfortran
FCOPTS = -O3
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: CIJ_Hudson

install: CIJ_Hudson
	/bin/cp CIJ_Hudson $(BINDIR)/CIJ_Hudson

CIJ_Hudson: CIJ_Hudson.o
	$(FC) ${FCOPTS} -o CIJ_Hudson -L $(LIBDIR) ${LIBS} CIJ_Hudson.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_Hudson *.o *.mod
