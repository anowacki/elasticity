FC = gfortran
FCOPTS = -O3
BINDIR = ~/Applications/bin
MODS = anisotropy_ajn.o spherical_geometry.o EmatrixUtils.o

all: CIJ_plot

install: all
	/bin/cp -f CIJ_plot.bash $(BINDIR)/CIJ_plot

CIJ_plot: CIJ_plot.bash CIJ_plot_cij2phasevels

CIJ_plot_cij2phasevels: ${MODS} CIJ_plot_cij2phasevels.o
	$(FC) ${FCOPTS} -o CIJ_plot_cij2phasevels ${MODS} CIJ_plot_cij2phasevels.o

%.o: %.f90
	$(FC) ${FCOPTS} -c $*.f90


.PHONY: clean

clean:
	/bin/rm *.o *.mod CIJ_plot_cij2phasevels
