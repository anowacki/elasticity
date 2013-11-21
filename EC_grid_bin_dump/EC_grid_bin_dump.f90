!===============================================================================
program EC_grid_bin_dump
!===============================================================================
!  Reads a binary EC_grid file and dumps the contents to stdout as ASCII

   use EC_grid
   
   implicit none
   
   type(ECgrid) :: grid ! Assumed-integer coordinates
   type(ECgridi) :: gridi ! Explicit-integer coordinates
   type(ECgridr) :: gridr ! Explicit-real coordinates
   character(len=250) :: infile
   integer :: necs = 21  ! Default to output only 21 ecs
   
!  Get command line arguments
   if (command_argument_count() /= 1 .and. command_argument_count() /= 2) then
      write(0,'(a)') 'Usage: EC_grid_bin_dump [ijxyz binary file] (necs 21|36)', &
                     '  Writes contents of binary EC_grid file to stdout as text.  Default 21 ecs output.'
      stop
   endif
   
!  Get number of ecs (21 or 36) if requested
   if (command_argument_count() == 2) then
      call get_command_argument(2,infile)
      read(infile,*) necs
      if (necs /= 21 .and. necs /= 36) then
         write(0,'(a)') 'EC_grid_dump_bin: necs must be 21 or 36'
         stop
      endif
   endif
      
!  Get input file name
   call get_command_argument(1,infile)
   
!  Check what type of file it is
   call EC_grid_dump_file_bin(infile,necs)
   
end program
