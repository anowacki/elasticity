FC = gfortran
FCOPTS = -O3
BINDIR = ~/Applications/bin
ANISOMOD = ~nowacki/Applications/modules/anisotropy_ajn/anisotropy_ajn.f90

all: CIJ_global_VTI

install: CIJ_global_VTI
	/bin/cp -f CIJ_global_VTI $(BINDIR)/CIJ_global_VTI

CIJ_global_VTI: $(ANISOMOD) CIJ_global_VTI.f90
	$(FC) ${FCOPTS} -o CIJ_global_VTI -J$(CURDIR) $(ANISOMOD) CIJ_global_VTI.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_global_VTI *.o *.mod
