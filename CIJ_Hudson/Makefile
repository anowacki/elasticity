FC = gfortran
FCOPTS = -O3
BINDIR = ~nowacki/Applications/bin
LIBDIR = ~nowacki/Applications/modules/lib
MODDIR = ~nowacki/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: CIJ_Hudson

install: CIJ_Hudson
	/bin/cp -f CIJ_Hudson $(BINDIR)/CIJ_Hudson

CIJ_Hudson: CIJ_Hudson.o
	$(FC) ${FCOPTS} -o CIJ_Hudson -L $(LIBDIR) ${LIBS} CIJ_Hudson.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_Hudson *.o *.mod
