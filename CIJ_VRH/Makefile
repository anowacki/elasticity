FC = gfortran
FCOPTS = -g
BINDIR = /Users/nowacki/Applications/bin
LIBDIR = /Users/nowacki/Applications/modules/lib
MODDIR = /Users/nowacki/Applications/modules/mods
LIB = anisotropy_ajn

all: CIJ_VRH

install: all
	/bin/cp -f CIJ_VRH $(BINDIR)/

CIJ_VRH: $(LIBDIR)/lib$(LIB).so CIJ_VRH.o
	$(FC) ${FCOPTS} -o CIJ_VRH -J$(MODDIR) -L${LIBDIR} -l$(LIB) CIJ_VRH.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -I$(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_VRH *.o *.mod