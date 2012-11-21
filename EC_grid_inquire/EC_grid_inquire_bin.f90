program inquire
!===============================================================================
!  Returns information about a binary ijxyz.bin file
!  Automatically works out which kind of file (assume-int, explicit-int or real)
!  it is, and calls the appropriate subroutine.  In future, this will be done
!  from within the subroutine itself.
!  WARNING: The only check on what sort of file it is comes from the first record
!  in the binary file.  It must be 1 or 2 to represent the kind of coordinates.
!  If it is otherwise, it is assumed to be npts.  This cannot be less than 8,
!  due to the nature of the ECgrid format, but malformed files could fool this
!  program easily
   
   use EC_grid
   
   implicit none
   
   type(ECgrid) :: grid
   type(ECgridr) :: gridr
   type(ECgridi) :: gridi
   character(len=250) :: fname
   integer :: nver
   
   if (iargc() /= 1) then
      write(0,'(a)') 'Usage: EC_grid_inquire_bin [fname]'
      stop
   endif
   
   call getarg(1,fname)
   
   open(10,file=fname,form='unformatted')
   
   write(*,'(a)')   '=================================='
   write(*,'(a,a)') 'EC_grid_inquire_bin: file ',trim(fname)
   
   ! Determine if assumed-int, int or real dimensions
   read(10) nver
   close(10)
   if (nver == 1) then
      continue
      call EC_gridi_inquire_bin(fname,gridi,quiet=.false.)
   else if (nver == 2) then
      call EC_gridr_inquire_bin(fname,gridr,quiet=.false.)
   else
      call EC_grid_inquire_bin(fname,grid,quiet=.false.)
   endif
   
end program inquire
!-------------------------------------------------------------------------------
