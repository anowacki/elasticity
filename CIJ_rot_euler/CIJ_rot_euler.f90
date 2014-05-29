!===============================================================================
program CIJ_rotate_euler
!===============================================================================
!  Program calling CIJ_rot_euler

   use anisotropy_ajn, only: CIJ_load, CIJ_rot_euler

   implicit none

   real(8) :: C(6,6), CR(6,6), psi1, phi, psi2, rho
   character(len=250) :: file, arg, type = 'z1x2z3'
   logical :: ecs_from_file = .false., passive = .false.
   integer :: iostatus, i, j

   call get_args

   ! Get elastic constants
   ! if reading from .ecs file, just output in same units: assumes density normalised
   if (ecs_from_file) then
      call CIJ_load(file,C,rho)
      CR = CIJ_rot_euler(C, psi1, phi, psi2, type=type, passive=passive)
      write(*,*) CR
   ! Otherwise, we're reading several constants from stdin
   else
      iostatus = 0
      do while (iostatus == 0)
         read(*,*,iostat=iostatus) ((C(i,j),j=1,6),i=1,6)
         if (iostatus < 0) exit
         if (iostatus > 0) then
            write(0,'(a)') 'CIJ_rot_euler: problem reading 36 input elastic constants from stdin.'
            stop
         endif
         CR = CIJ_rot_euler(C, psi1, phi, psi2, type=type, passive=passive)
         write(*,*) CR
      enddo
   endif

contains
   subroutine get_args()
      integer :: iarg, narg
      narg = command_argument_count()      
      if (narg < 3) call usage
      iarg = 1
      do while (iarg <= narg - 3)
         call get_command_argument(iarg, arg)
         select case(arg)
            case('-f')
               ecs_from_file = .true.
               call get_command_argument(iarg+1, file)
               iarg = iarg + 2
            case('-p')
               passive = .true.
               iarg = iarg + 1
            case('-t')
               call get_command_argument(iarg+1, type)
               iarg = iarg + 2
            case default
               write(0,'(a)') 'CIJ_rotate_euler: Error: unrecognised option "'//trim(arg)//'"'
               stop
         end select
      enddo
      if (narg - iarg /= 2) call usage
      call get_command_argument(narg-2, arg)
      read(arg,*,iostat=iostatus) psi1
      if (iostatus /= 0) then
         write(0,'(a)') 'CIJ_rot_euler: Error: Problem getting psi1 from command line'
         stop
      endif
      call get_command_argument(narg-1, arg)
      read(arg,*,iostat=iostatus) phi
      if (iostatus /= 0) then
         write(0,'(a)') 'CIJ_rot_euler: Error: Problem getting phi from command line'
         stop
      endif
      call get_command_argument(narg, arg)
      read(arg,*,iostat=iostatus) psi2
      if (iostatus /= 0) then
         write(0,'(a)') 'CIJ_rot_euler: Error: Problem getting psi2 from command line'
         stop
      endif
   end subroutine get_args

   subroutine usage()
      write(0,'(a)') &
         'Usage: CIJ_rot_euler (options) [psi1] [phi] [psi2]', &
         '  Rotations are applied anticlockwise about z1,x2,z3 axes looking down axis.',&
         '  ECs are read from stdin, 36 constants per line, unless the -f option is used.', &
         'Options:', &
         '   -f [file]  : Read ECs from .ecs file [stdin]', &
         '   -p         : Apply passive rotation', &
         '   -t [type]  : Apply rotation in different convention.  Type must be a six-character', &
         '                combination of axes.  The default is z1x2z3, corresponding to rotation', &
         '                first about the original z axis, then the new x axis, then the new z', &
         '                z axis.'
      stop   
   end subroutine usage      
end program CIJ_rotate_euler
!-------------------------------------------------------------------------------
