!===============================================================================
program CIJ_Hudson_prog
!===============================================================================
!  Wrapper script for the CIJ_hudson subroutine.
!  Calculate effective elastic constants for isotropic matrix with isotropic
!  ellipsoidal inclusions
!
!  Usage:  CIJ_Hudson vp vs rho a phi vpi vsi rhoi
!     or
!          CIJ_Hudson < [list of vp vs rho a phi vpi vsi rhoi]

   use anisotropy_ajn
   implicit none
   
   real(8) :: vp,vs,rho,a,phi,vpi,vsi,rhoi
   real(8) :: C(6,6),rho_eff
   character(len=80) :: arg
   integer :: i,j,iostatus
   
   if (iargc() /= 0 .and. iargc() /= 8) then
      write(0,'(a)') 'Usage:  CIJ_Hudson vp vs rho a phi vpi vsi rhoi', &
                     '        or', &
                     '        CIJ_Hudson < [list of vp vs rho a phi vpi vsi rhoi]',&
                     'Inputs: vp,vs,rho:    matrix isotropic parameters',&
                     '        vpi,vsi,rhoi: inclusion  "         "',&
                     '        a:            aspect ratio of inclusions',&
                     '        phi:          volume fraction of inclusions',&
                     '        Theory valid where phi > 0.4*a.',&
                     '        Writes 36 ecs and rho to stdout.'
      stop
   endif
   
!  Called in one-shot mode
   if (iargc() == 8) then
      !  Get arguments
      call getarg(1,arg);  read(arg,*) vp
      call getarg(2,arg);  read(arg,*) vs
      call getarg(3,arg);  read(arg,*) rho
      call getarg(4,arg);  read(arg,*) a
      call getarg(5,arg);  read(arg,*) phi
      call getarg(6,arg);  read(arg,*) vpi
      call getarg(7,arg);  read(arg,*) vsi
      call getarg(8,arg);  read(arg,*) rhoi
      
      !  Calculate effective elasticity tensor and write out
      call CIJ_hudson(vp,vs,rho,a,phi,vpi,vsi,rhoi,C,rho_eff)
      write(*,*) ((C(i,j),j=1,6),i=1,6),rho_eff
      
!  Taking a list of parameters from stdin
   else
      iostatus = 0
      do while (iostatus == 0)
         read(*,*,iostat=iostatus) vp,vs,rho,a,phi,vpi,vsi,rhoi
         if (iostatus < 0) exit  ! EOF
         if (iostatus > 0) then
            write(0,'(a)') 'CIJ_Hudson: Problem reading parameters from stdin.'
            stop
         endif
         call CIJ_hudson(vp,vs,rho,a,phi,vpi,vsi,rhoi,C,rho_eff)
         write(*,*) ((C(i,j),j=1,6),i=1,6),rho_eff
      enddo
   endif

end program
!-------------------------------------------------------------------------------
