FC = gfortran
FCOPTS = 
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: CIJ_TandW

install: CIJ_TandW
	/bin/cp CIJ_TandW $(BINDIR)/CIJ_TandW

CIJ_TandW: CIJ_TandW.o
	$(FC) ${FCOPTS} -o CIJ_TandW -L $(LIBDIR) ${LIBS} CIJ_TandW.o

CIJ_TandW.o: CIJ_TandW.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) CIJ_TandW.f90

.PHONY: clean

clean:
	/bin/rm CIJ_TandW *.mod *.o
