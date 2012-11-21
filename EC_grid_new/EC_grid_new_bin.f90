!===============================================================================
program EC_grid_new_bin
!===============================================================================
!  Creates a new, uniform grid with dimensions, spacing and uniform elastic
!  constants as desired.
   use EC_grid
   use anisotropy_ajn
   
   implicit none
   
   type(ECgrid) :: g
   real(8) :: C(6,6),rho
   character(len=250) :: arg,ecsfile,outfile
   integer :: ix1,ix2,idx,iy1,iy2,idy,iz1,iz2,idz
   integer :: i,j,k,ierr
   
!  Check command line arguments
   if (iargc() < 10 .or. iargc() > 11) then
      write(*,'(a)') &
'Usage: EC_grid_new_bin x1 x2 dx y1 y2 dy z1 z2 dz outfile (.ecs file | < 36 elastic constants)', &
'       Specify elastic constants either from .ecs file, or from stdin.'
      stop
   endif
   
!  Get command line args
   call getarg(1,arg) ;  read(arg,*) ix1
   call getarg(2,arg) ;  read(arg,*) ix2
   call getarg(3,arg) ;  read(arg,*) idx
   call getarg(4,arg) ;  read(arg,*) iy1
   call getarg(5,arg) ;  read(arg,*) iy2
   call getarg(6,arg) ;  read(arg,*) idy
   call getarg(7,arg) ;  read(arg,*) iz1
   call getarg(8,arg) ;  read(arg,*) iz2
   call getarg(9,arg) ;  read(arg,*) idz
   call getarg(10,outfile)
   
!  Get input ecs for grid.
!  If 11 arguments, the input ecs are from a .ecs file
   if (iargc() == 11) then
      call getarg(11,ecsfile)
      call CIJ_load(ecsfile,C,rho)
!  Otherwise, reading from stdin
   else
      ierr = 0
      read(*,*,iostat=ierr) ((C(i,j),j=1,6),i=1,6)
      if (ierr > 0) then
         write(0,'(a)') 'EC_grid_new_bin: Cannot read 36 ecs from stdin.'
         stop
      endif
   endif
   
!  Make grid
   call EC_grid_new(ix1,ix2,idx,iy1,iy2,idy,iz1,iz2,idz,g)
   
!  Fill it with the constants
   do k=1,g%nz
      do j=1,g%ny
         do i=1,g%nx
            g % ecs(i,j,k,:,:) = C
         enddo
      enddo
   enddo
   
!  Write it out
   call EC_grid_write_bin(outfile,g)

end program EC_grid_new_bin
!-------------------------------------------------------------------------------