program EC_rotate
!  Rotate an input .ecs file

use constants
use anisotropy_ajn

real(rs)  :: C(6,6),rho,Ctemp(6,6),a,b,g
character(len=250) :: fname

if (command_argument_count() /= 4) then
   write(0,*) 'Usage: EC_rot3 [alpha] [beta] [gamma] [.ecs file] > [output file]'
   stop
endif

call get_command_argument(1,fname); read(fname,*) a
call get_command_argument(2,fname); read(fname,*) b
call get_command_argument(3,fname); read(fname,*) g

call get_command_argument(4,fname)

call CIJ_load(fname,C,rho)

call CIJ_rot3(C,a,b,g,Ctemp)

do i=1,6
   do j=i,6
      write(*,'(2i2,1x,d24.16)') i,j,Ctemp(i,j)
   enddo
enddo
write(*,'(2i2,1x,d24.16)') 7,7,rho

end program EC_rotate
