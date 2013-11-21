!===============================================================================
program CIJ_plot_cij2phasevels
!===============================================================================
!  Helper application for the CIJ_plot shell script, which plots phase velocity
!  surfaces for sets of elastic constants.
!
!  36 ecs and density read from stdin.  
!
!  Finely-sampled points (for Vp and AVs contour plots) sent to stdout
!  Coarser-sampled points (for Vs1 orientation) sent to stderr
!  Choose which output is desired with the first argument to the program:
!     P: P wave velocity
!     A: S wave velocity anisotropy
!     F: Fast shear wave orientation

   use anisotropy_ajn
   use EmatrixUtils
   use spherical_geometry
   
   implicit none
   
   real(8) :: C(6,6), rho, inc, azi, pol, vp, vs1, vs2, avs, d
   real(8) :: minvp, maxvp, minavs, maxavs
   real(8),allocatable,dimension(:) :: lon, lat
   real(8) :: lo, la
   character(len=1) :: arg
   integer :: i,j,n
   
   interface 
      subroutine sphere_sample_internal(lon,lat,n)
      implicit none
      real(8),intent(out),allocatable,dimension(:) :: lon,lat
      integer :: n
      end subroutine sphere_sample_internal
   end interface
   
!  Choose the output format we want:
   call get_command_argument(1,arg)
   
!  Read density-normalised ecs and density from stdin
   read(*,*) ((C(i,j),j=1,6),i=1,6),rho
   
!###
! Vp output
!###
   
   if (arg == 'P') then
   
!  Get list of points to evaluate the velocities over
      d = 2.  ! Standard spacing of 5 degrees between points on the surface for the
              ! Vp and AVs plots
      call sphere_sample(d,lon,lat,n)
!      call sphere_sample_internal(lon,lat,n)
      
      minvp =  1.e36
      maxvp = -1.e36
!  Calculate Vp at each of these points
      do i=1,n
         if (lat(i) < 0.) exit
         !  Convert lon,lat to inc,azi in CI_phasevels frame
         inc = lat(i)
         azi = -lon(i)
         call CIJ_phasevels(C,rho,azi,inc,vp=vp)
         if (vp < minvp) minvp = vp
         if (vp > maxvp) maxvp = vp
         inc = 90. - lat(i)
         call incazi2lonlat(inc,azi,lo,la)
         write(*,*) lo,la,vp
      enddo
      !  Write out min & max values
      write(*,*) ">",minvp,maxvp
      
!###
! AVs output
!###
   else if (arg == 'S') then
      d = 2.
      call sphere_sample(d,lon,lat,n)
!      call sphere_sample_internal(lon,lat,n)
      minavs =  1.e36
      maxavs = -1.e36
      do i=1,n
         if (lat(i) < 0.) exit
         inc = lat(i)
         azi = -lon(i)
         call CIJ_phasevels(C,rho,azi,inc,avs=avs)
         if (avs < minavs) minavs = avs
         if (avs > maxavs) maxavs = avs
         inc = 90. - lat(i)
         call incazi2lonlat(inc,azi,lo,la)
         write(*,*) lo,la,avs
      enddo
      write(*,*) ">",minavs,maxavs
      
!###
! Fast orientation output
!###
   else if (arg == 'F') then
      d=15.
      call sphere_sample(d,lon,lat,n)
!      call sphere_sample_internal(lon,lat,n)
      do i=1,n
         if (lat(i) < 0.) exit
         inc = lat(i)
         azi = -lon(i)
         call CIJ_phasevels(C,rho,azi,inc,pol=pol)
         !  Orientation is given anticlockwise from x3 looking along ray.
         !  GMT wants them as azimuths from N, which is 1-axis.
!         pol = pol + azi
         pol = 90. - pol - azi
         inc = 90. - lat(i)
         call incazi2lonlat(inc,azi,lo,la)
!         if (lat(i) < 75. .or. mod(lon(i),30.) < 10.) &
            write(*,*) lo,la,pol
      enddo
      
!  Unsupported command line argument
   else
      write(6,'(2a)') 'CIJ_plot_cij2phasevels: error: unrecognised option: ',arg
      call exit(1)
   endif
   
end program
!_______________________________________________________________________________

