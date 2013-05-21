!===============================================================================
program EC_grid_rotate_bin
!===============================================================================
! Rotate all the constants on an EC grid by some angles.

use EC_grid
use anisotropy_ajn

   implicit none

   ! Precision selector
   integer, parameter :: rs = 8
   
   ! Types of grid: assumed-int, explicit-real and explicit-int
   type(ECgrid) :: g
   type(ECgridr) :: gr
   type(ECgridi) :: gi
   integer :: grid_type,ix,iy,iz,ios
   real(rs) :: Cr(6,6)

   ! Angles
   real(rs) :: a,b,c
   
   ! In/outfiles
   character(len=250) :: infile, outfile, arg
   
   ! Verbosity
   logical :: quiet = .false.
   
   
   ! Check arguments
   if (iargc() /= 5) then
      write(0,'(a)') 'Usage: EC_grid_rotate_bin [infile] [a] [b] [c] [outfile]',&
                     '  a, b and c are respectively rotations about the x1, x2 and x3 axes,',&
                     '  applied clockwise when looking down the axis'
      stop
   endif
   
   ! Get arguments
   call getarg(1,infile)
   call getarg(2,arg); read(arg,*,iostat=ios) a
   call bad_angle_read
   call getarg(3,arg); read(arg,*,iostat=ios) b
   call bad_angle_read
   call getarg(4,arg); read(arg,*,iostat=ios) c
   call bad_angle_read
   call getarg(5,outfile)
   
   ! Determine the coordinate type of the grid
   call EC_grid_check_type_bin(infile,grid_type,quiet=quiet)
   
   ! Read in file, rotate constants and write out to new file
   ! Assumed-int
   if (grid_type == EC_grid_nver_assumed_i) then
      call EC_grid_load_bin(infile,g,quiet=quiet)
      do iz=1,g%nz
         do iy=1,g%ny
            do ix=1,g%nz
               call CIJ_rot3(g%ecs(ix,iy,iz,:,:),a,b,c,CR)
               g%ecs(ix,iy,iz,:,:) = CR
            enddo
         enddo
      enddo
      call EC_grid_write_bin(outfile,g)
   
   ! Int
   else if (grid_type == EC_grid_nver_i) then
      call EC_gridi_load_bin(infile,gi,quiet=quiet)
      do iz=1,gi%nz
         do iy=1,gi%ny
            do ix=1,gi%nz
               call CIJ_rot3(gi%ecs(ix,iy,iz,:,:),a,b,c,CR)
               gi%ecs(ix,iy,iz,:,:) = CR
            enddo
         enddo
      enddo
      call EC_gridi_write_bin(outfile,gi)
      
   ! Real
   else if (grid_type == EC_grid_nver_r) then
      call EC_gridr_load_bin(infile,gr,quiet=quiet)
      do iz=1,gr%nz
         do iy=1,gr%ny
            do ix=1,gr%nz
               call CIJ_rot3(gr%ecs(ix,iy,iz,:,:),a,b,c,CR)
               gr%ecs(ix,iy,iz,:,:) = CR
            enddo
         enddo
      enddo
      call EC_gridr_write_bin(outfile,gr)
      
   ! Bad file
   else
      write(0,'(a)') 'EC_grid_rotate_bin: input file is not a recognised EC_grid binary file.'
      stop
   endif
   
   
   contains
   
   !----------------------------------------------------------------------------
   subroutine bad_angle_read
   !----------------------------------------------------------------------------
   implicit none
   
      if (ios /= 0) then
         write(0,'(a)') 'EC_grid_rotate_bin: cannot read rotation angle from command line'
         stop
      endif
   end subroutine bad_angle_read
   !----------------------------------------------------------------------------

end program EC_grid_rotate_bin
!-------------------------------------------------------------------------------