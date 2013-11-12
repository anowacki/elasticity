FC = gfortran
FCOPTS = -O2 -g -ggdb -fbounds-check -frange-check
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn -lget_args

all: CIJ_Reuss

install: CIJ_Reuss
	/bin/cp -f CIJ_Reuss $(BINDIR)/

CIJ_Reuss: CIJ_Reuss.o
	$(FC) ${FCOPTS} -o $@ -L $(LIBDIR) ${LIBS} $^

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f *.o
