program EC_rotate_xyz
!  Rotate all ECs in an input .xyz EC file.
!  Number of ECs is determined by inspection, rather than stated on command line.
!  a, b and g are angles about x1, x2, x3 as stated in anisotropy_ajn: CIJ_rot3

use constants
use anisotropy_ajn
use EC_grid

type(ECgrid)       :: grid
real(rs)           :: C(6,6),Ctemp(6,6),a,b,g
character(len=250) :: fname
integer            :: kx,ky,kz

!  Process command line options
if (iargc() /= 4) then
   write(0,*) 'Usage: EC_rot3 [alpha] [beta] [gamma] [.xyz file] > [output file]'
   stop
endif

call getarg(1,fname); read(fname,*) a
call getarg(2,fname); read(fname,*) b
call getarg(3,fname); read(fname,*) g

call getarg(4,fname)

!  Work out how many elastic constants we're dealing with
necs = EC_grid_check_necs(fname)

!  Read in ecs
call EC_grid_load(fname,grid,necs=necs,quiet=.true.)

!  Rotate ecs
do k1 = 1, grid % nx
   do k2 = 1, grid % ny
      do k3 = 1, grid % nz
         call CIJ_rot3(grid%ecs(k1,k2,k3,:,:),a,b,g,Ctemp)
         grid%ecs(k1,k2,k3,:,:) = Ctemp
      enddo
   enddo
enddo

!  Write ecs out to stdout
call EC_grid_dump(grid,necs=21)


end program EC_rotate_xyz