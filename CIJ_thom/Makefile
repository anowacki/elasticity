FC = gfortran
FCOPTS = 
MODPATH = ~/Applications/modules
MODS = $(MODPATH)/anisotropy_ajn/anisotropy_ajn.f90
BINDIR = ~nowacki/Applications/bin

default: CIJ_thom CIJ_thom_list

install: CIJ_thom CIJ_thom_list
	/bin/cp -f CIJ_thom CIJ_thom_list $(BINDIR)/

CIJ_thom: CIJ_thom.f90 ${MODS}
	$(FC) ${FCOPTS} -o CIJ_thom ${MODS} CIJ_thom.f90

CIJ_thom_list: CIJ_thom_list.f90 ${MODS}
	$(FC) ${FCOPTS} -o CIJ_thom_list ${MODS} CIJ_thom_list.f90

.PHONY: clean

clean:
	/bin/rm -f *.o *.mod CIJ_thom
