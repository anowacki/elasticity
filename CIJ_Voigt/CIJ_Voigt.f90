!===============================================================================
program Voigt_average
!===============================================================================
!  Compute the Voigt average of two or more elasticity tensors.
!  Usage:
!     CIJ_Voigt < [input] > [output]
!     input is: VF(i)   c11(i)   c12(i) ... c16(i)   c21(i)   ... c26(i)   ... c66(i)
!               VF(i+1) c11(i+1) c12(i) ... c16(i+1) c21(i+1) ... c26(i+1) ... c66(i+1)
!  OR
!     CIJ_Voigt [.ecs file 1] [VF 1]  [.ecs file 2] [VF 2] ... [.ecs file n] [VF n]

use anisotropy_ajn, only: CIJ_Voigt_av, CIJ_load

implicit none

integer,parameter :: nmax = 10000  ! Maximum number of constants to average
integer :: n,i,ii,jj
real(8) :: C(nmax,6,6),Ctemp(6,6)
real(8) :: VF(nmax),VFtemp
real(8) :: r(nmax),rtemp
character(len=250) :: arg
character(len=250)  :: file
integer :: ioerr

!  Check for correct invocation
if (modulo(command_argument_count(),2) /= 0) then
   call usage
endif

!  Loop through lines of stdin in, which each contain volume fraction, and then 
!  36 elastic constants
if (command_argument_count() == 0) then
   ioerr = 0
   i = 1
   do while (ioerr == 0)
      read(*,*,iostat=ioerr) VFtemp, ((Ctemp(ii,jj),jj=1,6),ii=1,6), rtemp
      if (ioerr > 0) then
         write(0,'(a)') 'CIJ_Voigt: Error: problem reading constants from stdin.'
         stop
      endif
      if (ioerr < 0) exit
      VF(i) = VFtemp
      C(i,:,:) = Ctemp
      r(i) = rtemp
      n = i
      i = i + 1
   enddo
   
   call CIJ_Voigt_av(VF(1:n),C(1:n,:,:),r(1:n),Ctemp,rtemp)
   
   write(*,*) ((Ctemp(ii,jj),jj=1,6),ii=1,6),rtemp
   
!  Read the .ecs files from the command line and mix them in the proportions given
!  by every second command line argument
else
   n = command_argument_count()/2
   !  Loop over input files
   do i=1,n
      call get_command_argument(2*i-1,file)  ! Get .ecs file
      call get_command_argument(2*i,  arg)
      read(arg,*) VF(i)
      call CIJ_load(file,Ctemp,rtemp)
      C(i,:,:) = Ctemp/rtemp
      r(i) = rtemp
   enddo
   
   call CIJ_Voigt_av(VF(1:n),C(1:n,:,:),r(1:n),Ctemp,rtemp)
   
   write(*,*) ((Ctemp(ii,jj),jj=1,6),ii=1,6),rtemp
endif

contains
   subroutine usage
      write(0,'(a)') &
         'Usage:', &
         '   CIJ_Voigt < [input] > [output]', &
         '   input is: VF(i)   c11(i)   c12(i) ... c16(i)   c21(i)   ... c26(i)   ... c66(i)   rho(i)', &
         '             VF(i+1) c11(i+1) c12(i) ... c16(i+1) c21(i+1) ... c26(i+1) ... c66(i+1) rho(i+1)', &
         'OR', &
         '   CIJ_Voigt [.ecs file 1] [VF 1]  [.ecs file 2] [VF 2] ... [.ecs file n] [VF n]',&
         '   Output: 36 ecs and density'
      stop
   end subroutine usage
end program Voigt_average
