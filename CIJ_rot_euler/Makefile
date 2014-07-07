# Makefile for CIJ_rot_euler
FC = gfortran
FCOPTS = -O3
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn

default: all

all: CIJ_rot_euler

install: CIJ_rot_euler
	/bin/cp CIJ_rot_euler $(BINDIR)/

CIJ_rot_euler: CIJ_rot_euler.o
	$(FC) ${FCOPTS} -o CIJ_rot_euler -L $(LIBDIR) ${LIBS} CIJ_rot_euler.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f CIJ_rot_euler *.o *.mod
