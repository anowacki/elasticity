FC = gfortran
FCOPTS = -O3
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: CIJ_global_VTI

install: CIJ_global_VTI
	/bin/cp CIJ_global_VTI $(BINDIR)/CIJ_global_VTI

CIJ_global_VTI: CIJ_global_VTI.o
	$(FC) ${FCOPTS} -o CIJ_global_VTI -L $(LIBDIR) ${LIBS} CIJ_global_VTI.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_global_VTI *.o *.mod
