# Makefile for CIJ_rot3
FC = gfortran
FCOPTS = -O3
BINDIR = ~nowacki/Applications/bin
LIBDIR = ~nowacki/Applications/modules/lib
MODDIR = ~nowacki/Applications/modules/mods
LIBS = -lanisotropy_ajn

default: all

all: CIJ_rot3

install: CIJ_rot3
	/bin/cp CIJ_rot3 $(BINDIR)/

CIJ_rot3: CIJ_rot3.o
	$(FC) ${FCOPTS} -o CIJ_rot3 -L $(LIBDIR) ${LIBS} CIJ_rot3.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_rot3 *.o *.mod
