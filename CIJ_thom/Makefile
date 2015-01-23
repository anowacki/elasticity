FC = gfortran
FCOPTS = 
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn

all: CIJ_thom CIJ_thom_list CIJ_thom_st

install: CIJ_thom CIJ_thom_list CIJ_thom_st
	/bin/cp CIJ_thom CIJ_thom_list CIJ_thom_st $(BINDIR)/

CIJ_thom: CIJ_thom.o
	$(FC) ${FCOPTS} -o CIJ_thom -L $(LIBDIR) ${LIBS} CIJ_thom.o

CIJ_thom_list: CIJ_thom_list.o
	$(FC) ${FCOPTS} -o CIJ_thom_list -L $(LIBDIR) ${LIBS} CIJ_thom_list.o

CIJ_thom_st: CIJ_thom_st.o
	$(FC) ${FCOPTS} -o CIJ_thom_st -L $(LIBDIR) ${LIBS} CIJ_thom_st.o

%.o: %.f90
	$(FC) ${FCOPTS} -c -J $(MODDIR) $*.f90

.PHONY: clean

clean:
	/bin/rm -f *.o *.mod CIJ_thom
