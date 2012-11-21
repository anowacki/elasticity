!==============================================================================
program Au
!==============================================================================
!  Computes the Universal Elastic Anisotropy Index (A^U) given a set of elastic
!  constants.
!
!  A^U = Cv:Sr - 6, where Cv is Voigt-averaged stiffness, Sr is Reuss-averaged 
!                   compliance, and : signifies inner product, such that
!                   Cij:Sij = C11*S11 + C12*S21 + C13*S31 ... C66*S66
!
!      = 5(Gv/Gr) + (Kv/Kr) - 6
!
!       where 9Kv = c11 + c22 + c33 + 2(c12 + c23 + c31)
!            15Gv = c11 + c22 + c33 - (c12 + c23 + c31) + 3(c44 + c55 + c66)
!            1/Kr = s11 + s22 + s33 + 2(s12 + s23 + s31)
!           15/Gr = 4(s11 + s22 + s33) - 4(s12 + s23 + s31) + 3(s44 + s55 + s66)
!
!  According to:
!      Hill, R. The elastic behaviour of a crystalline aggregate. 
!               P Phys Soc Lond A (1952) vol. 65 (389) pp. 349-355
!
!  Read ECs from stdin, assuming only 21 are supplied.
!  If first command line argument is set, use that number of elastic constants
   
   use anisotropy_ajn
   
   implicit none
   
   double precision  :: C(6,6),S(6,6),Kv,Kr,Gv,Gr,A
   integer           :: nec=21,i,j,iostatus=0
   character(len=20) :: arg
   
!  Check for command line options
   if (iargc() > 0) then
      call getarg(1,arg)
      read(arg,*,iostat=iostatus) nec
      if (iostatus /= 0 .or. (nec /= 21 .and. nec /= 36)) then
         write(0,'(3a)') 'Argument "',trim(arg),'" not understood.'
         write(0,'(a)') 'Please specify whether 21 or 36 elastic constants input.'
      stop
      endif
   endif
   
!  Loop over all lines of input
   iostatus=0
   do while (iostatus==0)
   
!  Read in constants
   if (nec == 21) then
      read (*,*,iostat=iostatus) ((C(i,j),j=i,6),i=1,6)
   else 
      read (*,*,iostat=iostatus) ((C(i,j),j=1,6),i=1,6)
   endif
   
   if (iostatus < 0) stop
   if (iostatus > 0) then 
      write(0,'(a)') 'Problem reading elastic constants: stopping.'
      stop
   endif
   
!  Fill in lower diagonal
   do i=1,6; do j=1,6; C(j,i) = C(i,j); enddo; enddo
   
!!  Find stiffness from inverse
!   call inverse(6,6,C,S)
!   
!!  Calculate Voigt moduli
!   Kv = (1./9.) * (C(1,1) + C(2,2) + C(3,3) + 2.*(C(1,2) + C(2,3) + C(3,1)))
!   
!   Gv = (1./15.) * (C(1,1) + C(2,2) + C(3,3) - (C(1,2) + C(2,3) + C(3,1)) + &
!                    3.*(C(4,4) + C(5,5) + C(6,6)))
!   
!!  Calculate Reuss moduli
!   Kr = 1./(S(1,1) + S(2,2) + S(3,3) + 2.*(S(1,2) + S(2,3) + S(3,1)))
!   
!   Gr = 15./(4.*(S(1,1) + S(2,2) + S(3,3)) - 4.*(S(1,2) + S(2,3) + S(3,1)) + &
!             3.*(S(4,4) + S(5,5) + S(6,6)))
!   
!!  Calculate Au
!   A = 5.*(Gv/Gr) + (Kv/Kr) - 6.
 
   A = CIJ_Au(C)
 
!  Output value to stdout
   write(*,*) A

   enddo
   
end program Au
!------------------------------------------------------------------------------
