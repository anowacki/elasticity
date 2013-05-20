# Makefile for CIJ_rot3
FC = gfortran
FCOPTS = -O3

BINDIR = ~nowacki/Applications/bin

default: all

all: CIJ_rot3

install: CIJ_rot3
	/bin/cp -f CIJ_rot3 $(BINDIR)/

CIJ_rot3: anisotropy_ajn.o CIJ_rot3.o
	$(FC) ${FCOPTS} -o CIJ_rot3 anisotropy_ajn.o CIJ_rot3.o

%.o: %.f90
	$(FC) ${FCOPTS} -c $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_rot3 *.o *.mod
