!===============================================================================
program EC_grid_bin_dump
!===============================================================================
!  Reads a binary EC_grid file and dumps the contents to stdout as ASCII

   use EC_grid
   
   implicit none
   
   type(ECgrid) :: grid
   character(len=250) :: infile
   integer :: necs = 21  ! Default to output only 21 ecs
   
!  Get command line arguments
   if (iargc() /= 1 .and. iargc() /= 2) then
      write(0,'(a)') 'Usage: EC_grid_bin_dump [ijxyz binary file] (necs 21|36)', &
                     '  Writes contents of binary EC_grid file to stdout as text.  Default 21 ecs output.'
      stop
   endif
   
!  Get number of ecs (21 or 36) if requested
   if (iargc() == 2) then
      call getarg(2,infile)
      read(infile,*) necs
      if (necs /= 21 .and. necs /= 36) then
         write(0,'(a)') 'EC_grid_dump_bin: necs must be 21 or 36'
         stop
      endif
   endif
      
!  Get input file name
   call getarg(1,infile)
   
   call EC_grid_load_bin(trim(infile),grid)
   
   call EC_grid_dump(grid,necs)
   
end program