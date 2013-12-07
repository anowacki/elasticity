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
   character(len=2) :: arg
   integer :: i,j,n
   integer :: iostat

   interface
      subroutine sphere_sample_internal(lon,lat,n)
      implicit none
      real(8),intent(out),allocatable,dimension(:) :: lon,lat
      integer :: n
      end subroutine sphere_sample_internal
   end interface

!  Choose the output format we want:
   call getarg(1,arg)

!  Read density-normalised ecs and density from stdin
   read(*,*,iostat=iostat) ((C(i,j),j=1,6),i=1,6),rho
   if (iostat /= 0) then
      write(0,'(a)') 'CIJ_plot_cij2phasevels: Error: Can''t read 36 ecs + rho from stdin'
      stop
   endif

!###
! Vp output
!###

   if (arg == 'P') then

!  Get list of points to evaluate the velocities over
      d = 2.  ! Standard spacing of 5 degrees between points on the surface for the
              ! Vp and AVs plots
      call sphere_sample(d,lon,lat,n)

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

      do i=1,n
         if (lat(i) < 0.) exit
         inc = lat(i)
         azi = -lon(i)
         call CIJ_phasevels(C,rho,azi,inc,pol=pol)
         !  Orientation is given anticlockwise from x3 looking along ray.
         !  GMT wants them as azimuths from N, which is 1-axis.
         pol = 90. - pol - azi
         inc = 90. - lat(i)
         call incazi2lonlat(inc,azi,lo,la)
         write(*,*) lo,la,pol
      enddo

!###
! Vp output on a sphere
!###
   else if (arg == 'PS') then
            d = 2.
            call sphere_sample(d,lon,lat,n)
            minvp =  1.e36
            maxvp = -1.e36
            do i=1,n
               inc = lat(i)
               azi = -lon(i)
               call CIJ_phasevels(C,rho,azi,inc,vp=vp)
               if (vp < minvp) minvp = vp
               if (vp > maxvp) maxvp = vp
               write(*,*) lon(i),lat(i),vp
            enddo
            write(*,*) ">",minvp,maxvp

!###
! AVs output on a sphere
!###
   else if (arg == 'SS') then
      d = 2.
      call sphere_sample(d,lon,lat,n)
      minavs =  1.e36
      maxavs = -1.e36
      do i=1,n
         inc = lat(i)
         azi = -lon(i)
         call CIJ_phasevels(C,rho,azi,inc,avs=avs)
         if (avs < minavs) minavs = avs
         if (avs > maxavs) maxavs = avs
         inc = 90. - lat(i)
         write(*,*) lon(i),lat(i),avs
      enddo
      write(*,*) ">",minavs,maxavs

!###
! Fast orientation output on a sphere
!###
   else if (arg == "FS") then
      d=15.
      call sphere_sample(d,lon,lat,n)
      do i=1,n
         inc = lat(i)
         azi = -lon(i)
         call CIJ_phasevels(C,rho,azi,inc,pol=pol)
         !  Orientation is given clockwise from x3 looking towards centre of sphere
         !  GMT wants them as azimuths from N, which is the same thing
         write(*,*) lon(i),lat(i),pol
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
