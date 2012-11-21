FC = gfortran
FCOPTS = 
MODPATH = ~/Applications/modules
MODS = $(MODPATH)/EmatrixUtils.f90 $(MODPATH)/anisotropy_ajn/anisotropy_ajn.f90
BINDIR = ~nowacki/Applications/bin

default: CIJ_phasevels

install: CIJ_phasevels
	/bin/cp -f CIJ_phasevels $(BINDIR)/

CIJ_phasevels: CIJ_phasevels.f90 ${MODS}
	$(FC) ${FCOPTS} -o CIJ_phasevels ${MODS} CIJ_phasevels.f90

