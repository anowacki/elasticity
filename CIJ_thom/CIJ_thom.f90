!===============================================================================
program thompson_parameter
!===============================================================================
!  Program form of the CIJ_thom routine in anisotropy_ajn module

   use anisotropy_ajn
   
   implicit none
   
   real(8) :: ecs(6,6)
   real(8) :: vp,vs,rho,del,eps,gam
   integer :: i
   character(len=250) :: arg
   
   if (iargc() /= 6) then
      write(0,'(a)') 'Usage:  CIJ_thom [vp] [vs] [rho] [delta] [epsilon] [gamma]',&
                     '  Rotationally symmetric about 3-axis (vertical)'
      write(0,'(a)') '  Sends 36 elastic constants to stdout (density-normalised).'
      stop
   endif
   
   call getarg(1,arg) ;  read(arg,*) vp
   call getarg(2,arg) ;  read(arg,*) vs
   call getarg(3,arg) ;  read(arg,*) rho
   call getarg(4,arg) ;  read(arg,*) del
   call getarg(5,arg) ;  read(arg,*) eps
   call getarg(6,arg) ;  read(arg,*) gam
   
   ecs = CIJ_thom(vp,vs,rho,eps,gam,del)
   
   write(*,*) ecs/rho
   
end program thompson_parameter
!-------------------------------------------------------------------------------