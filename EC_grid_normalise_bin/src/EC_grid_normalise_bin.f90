!===============================================================================
program EC_grid_normalise_bin
!===============================================================================
! Multiply every cell within an EC_grid binary file by a constant value.
! This might be useful for converting between dennsity-normalised (Aij) and full
! elasticity (Cij) grid.
! 
! Choose whether to overwrite the file or write the changed version elswhere.
! 
! Andy Nowacki, University of Bristol
! andy.nowacki@bristol.ac.uk
!------------------------------------------------------------------------------- 

   use EC_grid
   
   implicit none
   
   ! Assumed-int, explicit-int and explicit-real grids
   type(ECgrid) :: grid
   type(ECgridi) :: gridi
   type(ECgridr) :: gridr
   character(len=250) :: arg,infile,outfile
   real(kind(1.d0)) :: multiplier
   ! Flag to describe type of infile
   integer :: nver
   
   ! Check arguments
   if (iargc() /= 2 .and. iargc() /= 3) then
      write(0,'(a)') 'Usage: EC_grid_normalise_bin [multiplier] [infile] (outfile)', &
                     '   Multiplies every point in infile by a constant value.', &
                     '   If outfile not supplied, infile is overwritten.'
      stop
   endif
   
   ! Get arguments
   call getarg(1,arg);  read(arg,*) multiplier
   call getarg(2,infile)
   ! If we've specified a different outfile, read that in; otherwise use infile
   if (iargc() == 3) then
      call getarg(3,outfile)
   else
      outfile = infile
   endif
   
   ! Check type of infile
   call EC_grid_check_type_bin(infile, nver, quiet=.true.)
   
   ! Read in grid in whichever format it's in and multiply all values, then write out
   ! and deallocate memory
   if (nver == EC_grid_nver_assumed_i) then
      call EC_grid_load_bin(infile, grid, quiet=.true.)
      grid%ecs = grid%ecs * multiplier
      call EC_grid_write_bin(outfile, grid)
      call EC_grid_delete(grid)
      
   else if (nver == EC_grid_nver_i) then
      call EC_gridi_load_bin(infile, gridi, quiet=.true.)
      gridi%ecs = gridi%ecs * multiplier
      call EC_gridi_write_bin(outfile, gridi)
      call EC_gridi_delete(gridi)

   else if (nver == EC_grid_nver_r) then
      call EC_gridr_load_bin(infile, gridr, quiet=.true.)
      gridr%ecs = gridr%ecs * multiplier
      call EC_gridr_write_bin(outfile, gridr)
      call EC_gridr_delete(gridr)
      
   endif
   
end program EC_grid_normalise_bin

   
