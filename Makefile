# Makefile for all elasticity programs

# Global directories for .mod files and libraries used in these programs
MODDIR = ~/Applications/modules/mods
LIBDIR = ~/Applications/modules/lib

# Global installation directory
BINDIR = ~/Applications/bin

# Directories containing Makefiles
DIRS = Au \
       CIJ_21to36 \
       CIJ_36to21 \
       CIJ_BandS_axes \
       CIJ_Hudson \
       CIJ_Reuss \
       CIJ_TandW \
       CIJ_VRH \
       CIJ_Voigt \
       CIJ_axial_average \
       CIJ_disp \
       CIJ_global_VTI \
       CIJ_iso \
       CIJ_iso_av \
       CIJ_phasevels \
       CIJ_plot \
       CIJ_rot3 \
       CIJ_rot_euler \
       CIJ_scale_to_iso \
       CIJ_stable \
       CIJ_thom \
       Cij2cijkl \
       EC_grid_21to36 \
       EC_grid_bin_dump \
       EC_grid_conv \
       EC_grid_edit_bin \
       EC_grid_inquire \
       EC_grid_interp \
       EC_grid_new \
       EC_grid_normalise_bin \
       EC_grid_plot_bin \
       EC_rot3 \
       GPa2Pa \
       cijkl2Cij \
       ecs2ij \
       enter-ecs \
       ij2ecs \
       ijxyz2ij

all:
	(for d in ${DIRS}; do \
        echo "=== Making in directory $$d ==="; \
        $(MAKE) -C $$d install MODDIR=$(MODDIR) LIBDIR=$(LIBDIR) BINDIR=$(BINDIR); \
		echo; \
     done)

allclean:
	(for d in ${DIRS}; do \
        echo "=== Making clean in directory $$d ==="; \
        $(MAKE) -C $$d clean; \
        echo; \
     done)

