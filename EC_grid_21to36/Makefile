# Makefile to make 21to36

FC = gfortran
FCOPTS = 
PATHINC = -L/Users/nowacki/Applications/modules/lib
MODINC = -lEC_grid


EC_grid_21to36: swap2136.f90
	$(FC) -o EC_grid_21to36 ${PATHINC} ${MODINC} swap2136.f90
