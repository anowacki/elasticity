!===============================================================================
program cijkl2Cij_prog
!===============================================================================
!  Reads 3x3x3x3 cijkl from stdin and writes 6x6 Cij to stdout

   use anisotropy_ajn
   
   implicit none
   
   real(8) :: cijkl(3,3,3,3), Cij(6,6)
   integer :: iostatus,i,j,k,l
   
   if (command_argument_count() /= 0) then
      write(0,'(a)') 'Usage: cijkl2Cij < [list of 3x3x3x3 elastic constants]'
      stop
   endif
   
   iostatus = 0
   do while (iostatus == 0)
      read(*,*,iostat=iostatus) ((((cijkl(i,j,k,l),l=1,3),k=1,3),j=1,3),i=1,3)
      if (iostatus < 0) exit
      if (iostatus > 0) then
         write(0,'(a)') 'cijkl2Cij: problem reading 3x3x3x3 tensor from stdin.'
         stop
      endif
      Cij = cijkl2Cij(cijkl)
      write(*,*) ((Cij(i,j),j=1,6),i=1,6)
   enddo

end program cijkl2Cij_prog
