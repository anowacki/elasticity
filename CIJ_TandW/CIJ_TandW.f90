!===============================================================================
program CIJ_TandW
!===============================================================================
!  Programmatic interface to the CIJ_tandon_and_weng subroutine available in the
!  anisotropy_ajn module

use anisotropy_ajn

implicit none

character(len=80) :: arg
integer,parameter :: rs = 8
real(rs) :: vp,vs,rho,del,c,vpi,vsi,rhoi,CTaW(6,6),rhoTaW
integer :: iostatus

!  Check number of arguments
   if (iargc() /= 8 .and. iargc() /= 0) then
      write(0,'(a)') 'Usage: CIJ_TandW',&
       '   Create elastic constants for aligned ellipsoidal inclusions using the theory of Tandon and Weng (1984)',&
       ' Input:',&
       '   Accepts as command line arguments, or values read from stdin:',&
       '   [vp] [vs] [rho] [del] [c] [vpi] [vsi] [rhoi]',&
       '   vp,vs,rho : matrix velocities and density in m/s and kg/m^3',&
       '   vpi,vsi,rhoi : properties of inclusions',&
       '   del : aspect ratio of spheroidal inclusions (<1=oblate, >1=prolate)',&
       '   c : volume fraction of inclusions.',&
       ' Output: 36 ecs (density-normalised) and density.'
      stop
   endif
   
!  Supplied input on command line
   if (iargc() == 8) then
      call getarg(1,arg); read(arg,*) vp
      call getarg(2,arg); read(arg,*) vs
      call getarg(3,arg); read(arg,*) rho
      call getarg(4,arg); read(arg,*) del
      call getarg(5,arg); read(arg,*) c
      call getarg(6,arg); read(arg,*) vpi
      call getarg(7,arg); read(arg,*) vsi
      call getarg(8,arg); read(arg,*) rhoi

!  CIJ_tandon_and_weng supplies ecs density-normalised!
      call CIJ_tandon_and_weng(vp,vs,rho,del,c,vpi,vsi,rhoi,CTaW,rhoTaW)
      
      write(*,*) CTaW,rhoTaW
      
      stop
      
!  Reading multiple inputs on stdin
   else
      iostatus = 0
      do while (iostatus == 0)
         read(*,*,iostat=iostatus) vp,vs,rho,del,c,vpi,vsi,rhoi
         if (iostatus < 0) exit
         if (iostatus > 0) then
            write(0,'(a)') 'CIJ_TandW: Error: problem reading values from stdin.'
            stop
         endif
         call CIJ_tandon_and_weng(vp,vs,rho,del,c,vpi,vsi,rhoi,CTaW,rhoTaW)
         write(*,*) CTaW,rhoTaW
      enddo
   endif
   
end program CIJ_TandW