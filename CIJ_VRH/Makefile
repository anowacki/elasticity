FC = gfortran
FCOPTS = -g
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: CIJ_VRH

install: all
	/bin/cp CIJ_VRH $(BINDIR)/

CIJ_VRH: CIJ_VRH.o
	$(FC) ${FCOPTS} -o CIJ_VRH -L $(LIBDIR) ${LIBS} CIJ_VRH.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -I $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_VRH *.o *.mod