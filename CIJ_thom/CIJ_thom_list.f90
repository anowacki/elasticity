!===============================================================================
program CIJ_thom_list
!===============================================================================
!  Program form of the CIJ_thom routine in anisotropy_ajn module which reads!
!  parameters from stdin and outputs the results in a list

   use anisotropy_ajn
   
   implicit none
   
   real(8) :: ecs(6,6)
   real(8) :: vp,vs,rho,del,eps,gam
   integer :: iostatus
   
   if (command_argument_count() /= 0) then
      write(0,'(a)') 'Usage:  CIJ_thom < [vp] [vs] [rho] [delta] [epsilon] [gamma]',&
                     '  Rotationally symmetric about 3-axis (vertical)',&
                     '  Reads parameters from stdin',&
                     '  Sends 36 elastic constants to stdout (density-normalised).'
      stop
   endif
   
   iostatus = 0
   do while (iostatus == 0)
      read(*,*,iostat=iostatus) vp,vs,rho,del,eps,gam
      if (iostatus < 0) exit ! End of file
      if (iostatus > 0) then ! Error in reading
         write(0,'(a)') 'CIJ_thom_list: problem reading vp,vs,rho,del,eps,gam from stdin'
         stop
      endif
      
      ! Calculate ecs
      ecs = CIJ_thom(vp,vs,rho,eps,gam,del)
      
      write(*,*) ecs/rho
      
   enddo
   
end program CIJ_thom_list
!-------------------------------------------------------------------------------
