!===============================================================================
program CIJ_Hudson_prog
!===============================================================================
!  Wrapper script for the CIJ_global_VTI function
!  Calculates elastic constants given the radial anisotorpy parameters as used
!  frequently in global seismology.

   use anisotropy_ajn
   implicit none
   
   real(8) :: vp,vs,rho,xi,phi,eta
   real(8) :: C(6,6)
   character(len=80) :: arg
   integer :: i,j,iostatus
   
   if (iargc() /= 0 .and. iargc() /= 6) then
      write(0,'(a)') 'Usage:  CIJ_global_VTI vp vs rho xi phi eta', &
                     '        or', &
                     '        CIJ_global_VTI < [list of vp vs rho xi phi eta]',&
                     'Inputs: vp,vs: Voigt isotropic average velocities (m/s)',&
                     '        rho:   Density (kg/m^3)',&
                     '        xi,phi,eta: Dimensionless radial anisotropy parameters',&
                     'Output: 36 elastic constants, normalised by density'
      stop
   endif
   
!  Called in one-shot mode
   if (iargc() == 6) then
      !  Get arguments
      call getarg(1,arg);  read(arg,*) vp
      call getarg(2,arg);  read(arg,*) vs
      call getarg(3,arg);  read(arg,*) rho
      call getarg(4,arg);  read(arg,*) xi
      call getarg(5,arg);  read(arg,*) phi
      call getarg(6,arg);  read(arg,*) eta
      
      !  Calculate effective elasticity tensor and write out
      C = CIJ_global_VTI(vp,vs,rho,xi,phi,eta)
      write(*,*) ((C(i,j)/rho,j=1,6),i=1,6)
      
!  Taking a list of parameters from stdin
   else
      iostatus = 0
      do while (iostatus == 0)
         read(*,*,iostat=iostatus) vp,vs,rho,xi,phi,eta
         if (iostatus < 0) exit  ! EOF
         if (iostatus > 0) then
            write(0,'(a)') 'CIJ_global_VTI: Problem reading parameters from stdin.'
            stop
         endif
         C = CIJ_global_VTI(vp,vs,rho,xi,phi,eta)
         write(*,*) ((C(i,j)/rho,j=1,6),i=1,6)
      enddo
   endif

end program
!-------------------------------------------------------------------------------
