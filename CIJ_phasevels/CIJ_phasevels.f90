!===============================================================================
program phasevels
!===============================================================================
!  Read in ecs from stdin or from a file, and output information for a given
!  inclination and azimuth
!
!  Relies on CIJ_phasevels in module EmatrixUtils, by James Wookey.  See the source
!  for information on the coordinate system and angle conventions.
!
!  Usage:
!      CIJ_phasevels [inc] [azi] (ecfile)

   use EmatrixUtils
   use anisotropy_ajn

   implicit none
   
   real(8) :: ecs(6,6),inc,azi,rho,pol,avs,vp,vs1,vs2,vsmean
   character(len=250) :: file,arg
   integer :: iostatus
   
   if (command_argument_count() < 3 .or. command_argument_count() > 4) then
      write(0,'(a)') 'Usage: CIJ_phasevels [inc] [azi] [rho] (ecfile)',&
                     '   Inc is angle from 1-2 plane towards 3',&
                     '   Azi is angle from 1 towards 2 in 1-2 plane',&
                     '   If no input file provided, ecs (density-normalised) are read from stdin, c11, c12, etc. (36)'
      stop
   endif
   
   call get_command_argument(1,arg) ;  read(arg,*) inc
   call get_command_argument(2,arg) ;  read(arg,*) azi
   call get_command_argument(3,arg) ;  read(arg,*) rho

!  Get elastic constants
!  If reading from an .ecs file, MUST NOT BE DENSITY-NORMALISED!!!
   if (command_argument_count() == 4) then  ! One set from input file
      call get_command_argument(4,file)
      call CIJ_load(file,ecs,rho)
!  Check whether we're in GPa, not Pa
      if (ecs(1,1) < 5000.) ecs = ecs * 1.e9
      call CIJ_phasevels(ecs/rho,rho,azi,inc,pol=pol,avs=avs,vp=vp,vs1=vs1,vs2=vs2)
!      write(*,'(6e10.1)') ecs
      write(*,'(a)') '   pol      avs        vp       vs1       vs2'
      write(*,'(f6.1,f9.4,3f10.4)') pol,avs,vp,vs1,vs2
!  If reading ecs from stdin, MUST BE DENSITY-NORMALISED!!
   else if (command_argument_count() == 3) then  ! Many sets from stdin
      write(*,'(a)') '   pol      avs        vp       vs1       vs2'
      do while (iostatus == 0)
         read(*,*,iostat=iostatus) ecs
         if (iostatus /= 0) exit
!         if (iostatus > 0) stop 'Some problem reading file.  36 ecs must be present on each line.'
         if (ecs(1,1) < 5000.) ecs = ecs * 1.e9
!  Check whether we're in GPa, not Pa
         call CIJ_phasevels(ecs,rho,azi,inc,pol=pol,avs=avs,vp=vp,vs1=vs1,vs2=vs2)
         write(*,'(f6.1,f9.4,3f10.4)') pol,avs,vp,vs1,vs2
      enddo
   endif

end program phasevels
