program inquire
!===============================================================================
!  Program front end to the function EC_grid_inquire in the module EC_grid
!  Returns information about an ijxyz grid file.

   use EC_grid
   
   type(ECgrid) :: grid
   character(len=250) :: fname
   
   if (iargc() /= 1) then
      write(0,'(a)') 'Usage: EC_grid_inquire [fname]'
      stop
   endif
   
   call getarg(1,fname)
   
   write(*,'(a)')   '=================================='
   write(*,'(a,a)') 'EC_grid_inquire: file ',trim(fname)
   call EC_grid_inquire(fname,grid,quiet=.false.)
   
end program inquire
!-------------------------------------------------------------------------------