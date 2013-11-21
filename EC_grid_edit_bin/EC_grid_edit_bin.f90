!===============================================================================
program EC_grid_edit_bin
!===============================================================================
!  Change values in an EC_grid file.
!  Values can be supplied a number of ways:
!     (1)  For a range of grid points, a .ecs file can be given
!     (2)  For a range of grid points, one line of 36 ecs can be read from stdin
!     (3)  For a range of grid points, several lines of x y z c11 c12 c23 ... c66
!          can be read from stdin, which replace the relevant points in the old 
!          grid.
!
!  No checks are made that the grid points aren't outside the box!

use anisotropy_ajn, only: CIJ_load
use EC_grid

implicit none

type(ECgrid) :: grid
real(8) :: C(6,6), rho
character(len=250) :: arg, file, ecsfile
integer :: ix1,ix2,iy1,iy2,iz1,iz2, nx, ny, nz, lx, ly, lz
integer :: ierr, iarg, i, j, ii, ix, iy, iz
logical :: llist = .false., lecs = .false., lij = .false.

if (command_argument_count() == 0) then
   write(0,'(a)') 'EC_grid_edit_bin: Edit points of binary grid file.',&
                  'Usage: EC_grid_edit_bin (options) [file]',&
                  'Options:',&
                  '   -list',&
                  '         Reads ijxyz lines from stdin',&
                  '   -ecs [x1 x2 y1 y2 z1 z2 ecfile]',&
                  '         Replaces range of grid points with contents of .ecs file',&
                  '   -ij [x1 x2 y1 y2 z1 z2]',&
                  '         Replaces range of grid points with 36 ecs read from first line of stdin'
   stop
endif

!  Process arguments

!  -in option
   if (command_argument_count() == 2) then
      call get_command_argument(1,arg)
      if (arg(1:2) /= '-l') then
         write(*,'(2a)') 'EC_grid_edit_bin: Insufficient arguments or unrecognised option: ',trim(arg)
         stop
      endif
      call get_command_argument(2,file)
      llist = .true.
      
   elseif (command_argument_count() == 8) then   ! -ij
      call get_command_argument(1,arg)    
      if (arg(1:2) == '-i') then
         lij = .true.
         call get_command_argument(8,file)
      else
         write(0,'(2a)') 'EC_grid_edit_bin: Insufficient arguments or unrecognised option: ',trim(arg)
         stop
      endif
   
   elseif (command_argument_count() == 9) then  ! -ecs
      call get_command_argument(1,arg)    
      if (arg(1:2) == '-e') then
         lecs = .true.
         call get_command_argument(8,ecsfile)
         call get_command_argument(9,file)
      else
         write(0,'(2a)') 'EC_grid_edit_bin: Insufficient arguments or unrecognised option: ',trim(arg)
         stop
      endif
   
   else
      write(0,'(a)') 'EC_grid_edit_bin: Incorrect number of arguments'
      stop
   endif

   
!  Get range
   if (lij .or. lecs) then
      call get_command_argument(2,arg);  read(arg,*) ix1
      call get_command_argument(3,arg);  read(arg,*) ix2
      call get_command_argument(4,arg);  read(arg,*) iy1
      call get_command_argument(5,arg);  read(arg,*) iy2
      call get_command_argument(6,arg);  read(arg,*) iz1
      call get_command_argument(7,arg);  read(arg,*) iz2
!  Check range is valid.  Okay for ix1 == ix2 etc.: this refers to single cell
      if (ix1 > ix2 .or. iy1 > iy2 .or. iz1 > iz2) then
         write(0,'(a)') 'EC_grid_edit_bin: Location ranges invalid (e.g., x1 > x2).'
         stop
      endif
   endif   
   
!  Load file
   call EC_grid_load_bin(file,grid,quiet=.true.)
   
!  Check o points aren't outside the box
   if (lij .or. lecs) then
      if (ix1 < grid%ix1 .or. ix1 > grid%ix2 .or. ix2 < grid%ix1 .or. ix2 > grid%ix2 .or. &
          iy1 < grid%iy1 .or. iy1 > grid%iy2 .or. iy2 < grid%iy1 .or. iy2 > grid%iy2 .or. &
          iz1 < grid%iz1 .or. iz1 > grid%iz2 .or. iz2 < grid%iz1 .or. iz2 > grid%iz2) then
         write(0,'(a)') 'EC_grid_edit_bin: One or more replacement points is outside the grid.'
         stop
      endif
   endif
   
!  For single set of constants, get these from the relevant location and change
!  all values corresponding to the range
   if (.not.llist) then
      if (lecs) call CIJ_load(ecsfile,C,rho)
      if (lij)  read(*,*) ((C(i,j),j=1,6),i=1,6)
      nx = (ix2 - ix1)/grid%idx + 1
      ny = (iy2 - iy1)/grid%idy + 1
      nz = (iz2 - iz1)/grid%idz + 1
      do iz=1,nz
         do iy=1,ny
            do ix=1,nx
               lx = (ix1 - grid%ix1)/grid%idx + ix
               ly = (iy1 - grid%iy1)/grid%idy + iy
               lz = (iz1 - grid%iz1)/grid%idz + iz
               if (modulo((ix1 + ix*grid%idx - grid%ix1), grid%idx) /= 0 .or. &
                   modulo((iy1 + iy*grid%idy - grid%iy1), grid%idy) /= 0 .or. &
                   modulo((iz1 + iz*grid%idz - grid%iz1), grid%idz) /= 0) then
                  write(0,'(a,3(x,i0))') &
'EC_grid_edit_bin: Warning: Point is not on grid.  Changing nearest point instead: ',lx,ly,lz
               endif
               grid%ecs(lx,ly,lz,:,:) = C
            enddo
         enddo
      enddo
      
      
!  For a list, simply read in each location and change those points accordingly
   else
      ierr = 0
      do while (ierr == 0)
         read(*,*,iostat=ierr) ix,iy,iz,((C(i,j),j=1,6),i=1,6)
         if (ierr < 0) exit
         if (ierr > 0) then
            write(0,'(a)') 'EC_grid_edit_bin: problem reading x y z and 36 ecs from stdin.'
            stop
         endif
         lx = (ix - grid%ix1)/grid%idx + 1
         ly = (iy - grid%iy1)/grid%idy + 1
         lz = (iz - grid%iz1)/grid%idz + 1
         if (modulo((ix - grid%ix1), grid%idx) /= 0 .or. &
             modulo((iy - grid%iy1), grid%idy) /= 0 .or. &
             modulo((iz - grid%iz1), grid%idz) /= 0) then
            write(0,'(a,3(x,i0))') &
'EC_grid_edit_bin: Warning: Point is not on grid.  Changing nearest point instead: ',lx,ly,lz
         endif

         grid%ecs(lx,ly,lz,:,:) = C
      enddo
   endif
   
!  Write out the altered grid file
   call EC_grid_write_bin(file,grid)
   
end program EC_grid_edit_bin
!-------------------------------------------------------------------------------
