FC = gfortran
FCOPTS = 
BINDIR = ~nowacki/Applications/bin
LIBDIR = ~nowacki/Applications/modules/lib
MODDIR = ~nowacki/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: CIJ_thom CIJ_thom_list

install: CIJ_thom CIJ_thom_list
	/bin/cp CIJ_thom CIJ_thom_list $(BINDIR)/

CIJ_thom: CIJ_thom.o
	$(FC) ${FCOPTS} -o CIJ_thom -L $(LIBDIR) ${LIBS} CIJ_thom.o

CIJ_thom_list: CIJ_thom_list.o
	$(FC) ${FCOPTS} -o CIJ_thom_list -L $(LIBDIR) ${LIBS} CIJ_thom_list.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f *.o *.mod CIJ_thom
