!===============================================================================
program CIJ_BandS_axes
!===============================================================================
! CIJ_BandS_axes reads constants from stdin, or from a file, and returns information
! about the tensor symmetry and the orientation of the symmetry axes, via the
! process described by Browaeys & Chvrot, GJI, 2004.

   use anisotropy_ajn

   implicit none

   logical :: all = .true., Xout = .false., iso = .false., hex = .false., &
      tet = .false., ort = .false., mon = .false., tri = .false., &
      read_file = .true., rotate = .false., symmetry = .false., sum = .false.
   real(8), dimension(6,6) :: C, Ciso, Chex, Ctet, Cort, Cmon, Ctri, CR
   real(8) :: rho, R(3,3), x1(3), x2(3), x3(3)
   character(len=500) :: file, arg, symm
   integer :: iostat, i, j

   call get_args

   if (read_file) then
      call CIJ_load(file, C, rho)
      C = C/rho
   else
      read(*,'(a)',iostat=iostat) arg
      if (iostat /= 0) call bad_read('')
      ! 36 ecs
      read(arg,*,iostat=iostat) C
      if (iostat > 0) call bad_read('36')
      if (iostat < 0) then ! EOF
         ! 21 ecs
         read(arg,*,iostat=iostat) ((C(i,j), j=i,6), i=1,6)
         if (iostat /= 0) call bad_read('21')
         do i=1,6; do j=i+1,6; C(j,i) = C(i,j); enddo; enddo
      endif
   endif

   ! Find symmetry and axes
   call CIJ_brow_chev_symm(C, CR=CR, R=R, symm=symm)
   x1 = R(:,1)
   x2 = R(:,2)
   x3 = R(:,3)

   ! If desired, rotate into optimum orientation before decomposing, otherwise leave
   if (rotate) C = CR

   call CIJ_brow_chev(C, Ciso, Chex, Ctet, Cort, Cmon, Ctri)

   if (all .or. symmetry) call write_symm(symm)

   if (.not.sum .and. any([all, iso, hex, tet, ort, mon, tri])) then
      if (all .or. iso) call write_C('Ciso:', Ciso)
      if (all .or. hex) call write_C('Chex:', Chex)
      if (all .or. tet) call write_C('Ctet:', Ctet)
      if (all .or. ort) call write_C('Cort:', Cort)
      if (all .or. mon) call write_C('Cmon:', Cmon)
      if (all .or. tri) call write_C('Ctri:', Ctri)
   endif
   
   if (sum) then
      C = 0._8
      if (all .or. iso) C = C + Ciso
      if (all .or. hex) C = C + Chex
      if (all .or. tet) C = C + Ctet
      if (all .or. ort) C = C + Cort
      if (all .or. mon) C = C + Cmon
      if (all .or. tri) C = C + Ctri
      call write_C('Csum:', C)
   endif

   if (all .or. Xout) call write_X(x1, x2, x3)


contains
   subroutine usage(help)
      logical, intent(in), optional :: help
      logical :: stdout
      integer :: lu
      stdout = .false.
      if (present(help)) stdout = help
      lu = 0
      if (stdout) lu = 6
      write(lu,'(a)') &
         'Usage: CIJ_BandS_axes (options) [file]', &
         'Return information about the symmetry and the symmetry axes of a tensor', &
         '   read from file <file> or from a list of Cij from stdin if <file> is "-".', &
         'The outputs are chosen as flags read on the command line and are printed', &
         '   prefaced by:', &
         '   Ciso, Chex, Ctet, Cort, Cmon, Ctri : Elastic constants from unrotated', &
         '                                        input tensor', &
         '   x1, x2, x3                         : Symmetry axes', &
         'Options:', &
         '   -a:  Return all information [default]', &
         '   -R:  Rotate elastic constants before decomposition', &
         '   -S:  Write only the sum of the desired terms (e.g., Ciso+Chex)', &
         '   -X:  Provide symmetry axes, in order x{1,2,3}, as cartesian unit vectors', &
         '   -i:  Return isotropic part', &
         '   -h:  Return hexagonal part', &
         '   -t:  Return tetragonal part', &
         '   -o:  Return orthorhombic part', &
         '   -m:  Return monoclinic part', &
         '   -r:  Return triclinic part', &
         '   -s:  Return symmetry name', &
         '   --help: Print this message'
      if (stdout) then
         stop
      else
         error stop
      endif
   end subroutine usage

   subroutine get_args
      integer :: iarg, narg
      narg = command_argument_count()
      if (narg < 1) call usage
      iarg = 1
      do while (iarg <= narg - 1)
         call get_command_argument(iarg, arg)
         select case (arg)
            case ('-a'); all = .true.
            case ('-R'); rotate = .true.
            case ('-S'); sum = .true.
            case ('-X'); all = .false.; Xout = .true.
            case ('-i'); all = .false.; iso = .true.
            case ('-h'); all = .false.; hex = .true.
            case ('-t'); all = .false.; tet = .true.
            case ('-o'); all = .false.; ort = .true.
            case ('-m'); all = .false.; mon = .true.
            case ('-r'); all = .false.; tri = .true.
            case ('-s'); all = .false.; symmetry = .true.
            case ('--help'); call usage(help=.true.)
            case default; call usage
         end select
         iarg = iarg + 1
      enddo
      call get_command_argument(narg, file)
      if (file == '-') read_file = .false.
      if (file == '--help') call usage(help=.true.)
   end subroutine get_args

   subroutine write_C(str, CC)
      character(len=*), intent(in) :: str
      real(8), intent(in) :: CC(6,6)
      write(*,'(a,36(1x,es14.7))') trim(str), CC
   end subroutine write_C

   subroutine write_X(xx1, xx2, xx3)
      real(8), intent(in), dimension(3) :: xx1, xx2, xx3
      write(*,'(a,3f10.6))') 'x1:', xx1, 'x2:', xx2, 'x3:', xx3
   end subroutine write_X

   subroutine write_symm(str)
      character(len=*), intent(in) :: str
      write(*,'(a)') 'Symmetry: ' // trim(str)
   end subroutine write_symm

   subroutine bad_read(str)
      character(len=*), intent(in) :: str
      write(0,'(a)') 'CIJ_BandS_axes: Error: Error reading ' // trim(str) // &
         ' ecs from stdin'
      error stop
   end subroutine bad_read
end program CIJ_BandS_axes
!-------------------------------------------------------------------------------