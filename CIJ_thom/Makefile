FC = gfortran
FCOPTS = 
MODPATH = ~/Applications/modules
MODS = $(MODPATH)/anisotropy_ajn/anisotropy_ajn.f90
BINDIR = ~nowacki/Applications/bin

default: CIJ_thom

install: CIJ_thom
	/bin/cp -f CIJ_thom $(BINDIR)/

CIJ_thom: CIJ_thom.f90 ${MODS}
	$(FC) ${FCOPTS} -o CIJ_thom ${MODS} CIJ_thom.f90

