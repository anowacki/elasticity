FC = gfortran
FCOPTS = -O2 -g -ggdb -fbounds-check -frange-check
L = ~/Applications/modules/lib
LIBS = -lanisotropy_ajn -lget_args
M = ~/Applications/modules/mods
BINDIR = ~/Applications/bin

all: CIJ_Voigt

install: CIJ_Voigt
	/bin/cp -f CIJ_Voigt $(BINDIR)/

CIJ_Voigt: CIJ_Voigt.o
	$(FC) ${FCOPTS} -o $@ -L $(L) ${LIBS} -J $(M) $^

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(M) $*.f90

.PHONY: clean

clean:
	/bin/rm -f *.o
