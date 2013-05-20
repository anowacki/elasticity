FC = gfortran
FCOPTS = -O3
BINDIR = ~/Applications/bin
ANISOMOD = ~nowacki/Applications/modules/anisotropy_ajn/anisotropy_ajn.f90

all: CIJ_Hudson

install: CIJ_Hudson
	/bin/cp -f CIJ_Hudson $(BINDIR)/CIJ_Hudson

CIJ_Hudson: $(ANISOMOD) CIJ_Hudson.f90
	$(FC) ${FCOPTS} -o CIJ_Hudson -J$(CURDIR) $(ANISOMOD) CIJ_Hudson.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_Hudson *.o *.mod
