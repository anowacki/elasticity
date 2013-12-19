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
   if (command_argument_count() < 10 .or. command_argument_count() > 11) then
      write(*,'(a)') &
'Usage: EC_grid_new_bin x1 x2 dx y1 y2 dy z1 z2 dz outfile (.ecs file | < 36 elastic constants)', &
'       Specify elastic constants either from .ecs file, or from stdin.'
      stop
   endif
   
!  Get command line args
   call get_command_argument(1,arg) ;  read(arg,*) ix1
   call get_command_argument(2,arg) ;  read(arg,*) ix2
   call get_command_argument(3,arg) ;  read(arg,*) idx
   call get_command_argument(4,arg) ;  read(arg,*) iy1
   call get_command_argument(5,arg) ;  read(arg,*) iy2
   call get_command_argument(6,arg) ;  read(arg,*) idy
   call get_command_argument(7,arg) ;  read(arg,*) iz1
   call get_command_argument(8,arg) ;  read(arg,*) iz2
   call get_command_argument(9,arg) ;  read(arg,*) idz
   call get_command_argument(10,outfile)
   
!  Get input ecs for grid.
!  If 11 arguments, the input ecs are from a .ecs file
   if (command_argument_count() == 11) then
      call get_command_argument(11,ecsfile)
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
