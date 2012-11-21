!===============================================================================
program CIJ_rotate_3
!===============================================================================
!  Program calling CIJ_rot3

   use anisotropy_ajn
   
   real(8) :: C(6,6), CR(6,6), a,b,g,rho
   character(len=250) :: file,arg
   integer :: iostatus,i,j
   
!  Check input arguments
   if (iargc() < 3 .or. iargc() > 4) then
      write(0,'(a)') 'Usage: CIJ_rot3 [alpha] [beta] [gamma] (ecfile)', &
                     '  Rotations are applied in order, clockwise about a,b,c axes looking down axis.',&
                     '  If no .ecs file specified, then ECs are read from stdin, 36 constants per line.'
      stop
   endif
   
!  Get input arguments
   call getarg(1,arg) ;  read(arg,*) a
   call getarg(2,arg) ;  read(arg,*) b
   call getarg(3,arg) ;  read(arg,*) g
   
!  Get elastic constants
!  if reading from .ecs file, just output in same units: assumes density normalised
   if (iargc() == 4) then
      call getarg(4,file)
      call CIJ_load(file,C,rho)
      call CIJ_rot3(C,a,b,g,CR)
      write(*,*) CR
!  Otherwise, we're reading several constants from stdin
   else
      iostatus = 0
      do while (iostatus == 0)
         read(*,*,iostat=iostatus) ((C(i,j),j=1,6),i=1,6)
         if (iostatus < 0) exit
         if (iostatus > 0) then
            write(0,'(a)') 'CIJ_rot3: problem reading 36 input elastic constants from stdin.'
            stop
         endif
         call CIJ_rot3(C,a,b,g,CR)
         write(*,*) CR
      enddo
   endif

end program CIJ_rotate_3
!-------------------------------------------------------------------------------