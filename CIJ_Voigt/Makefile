FC = gfortran
FCOPTS = -O2 -g -ggdb -fbounds-check -frange-check
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn -lget_args

all: CIJ_Voigt

install: CIJ_Voigt
	/bin/cp CIJ_Voigt $(BINDIR)/

CIJ_Voigt: CIJ_Voigt.o
	$(FC) ${FCOPTS} -o $@ -L $(LIBDIR) ${LIBS} $^

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f *.o
