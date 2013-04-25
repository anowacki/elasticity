FC = gfortran
FCOPTS = -g -ggdb -fbounds-check -frange-check
L = ~/Applications/modules/lib
LIBS = -lanisotropy_ajn -lget_args
M = ~/Applications/modules/mods
BINDIR = ~/Applications/bin

all: CIJ_Reuss

install: CIJ_Reuss
	/bin/cp -f CIJ_Reuss $(BINDIR)/

CIJ_Reuss: CIJ_Reuss.o
	$(FC) ${FCOPTS} -o $@ -L $(L) ${LIBS} -J $(M) $^

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(M) $*.f90
