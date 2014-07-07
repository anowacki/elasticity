FC = gfortran
FCOPTS = -O3
BINDIR = ~/Applications/bin
LIBDIR = ~/Applications/modules/lib
MODDIR = ~/Applications/modules/mods
LIBS = -lanisotropy_ajn -lspherical_geometry -lEmatrixUtils
MODS = anisotropy_ajn.o spherical_geometry.o EmatrixUtils.o

all: CIJ_plot

install: all
	/bin/cp CIJ_plot.bash $(BINDIR)/CIJ_plot
	/bin/cp CIJ_sphere.bash $(BINDIR)/CIJ_sphere
	/bin/cp CIJ_plot_cij2phasevels $(BINDIR)

CIJ_plot: CIJ_plot.bash CIJ_plot_cij2phasevels

CIJ_sphere: CIJ_sphere.bash CIJ_plot_cij2phasevels

CIJ_plot_cij2phasevels: CIJ_plot_cij2phasevels.o
	$(FC) ${FCOPTS} -o CIJ_plot_cij2phasevels -L $(LIBDIR) ${LIBS} CIJ_plot_cij2phasevels.o

%.o: %.f90
	$(FC) ${FCOPTS} -J $(MODDIR) -c $*.f90

.PHONY: clean

clean:
	/bin/rm -f *.o *.mod CIJ_plot_cij2phasevels
