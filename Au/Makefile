FC = gfortran
FCOPTS = -O2
BIN = ~nowacki/Applications/bin

default: Au EC_grid2Au.bash

install: Au EC_grid2Ay.bash
	/bin/cp Au $(BIN)/Au
	/bin/cp EC_grid2Au.bash $(BIN)/EC_grid2Au

Au: Au.o anisotropy_ajn.o
	$(FC) $(FCOPTS) -o Au Au.o anisotropy_ajn.o

Au.o: anisotropy_ajn.o

%.o: %.f90
	$(FC) $(FCOPTS) -c $*.f90

.PHONY: clean

clean:
	/bin/rm *.mod *.o