!===============================================================================
subroutine incazi2lonlat(inc,azi,lon,lat)
!===============================================================================
!  Converts inac and azi into longitude and latitude, suitable for plotting on
!  an equal-area stereonet in GMT (use -Ja0/0/? option).
!
!  Points of inc and azi are at lat=inc, and can then rotate to correct azi about
!  the x-axis (lon,lat=0,0).  Does these in global cartesians.

   use spherical_geometry
   
   implicit none
   
   real(8),intent(in)  :: inc,azi
   real(8),intent(out) :: lon,lat
   real(8) :: x,y,z,r, xr,yr,zr, t
   real(8),parameter :: pi = atan2(1.,1.)*4.
   
!   write(*,'(a,2f6.1)') 'inc,azi = ',inc,azi
   
!  Get coordinates for azi=0
   lat = inc
   lon = 0._8
   r = 1._8
   
!  Convert to Cartesian
!   call geog2cart(lon,lat,r,x,y,z,degrees=.true.)
   x = cos(lat*pi/180._8)
   y = 0. ! Because we're always on the Greenwich meridian
   z = sin(lat*pi/180._8)
!   write(*,*) 'lon,lat=',lon,lat,'  x,y,z=',x,y,z
   
!  Rotate to correct azimuth
   t = pi*azi/180.
   xr =  x
   yr =  y*cos(t) + z*sin(t)
   zr = -y*sin(t) + z*cos(t)
   
!   write(*,*) 'Rotated xyz =',xr,yr,zr
   
!  Convert back to geographic
!   call cart2geog(x,y,z,lon,lat,r,degrees=.true.)
   lon = atan2(yr,xr)*180._8/pi
   lat = asin(zr)*180._8/pi
!   write(*,*) 'Rotated lon,lat =',lon,lat
   
   return
end subroutine incazi2lonlat
!-------------------------------------------------------------------------------

!===============================================================================
   subroutine sphere_sample_internal(lon,lat,n)
!===============================================================================
!  Internal version of sphere_sample which returns a hardwired set of lon,lat
!  points.  lon,lat should not be allocated on entry.
   real(8), intent(out), allocatable, dimension(:) :: lon,lat
   integer, intent(out) :: n
   
   n = 216
   if (allocated(lon)) deallocate(lon)  ! This isn't necessary
   if (allocated(lat)) deallocate(lat)
   allocate(lon(n),lat(n))
