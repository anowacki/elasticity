# Makefile to make 21to36

FC = gfortran
FCOPTS = 
PATHINC = -L/Users/nowacki/Applications/modules/lib
MODINC = -lEC_grid
M = ~/Applications/modules/mods
BINDIR = ~nowacki/Applications/bin

install: EC_grid_21to36
	cp -f EC_grid_21to36 $(BINDIR)/

EC_grid_21to36: swap2136.f90
	$(FC) -o EC_grid_21to36 -J $(M) ${PATHINC} ${MODINC} swap2136.f90

.PHONY: clean

clean:
	/bin/rm -f EC_grid_21to36 *.mod *.o
