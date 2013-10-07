!===============================================================================
program axial_average
!===============================================================================  
!  Takes sets of constants from stdin and rotates them about one of the three
!  principle axes and sends to stdout.

   use anisotropy_ajn
   
   implicit none
   
   integer, parameter :: rs = 8
   real(rs) :: C(6,6), Cave(6,6)
   integer :: necs, iostat, axis, i,j 
   character(len=250) :: arg
   integer :: nrot = 100
   
   ! Check and get arguments
   if (command_argument_count() /= 2 .and. command_argument_count() /= 3) call usage()
   ! Axis of rotation
   call get_command_argument(1,arg)
   read(arg,*,iostat=iostat) axis
   if (iostat /= 0) call usage()
   ! Number of ecs
   call get_command_argument(2,arg)
   read(arg,*,iostat=iostat) necs
   if (iostat /= 0) call usage()
   ! Optional: number of points to rotate about
   if (command_argument_count() == 3) then
      call get_command_argument(3,arg)
      read(arg,*,iostat=iostat) nrot
      if (iostat /= 0) call usage()
   endif
   
   iostat = 0
   do while (iostat == 0)
      ! Read from stdin
      if (necs == 21) then
         read(*,*,iostat=iostat) ((C(i,j),j=i,6),i=1,6)
         ! No need to symmetrise, as we're writing out the same number of constants
      else
         read(*,*,iostat=iostat) ((C(i,j),j=1,6),i=1,6)
      endif
      if (iostat < 0) exit ! EOF
      if (iostat > 0) then ! Bad read
         write(0,'(a,i0.0,a)') 'CIJ_axial_average: Problem reading ',necs,' constants from stdin'
         stop
      endif
      
      ! Rotate about desired axis
      call CIJ_axial_average(C,axis,Cave,nrot=nrot)
      
      ! Write out with same number of ecs
      if (necs == 21) then
         write(*,*) ((Cave(i,j),j=i,6),i=1,6)
      else
         write(*,*) ((Cave(i,j),j=1,6),i=1,6)
      endif
   enddo
   
   contains
      !=========================================================================
      subroutine usage
      !=========================================================================
         implicit none
         write(0,'(a)') 'Usage: CIJ_axial_average [rotation axis (1|2|3)] ' // &
         '[necs] (n rotations) < (ECs from stdin)', &
         'Options:', &
         '   (n rotations)  : Compute average with n different orientations about axis'
         stop
      end subroutine usage
      !------------------------------------------------------------------------
end program axial_average
!-------------------------------------------------------------------------------