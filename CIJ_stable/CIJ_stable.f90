!===============================================================================
program test
!===============================================================================
!  Test that (a) set(s) of elastic constants are dynamically stable; i.e., they
!  are represented by a real, symmetrical, positive definite Voigt matrix.
!  Either read ECs from a .ecs file, or take sets of ECs from stdin.
!  When stable, output is 'T'.  When unstable, output is 'F'

   use anisotropy_ajn

   implicit none

   integer, parameter :: rs = 8
   real(rs) :: C(6,6), rho
   integer :: iostat = 0, i, j
   character(len=250) :: file
   integer :: necs = 36
   logical :: read_ecs_stdin = .true.

   call get_args

   if (read_ecs_stdin) then
      do while (iostat == 0)
         if (necs == 36) then
            read(*,*,iostat=iostat) C
         else
            read(*,*,iostat=iostat) ((C(i,j), j=i,6), i=1,6)
            do i = 1, 6
               do j = i+1, 6
                  C(j,i) = C(i,j)
               enddo
            enddo
         endif
         if (iostat < 0) exit
         if (iostat > 0) then
            write(0,'(a,i0,a)') 'CIJ_is_stable: Error: Problem reading ', necs, &
               ' ecs from stdin'
            stop
         endif
         call CIJ_is_stable_out
      enddo
   else
      call CIJ_load(file, C, rho)
      call CIJ_is_stable_out
   endif

contains
   !============================================================================
   subroutine CIJ_is_stable_out
   !============================================================================
      write(*,*) CIJ_is_stable(C)
   end subroutine CIJ_is_stable_out
   !----------------------------------------------------------------------------

   !============================================================================
   subroutine get_args()
   !============================================================================
      integer :: iarg, narg
      character(len=250) :: arg
      narg = command_argument_count()
      iarg = 1
      do while (iarg <= narg)
         call get_command_argument(iarg, arg)
         select case(arg)
            case('-21')
               necs = 21
               iarg = iarg + 1
            case('-f')
               call get_command_argument(iarg+1, file)
               read_ecs_stdin = .false.
               iarg = iarg + 2
            case default
               write(0,'(a)') 'CIJ_is_stable: Error: Urecognised option "'//trim(arg)//'"'
               call usage
         end select
      enddo      
   end subroutine get_args
   !----------------------------------------------------------------------------

   !============================================================================
   subroutine usage
   !============================================================================
      write(0,'(a)') &
         'Usage: CIJ_is_stable (options) < [ecs from stdin]', &
         '   or: CIJ_is_stable (options) -f [.ecs file]', &
         'Options:', &
         '   -f  : Read ecs from file [stdin]', &
         '   -21 : Set necs from stdin to 21 [36]'
      stop
   end subroutine usage
   !----------------------------------------------------------------------------
end program test
!-------------------------------------------------------------------------------