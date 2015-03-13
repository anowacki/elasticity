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

   real(8) :: vp,vs,rho,a,phi,vpi,vsi,rhoi,e
   real(8) :: C(6,6),rho_eff
   character(len=80) :: arg
   integer :: i,j,iostatus
   logical :: read_stdin = .false., use_e = .false.
   real(8), parameter :: pi = 4._8*atan2(1._8, 1._8)

   ! Determine run options
   call get_args


   ! Called in one-shot mode
   if (.not.read_stdin) then
      if (use_e) call e2a_phi ! Get a and phi from crack density
      call CIJ_hudson(vp,vs,rho,a,phi,vpi,vsi,rhoi,C,rho_eff)
      call write_C
   ! Taking a list of parameters from stdin
   else
      iostatus = 0
      do while (iostatus == 0)
         if (use_e) then
            read(*,*,iostat=iostatus) vp,vs,rho,e,vpi,vsi,rhoi
            call e2a_phi
         else
            read(*,*,iostat=iostatus) vp,vs,rho,a,phi,vpi,vsi,rhoi
         endif
         if (iostatus < 0) exit  ! EOF
         if (iostatus > 0) then
            write(0,'(a)') 'CIJ_Hudson: Problem reading parameters from stdin.'
            stop
         endif
         call CIJ_hudson(vp,vs,rho,a,phi,vpi,vsi,rhoi,C,rho_eff)
         call write_C
      enddo
   endif

contains

   subroutine usage
      write(0,'(a)') 'Usage:  CIJ_Hudson vp vs rho a phi vpi vsi rhoi', &
                     '        CIJ_Hudson vp vs rho e vpi vsi rhoi', &
                     '        CIJ_Hudson < [list of vp vs rho a phi vpi vsi rhoi]',&
                     '        CIJ_Hudson -e < [list of vp vs rho e vpi vsi rhoi]',&
                     'Inputs: vp,vs,rho:    matrix isotropic parameters',&
                     '        vpi,vsi,rhoi: inclusion  "         "',&
                     '    AND:',&
                     '        a:            aspect ratio of inclusions',&
                     '        phi:          volume fraction of inclusions',&
                     '    OR:',&
                     '        e:            crack number density',&
                     '        Theory valid where phi > 0.4*a OR e < 0.1.',&
                     '        Writes 36 ecs and rho to stdout.'
      stop
   end subroutine usage

   subroutine get_args
     integer :: narg
     narg = command_argument_count()

     select case (narg)
        case (0)
           read_stdin = .true.
        case (1)
           call get_command_argument(1, arg)
           if (arg /= '-e') call usage
           read_stdin = .true.
           use_e = .true.
        case (7)
           use_e = .true.
           call get_command_argument(1,arg);  read(arg,*) vp
           call get_command_argument(2,arg);  read(arg,*) vs
           call get_command_argument(3,arg);  read(arg,*) rho
           call get_command_argument(4,arg);  read(arg,*) e
           call get_command_argument(5,arg);  read(arg,*) vpi
           call get_command_argument(6,arg);  read(arg,*) vsi
           call get_command_argument(7,arg);  read(arg,*) rhoi
        case (8)
           call get_command_argument(1,arg);  read(arg,*) vp
           call get_command_argument(2,arg);  read(arg,*) vs
           call get_command_argument(3,arg);  read(arg,*) rho
           call get_command_argument(4,arg);  read(arg,*) a
           call get_command_argument(5,arg);  read(arg,*) phi
           call get_command_argument(6,arg);  read(arg,*) vpi
           call get_command_argument(7,arg);  read(arg,*) vsi
           call get_command_argument(8,arg);  read(arg,*) rhoi
        case default
           call usage
     end select
   end subroutine get_args

   subroutine write_C
      write(*,*) ((C(i,j),j=1,6),i=1,6),rho_eff
   end subroutine write_C

   subroutine e2a_phi
      a = 0.01_8
      phi = 4._8*pi*a*e/3._8
   end subroutine
end program
!-------------------------------------------------------------------------------
