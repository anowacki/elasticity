!===============================================================================
program EC_grid_interp_bin
!===============================================================================
!  Interpolates a grid file to reduce (increase) the node spacing.
!  Simply fills in the empty boxes with the nearest full box

use EC_grid

implicit none

type(ECgrid) :: old, new
character(len=250) :: infile,outfile,arg
integer :: dx,dy,dz
integer :: ix,iy,iz
integer,dimension(1) :: lx,ly,lz

   if (command_argument_count() /= 4 .and. command_argument_count() /= 5) then
      write(0,'(a)') 'Usage: EC_grid_interp_bin [dx] [dy] [dz] [infile] (outfile)',&
                     '     If no outfile supplied, infile is changed in place.'
      stop
   endif
   
!  Process command line options
   call get_command_argument(1,arg) ;  read(arg,*) dx
   call get_command_argument(2,arg) ;  read(arg,*) dy
   call get_command_argument(3,arg) ;  read(arg,*) dz
   call get_command_argument(4,infile)
   
!  Default to writing over the old file
   outfile = infile
   
!  If requested, write to a new file instead
   if (command_argument_count() == 5) call get_command_argument(5,outfile)
   
!  Load old grid file
   call EC_grid_load_bin(infile,old,quiet=.true.)
   
!  Check new spacing makes sense
   if (modulo(old%ix2 - old%ix1,dx) /= 0 .or. &
       modulo(old%iy2 - old%iy1,dx) /= 0 .or. &
       modulo(old%iz2 - old%iz1,dx) /= 0) then
      write(0,'(a)') 'EC_grid_interp_bin: Error: Grid file limits not divisible by new spacing.'
      stop
   endif
   
!  Make new file with same limits but new spacing
   call EC_grid_new(old%ix1,old%ix2,dx,old%iy1,old%iy2,dy,old%iz1,old%iz2,dz,new)

!  Progress bar
!   write(0,'(2a)',advance='no') '                     |',achar(13)
!   write(0,'(a)', advance='no') '|'

   
!  Fill in new grid file by nearest-neighbour search
   do iz=1,new%nz
      do iy=1,new%ny
!      write(*,'(30x,i0,a)',advance='no') iy,achar(13)
         do ix=1,new%nx
            ! Find nearest neighbour to this location
            lx = minloc(abs(old%x - new%x(ix)))
            ly = minloc(abs(old%y - new%y(iy)))
            lz = minloc(abs(old%z - new%z(iz)))

            new%ecs(ix,iy,iz,:,:) = old%ecs(lx(1),ly(1),lz(1),:,:)
         enddo
      enddo
!      if (modulo(iz,new%nz/20) == 0) write(0,'(a)',advance='no') '='
   enddo
   write(0,'(/"Writing file of about ",i0.0," MB...")') 21*8*new%npts/1024**2
   
!  Either write over the old file or a new one, depending on what we want
!  Either way, outfile contains the path to the correct file to write (over)
   call EC_grid_write_bin(outfile,new)
   
end program
!-------------------------------------------------------------------------------
