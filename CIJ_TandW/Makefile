FC = gfortran
FFLAGS = 
GLOBALBIN = /Users/nowacki/Applications/bin
LIBDIR = /Users/nowacki/Applications/modules/lib

all: CIJ_TandW

install: CIJ_TandW
	/bin/cp CIJ_TandW $(GLOBALBIN)/CIJ_TandW

CIJ_TandW: CIJ_TandW.o anisotropy_ajn.o
	$(FC) ${FFLAGS} -o CIJ_TandW anisotropy_ajn.o CIJ_TandW.o

anisotropy_ajn.o: anisotropy_ajn.f90
	$(FC) ${FFLAGS} -c anisotropy_ajn.f90

CIJ_TandW.o: anisotropy_ajn.o CIJ_TandW.f90
	$(FC) ${FFLAGS} -c CIJ_TandW.f90

.PHONY: clean

clean:
	/bin/rm CIJ_TandW *.mod *.o
