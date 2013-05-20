# Makefile for all elasticity programs

# Directories containing Makefiles
DIRS = Au \
       CIJ_21to36 \
	   CIJ_36to21 \
       CIJ_disp \
       CIJ_global_VTI \
	   CIJ_iso \
	   CIJ_iso_av \
	   CIJ_phasevels \
	   CIJ_plot/src \
	   CIJ_rot3 \
	   CIJ_scale_to_iso \
	   CIJ_thom \
	   Cij2cijkl \
	   EC_grid_21to36 \
	   EC_grid_bin_dump \
	   EC_grid_conv \
	   EC_grid_edit_bin \
	   EC_grid_inquire \
	   EC_grid_interp \
	   EC_grid_new \
	   EC_grid_normalise_bin/src \
	   EC_grid_plot_bin \
	   EC_rot3 \
	   GPa2Pa \
	   cijkl2Cij \
	   ij2ecs 

all:
	(for d in ${DIRS}; do \
        echo "=== Making in directory $$d ==="; \
        $(MAKE) -C $$d install; \
		echo; \
     done)

allclean:
	(for d in ${DIRS}; do \
        echo "=== Making clean in directory $$d ==="; \
        $(MAKE) -C $$d clean; \
        echo; \
     done)
	