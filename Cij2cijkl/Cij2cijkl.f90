!===============================================================================
program Cij2cijkl_prog
!===============================================================================
!  Convert from 6x6 to 3x3x3x3 elasticity tensor using Voigt contraction

use anisotropy_ajn

implicit none

real(kind=8) :: Cij(6,6),cijkl(3,3,3,3),rho
integer :: iostatus,i,j,k,l
character(len=250) :: fname

if (iargc() > 1) then
   write(0,'(a)') 'Usage:  Cij2cijkl [.ecs file] > [outfile]',&
                  '   or:  Cij2cijkl < [list of 36-column ecs]'
   stop
endif

! If argument supplied, read .ecs file
if (iargc() == 1) then
   call getarg(1,fname)
   call CIJ_load(fname,Cij,rho)
   cijkl = Cij2cijkl(Cij)
   write(*,'(6e10.1)') Cij
!  Otherwuse, we're taking lists of constants from stdin.
else
   iostatus = 0
   do while (iostatus == 0)
      read(*,*,iostat=iostatus) ((Cij(i,j),j=1,6),i=1,6)
      if (iostatus < 0) exit
      if (iostatus > 0) then
         write(0,'(a)') 'Cij2cijkl: problem reading 6x6 matrix from stdin.'
         stop
      endif
      cijkl = Cij2cijkl(Cij)
      write(*,*) ((((cijkl(i,j,k,l),l=1,3),k=1,3),j=1,3),i=1,3)
   enddo
endif


end program Cij2cijkl_prog