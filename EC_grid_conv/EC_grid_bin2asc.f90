!===============================================================================
program EC_grid_bin2asc
!===============================================================================
!  Convert an ASCII EC_grid file to a binary one.  Reads name as first argument
!  or provide a list on stdin.  Adds .bin to end of file name.

   use EC_grid
   
   implicit none
   
   character(len=250) :: infile,outfile
   type(ECgrid) :: grid
   integer,parameter :: necs=21
   logical :: quiet=.false.
   
!  Command line parameters
   if (command_argument_count() /= 1 .and. command_argument_count() /= 2 .and. command_argument_count() /= 3) then
      write(0,'(a)') 'Usage: EC_grid_bin2asc (-quiet) [infile] (outfile)',&
                     '       if outfile == ''-'', ECs are sent to stdout'
      stop
   endif
   
   call get_command_argument(1,infile)
   if (infile(1:2) == '-q') then
      quiet = .true.
      call get_command_argument(2,infile)
   endif
   
   if (quiet .and. command_argument_count() == 3) then   ! Have specified -q, infile and outfile
      call get_command_argument(3,outfile)
   else if (.not.quiet .and. command_argument_count() == 2) then  !  Have specified infile and outfile
      call get_command_argument(2,outfile)
   else                                 ! Haven't specified outfile
      outfile = trim(infile) // '.asc'  ! Add .asc extension if no outfile specified
   endif
   
!  Load ecs into memory
   if (.not.quiet) call EC_grid_inquire_bin(infile,grid,quiet=quiet)
   call EC_grid_load_bin(infile,grid)
   
!  Write ASCII grid file to stdout or to file
   if (trim(infile) == '-') then
      call EC_grid_dump(grid,necs=necs)
   else
      call EC_grid_write(outfile,grid,necs=necs)
   endif
   
end program EC_grid_bin2asc
