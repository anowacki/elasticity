program inquire
!===============================================================================
!  Returns information about a binary ijxyz.bin file
   
   use EC_grid
   
   implicit none
   
   type(ECgrid) :: grid
   character(len=250) :: fname
   
   if (iargc() /= 1) then
      write(0,'(a)') 'Usage: EC_grid_inquire_bin [fname]'
      stop
   endif
   
   call getarg(1,fname)
   
   write(*,'(a)')   '=================================='
   write(*,'(a,a)') 'EC_grid_inquire_bin: file ',trim(fname)
   call EC_grid_inquire_bin(fname,grid,quiet=.false.)
   
end program inquire
!-------------------------------------------------------------------------------