lon(1) = 0.;  lat(1) = 90.
lon(2) = 0.;  lat(2) = 80.
lon(3) = 15.;  lat(3) = 80.
lon(4) = 30.;  lat(4) = 80.
lon(5) = 45.;  lat(5) = 80.
lon(6) = 60.;  lat(6) = 80.
lon(7) = 75.;  lat(7) = 80.
lon(8) = 90.;  lat(8) = 80.
lon(9) = 105.;  lat(9) = 80.
lon(10) = 120.;  lat(10) = 80.
lon(11) = 135.;  lat(11) = 80.
lon(12) = 150.;  lat(12) = 80.
lon(13) = 165.;  lat(13) = 80.
lon(14) = 180.;  lat(14) = 80.
lon(15) = 195.;  lat(15) = 80.
lon(16) = 210.;  lat(16) = 80.
lon(17) = 225.;  lat(17) = 80.
lon(18) = 240.;  lat(18) = 80.
lon(19) = 255.;  lat(19) = 80.
lon(20) = 270.;  lat(20) = 80.
lon(21) = 285.;  lat(21) = 80.
lon(22) = 300.;  lat(22) = 80.
lon(23) = 315.;  lat(23) = 80.
lon(24) = 330.;  lat(24) = 80.
lon(25) = 345.;  lat(25) = 80.
lon(26) = 0.;  lat(26) = 70.
lon(27) = 15.;  lat(27) = 70.
lon(28) = 30.;  lat(28) = 70.
lon(29) = 45.;  lat(29) = 70.
lon(30) = 60.;  lat(30) = 70.
lon(31) = 75.;  lat(31) = 70.
lon(32) = 90.;  lat(32) = 70.
lon(33) = 105.;  lat(33) = 70.
lon(34) = 120.;  lat(34) = 70.
lon(35) = 135.;  lat(35) = 70.
lon(36) = 150.;  lat(36) = 70.
lon(37) = 165.;  lat(37) = 70.
lon(38) = 180.;  lat(38) = 70.
lon(39) = 195.;  lat(39) = 70.
lon(40) = 210.;  lat(40) = 70.
lon(41) = 225.;  lat(41) = 70.
lon(42) = 240.;  lat(42) = 70.
lon(43) = 255.;  lat(43) = 70.
lon(44) = 270.;  lat(44) = 70.
lon(45) = 285.;  lat(45) = 70.
lon(46) = 300.;  lat(46) = 70.
lon(47) = 315.;  lat(47) = 70.
lon(48) = 330.;  lat(48) = 70.
lon(49) = 345.;  lat(49) = 70.
lon(50) = 0.;  lat(50) = 60.
lon(51) = 15.;  lat(51) = 60.
lon(52) = 30.;  lat(52) = 60.
lon(53) = 45.;  lat(53) = 60.
lon(54) = 60.;  lat(54) = 60.
lon(55) = 75.;  lat(55) = 60.
lon(56) = 90.;  lat(56) = 60.
lon(57) = 105.;  lat(57) = 60.
lon(58) = 120.;  lat(58) = 60.
lon(59) = 135.;  lat(59) = 60.
lon(60) = 150.;  lat(60) = 60.
lon(61) = 165.;  lat(61) = 60.
lon(62) = 180.;  lat(62) = 60.
lon(63) = 195.;  lat(63) = 60.
lon(64) = 210.;  lat(64) = 60.
lon(65) = 225.;  lat(65) = 60.
lon(66) = 240.;  lat(66) = 60.
lon(67) = 255.;  lat(67) = 60.
lon(68) = 270.;  lat(68) = 60.
lon(69) = 285.;  lat(69) = 60.
lon(70) = 300.;  lat(70) = 60.
lon(71) = 315.;  lat(71) = 60.
lon(72) = 330.;  lat(72) = 60.
lon(73) = 345.;  lat(73) = 60.
lon(74) = 0.;  lat(74) = 50.
lon(75) = 15.;  lat(75) = 50.
lon(76) = 30.;  lat(76) = 50.
lon(77) = 45.;  lat(77) = 50.
lon(78) = 60.;  lat(78) = 50.
lon(79) = 75.;  lat(79) = 50.
lon(80) = 90.;  lat(80) = 50.
lon(81) = 105.;  lat(81) = 50.
lon(82) = 120.;  lat(82) = 50.
lon(83) = 135.;  lat(83) = 50.
lon(84) = 150.;  lat(84) = 50.
lon(85) = 165.;  lat(85) = 50.
lon(86) = 180.;  lat(86) = 50.
lon(87) = 195.;  lat(87) = 50.
lon(88) = 210.;  lat(88) = 50.
lon(89) = 225.;  lat(89) = 50.
lon(90) = 240.;  lat(90) = 50.
lon(91) = 255.;  lat(91) = 50.
lon(92) = 270.;  lat(92) = 50.
lon(93) = 285.;  lat(93) = 50.
lon(94) = 300.;  lat(94) = 50.
lon(95) = 315.;  lat(95) = 50.
lon(96) = 330.;  lat(96) = 50.
lon(97) = 345.;  lat(97) = 50.
lon(98) = 0.;  lat(98) = 40.
lon(99) = 15.;  lat(99) = 40.
lon(100) = 30.;  lat(100) = 40.
lon(101) = 45.;  lat(101) = 40.
lon(102) = 60.;  lat(102) = 40.
lon(103) = 75.;  lat(103) = 40.
lon(104) = 90.;  lat(104) = 40.
lon(105) = 105.;  lat(105) = 40.
lon(106) = 120.;  lat(106) = 40.
lon(107) = 135.;  lat(107) = 40.
lon(108) = 150.;  lat(108) = 40.
lon(109) = 165.;  lat(109) = 40.
lon(110) = 180.;  lat(110) = 40.
lon(111) = 195.;  lat(111) = 40.
lon(112) = 210.;  lat(112) = 40.
lon(113) = 225.;  lat(113) = 40.
lon(114) = 240.;  lat(114) = 40.
lon(115) = 255.;  lat(115) = 40.
lon(116) = 270.;  lat(116) = 40.
lon(117) = 285.;  lat(117) = 40.
lon(118) = 300.;  lat(118) = 40.
lon(119) = 315.;  lat(119) = 40.
lon(120) = 330.;  lat(120) = 40.
lon(121) = 345.;  lat(121) = 40.
lon(122) = 0.;  lat(122) = 30.
lon(123) = 15.;  lat(123) = 30.
lon(124) = 30.;  lat(124) = 30.
lon(125) = 45.;  lat(125) = 30.
lon(126) = 60.;  lat(126) = 30.
lon(127) = 75.;  lat(127) = 30.
lon(128) = 90.;  lat(128) = 30.
lon(129) = 105.;  lat(129) = 30.
lon(130) = 120.;  lat(130) = 30.
lon(131) = 135.;  lat(131) = 30.
lon(132) = 150.;  lat(132) = 30.
lon(133) = 165.;  lat(133) = 30.
lon(134) = 180.;  lat(134) = 30.
lon(135) = 195.;  lat(135) = 30.
lon(136) = 210.;  lat(136) = 30.
lon(137) = 225.;  lat(137) = 30.
lon(138) = 240.;  lat(138) = 30.
lon(139) = 255.;  lat(139) = 30.
lon(140) = 270.;  lat(140) = 30.
lon(141) = 285.;  lat(141) = 30.
lon(142) = 300.;  lat(142) = 30.
lon(143) = 315.;  lat(143) = 30.
lon(144) = 330.;  lat(144) = 30.
lon(145) = 345.;  lat(145) = 30.
lon(146) = 0.;  lat(146) = 20.
lon(147) = 15.;  lat(147) = 20.
lon(148) = 30.;  lat(148) = 20.
lon(149) = 45.;  lat(149) = 20.
lon(150) = 60.;  lat(150) = 20.
lon(151) = 75.;  lat(151) = 20.
lon(152) = 90.;  lat(152) = 20.
lon(153) = 105.;  lat(153) = 20.
lon(154) = 120.;  lat(154) = 20.
lon(155) = 135.;  lat(155) = 20.
lon(156) = 150.;  lat(156) = 20.
lon(157) = 165.;  lat(157) = 20.
lon(158) = 180.;  lat(158) = 20.
lon(159) = 195.;  lat(159) = 20.
lon(160) = 210.;  lat(160) = 20.
lon(161) = 225.;  lat(161) = 20.
lon(162) = 240.;  lat(162) = 20.
lon(163) = 255.;  lat(163) = 20.
lon(164) = 270.;  lat(164) = 20.
lon(165) = 285.;  lat(165) = 20.
lon(166) = 300.;  lat(166) = 20.
lon(167) = 315.;  lat(167) = 20.
lon(168) = 330.;  lat(168) = 20.
lon(169) = 345.;  lat(169) = 20.
lon(170) = 0.;  lat(170) = 10.
lon(171) = 15.;  lat(171) = 10.
lon(172) = 30.;  lat(172) = 10.
lon(173) = 45.;  lat(173) = 10.
lon(174) = 60.;  lat(174) = 10.
lon(175) = 75.;  lat(175) = 10.
lon(176) = 90.;  lat(176) = 10.
lon(177) = 105.;  lat(177) = 10.
lon(178) = 120.;  lat(178) = 10.
lon(179) = 135.;  lat(179) = 10.
lon(180) = 150.;  lat(180) = 10.
lon(181) = 165.;  lat(181) = 10.
lon(182) = 180.;  lat(182) = 10.
lon(183) = 195.;  lat(183) = 10.
lon(184) = 210.;  lat(184) = 10.
lon(185) = 225.;  lat(185) = 10.
lon(186) = 240.;  lat(186) = 10.
lon(187) = 255.;  lat(187) = 10.
lon(188) = 270.;  lat(188) = 10.
lon(189) = 285.;  lat(189) = 10.
lon(190) = 300.;  lat(190) = 10.
lon(191) = 315.;  lat(191) = 10.
lon(192) = 330.;  lat(192) = 10.
lon(193) = 345.;  lat(193) = 10.
lon(194) = 0.;  lat(194) = 0.
lon(195) = 15.;  lat(195) = 0.
lon(196) = 30.;  lat(196) = 0.
lon(197) = 45.;  lat(197) = 0.
lon(198) = 60.;  lat(198) = 0.
lon(199) = 75.;  lat(199) = 0.
lon(200) = 90.;  lat(200) = 0.
lon(201) = 105.;  lat(201) = 0.
lon(202) = 120.;  lat(202) = 0.
lon(203) = 135.;  lat(203) = 0.
lon(204) = 150.;  lat(204) = 0.
lon(205) = 165.;  lat(205) = 0.
lon(206) = 180.;  lat(206) = 0.
lon(207) = 195.;  lat(207) = 0.
lon(208) = 210.;  lat(208) = 0.
lon(209) = 225.;  lat(209) = 0.
lon(210) = 240.;  lat(210) = 0.
lon(211) = 255.;  lat(211) = 0.
lon(212) = 270.;  lat(212) = 0.
lon(213) = 285.;  lat(213) = 0.
lon(214) = 300.;  lat(214) = 0.
lon(215) = 315.;  lat(215) = 0.
lon(216) = 330.;  lat(216) = 0.
lon(217) = 345.;  lat(217) = 0.

   
   end subroutine sphere_sample_internal
!-------------------------------------------------------------------------------
