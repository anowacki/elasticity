!===============================================================================
program CIJ_scale_to_iso
!===============================================================================
!  Convert a series of elastic constants into one with a target isotropic average
!  velocity.  Only considers S wave velocities at the moment.

implicit none

integer :: i,j,n,ifile
integer, parameter :: npoints = 224
real(8) :: C(6,6), Ciso(6,6), Cscaled(6,6), r, vs
real(8) :: lon(npoints),lat(npoints)  ! points sampling a hemisphere
real(8) :: epsilon = 1.  ! Tolerance for iteration over scaling of constants
character(len=250):: arg, file
integer :: ioerr,nopt

interface
   subroutine CIJ_scale_to_vs(C,r,eps,Vs,lon,lat,Cout)
      use EmatrixUtils, only: CIJ_phasevels
      implicit none
      real(8),intent(in) :: C(6,6),r,eps,Vs
      real(8),intent(in),dimension(:) :: lon,lat  ! Arbitrary length automatic arrays
      real(8),intent(out) :: Cout(6,6)
   end subroutine CIJ_scale_to_vs
   subroutine sphere_sample_local(lon,lat)
      implicit none
      real(8),dimension(:) :: lon,lat
   end subroutine sphere_sample_local
end interface

!  Check for correct invocation and get options
if (iargc() /= 1) then
   write(0,'(a)') 'Usage: CIJ_scale_to_iso [vs] < [list of 36 ecs + density]'
   stop
endif

! Get input
call getarg(1,arg);  read(arg,*) Vs

!  Sample a hemisphere evenly at 1 degree intervals
call sphere_sample_local(lon,lat)

! Loop overs lines of stdin
ioerr = 0
do while (ioerr == 0)
   read(*,*,iostat=ioerr) ((C(i,j),j=1,6),i=1,6),r
   if (ioerr > 0) then 
      write(0,'(a)') 'CIJ_iso: error: problem reading 36 ecs + density from stdin.'
      stop
   endif
   if (ioerr < 0) exit
   
   ! Now scale up/down until we reach the desired S wave velocity
   call CIJ_scale_to_vs(C,r,epsilon,Vs,lon,lat,Cscaled)
   
   ! Write out the elastic constants
   write(*,'(20(e20.10,1x),e20.10)') ((Cscaled(i,j),j=i,6),i=1,6)
enddo

end program CIJ_scale_to_iso

!===============================================================================
subroutine CIJ_scale_to_vs(C,r,eps,Vs,lon,lat,Cout)
!===============================================================================
   use EmatrixUtils, only: CIJ_phasevels
   implicit none
   real(8),intent(in) :: C(6,6),r,eps,Vs
   real(8),intent(in),dimension(:) :: lon,lat  ! Arbitrary length automatic arrays
   real(8),intent(out) :: Cout(6,6)
   real(8) :: Vsout
   
   interface
      subroutine CIJ_isotropic_average(C,r,lon,lat,Ciso,Vp,Vs)
         real(8),intent(in) :: C(6,6),r
         real(8),intent(in),dimension(:) :: lon,lat
         real(8),intent(out),optional :: Ciso(6,6)
         real(8),intent(out),optional :: Vp,Vs
      end subroutine CIJ_isotropic_average
   end interface
   
   Cout = C
   
   call CIJ_isotropic_average(Cout,r,lon,lat,Vs=Vsout)
   do while (abs(Vsout-Vs) > eps)
      if (Vsout > Vs) then
         Cout = Cout*0.9995_8
      else if (Vsout < Vs) then
         Cout = Cout*1.0005_8
      endif
      call CIJ_isotropic_average(Cout,r,lon,lat,Vs=Vsout)
   enddo

end subroutine CIJ_scale_to_vs
!-------------------------------------------------------------------------------

!===============================================================================
subroutine CIJ_isotropic_average(C,r,lon,lat,Ciso,Vp,Vs)
!===============================================================================
   use EmatrixUtils, only: CIJ_phasevels

   implicit none
   
   real(8),intent(in) :: C(6,6),r
   real(8),intent(in),dimension(:) :: lon,lat  ! Arbitrary length automatic arrays
   real(8),intent(out),optional :: Ciso(6,6)
   real(8) :: Vs1, Vs2, meanVp, meanVs, VsA, Vp_temp, Vs_temp
   real(8),intent(out),optional :: Vp,Vs
   integer :: n,i,j
   
   !  Get length of sphere sampling points
   if (size(lon) /= size(lat)) then
      write(0,'(a)') 'CIJ_isotropic_average: error: input array of points must have same lengths.'
      stop
   endif
   n = size(lon)
   
   !  Loop over each sampling point and calculate averages using harmonic mean
   meanVp = 0.
   meanVs = 0.
   do i=1,n
      call CIJ_phasevels(C,r,lat(i),lon(i),vp=Vp_temp,vs1=Vs1,vs2=Vs2)
      meanVp = meanVp + 1._8/Vp_temp
      VsA = 2._8/(1._8/Vs1 + 1._8/Vs2)
      meanVs = meanVs + 1._8/VsA
   enddo
   
   meanVp = meanVp/real(n)
   meanVs = meanVs/real(n)
   !  Isotropic properties
   Vp_temp = 1._8/meanVp * 1000._8  ! CIJ_phasevels outputs in km/s, not m/s
   Vs_temp = 1._8/meanVs * 1000._8
   if (present(Vp)) Vp = Vp_temp
   if (present(Vs)) Vs = Vs_temp
   
   !  Construct elasticity tensor
   if (present(Ciso)) then
      Ciso(1,1) = Vp_temp**2  ; Ciso(2,2) = Ciso(1,1)  ;  Ciso(3,3) = Ciso(1,1)
      Ciso(4,4) = Vs_temp**2  ; Ciso(5,5) = Ciso(4,4)  ;  Ciso(6,6) = Ciso(4,4)
      Ciso(1,2) = Ciso(1,1) - 2._8*Ciso(4,4)
      Ciso(1,3) = Ciso(1,2)  ;  Ciso(2,3) = Ciso(1,2)
      
      !  Make symmetrical
      do i=1,6
         do j=i,6
            if (i /= j) Ciso(j,i) = Ciso(i,j)
         enddo
      enddo
   endif
   
end subroutine CIJ_isotropic_average
!-------------------------------------------------------------------------------
   
!===============================================================================
subroutine sphere_sample_local(lon,lat)
!===============================================================================
      implicit none
      
      real(8),dimension(:) :: lon,lat
      
      lon(1) = 0.0000000  ; lat(1) = 90.000000
      lon(2) = 0.0000000  ; lat(2) = 80.000000
      lon(3) = 57.587700  ; lat(3) = 80.000000
      lon(4) = 115.17540  ; lat(4) = 80.000000
      lon(5) = 172.76309  ; lat(5) = 80.000000
      lon(6) = 230.35080  ; lat(6) = 80.000000
      lon(7) = 287.93851  ; lat(7) = 80.000000
      lon(8) = 43.113922  ; lat(8) = 70.000000
      lon(9) = 72.351967  ; lat(9) = 70.000000
      lon(10) = 101.59001  ; lat(10) = 70.000000
      lon(11) = 130.82805  ; lat(11) = 70.000000
      lon(12) = 160.06609  ; lat(12) = 70.000000
      lon(13) = 189.30412  ; lat(13) = 70.000000
      lon(14) = 218.54216  ; lat(14) = 70.000000
      lon(15) = 247.78020  ; lat(15) = 70.000000
      lon(16) = 277.01825  ; lat(16) = 70.000000
      lon(17) = 306.25629  ; lat(17) = 70.000000
      lon(18) = 335.49432  ; lat(18) = 70.000000
      lon(19) = 4.7323608  ; lat(19) = 70.000000
      lon(20) = 63.208450  ; lat(20) = 60.000000
      lon(21) = 83.208450  ; lat(21) = 60.000000
      lon(22) = 103.20845  ; lat(22) = 60.000000
      lon(23) = 123.20845  ; lat(23) = 60.000000
      lon(24) = 143.20845  ; lat(24) = 60.000000
      lon(25) = 163.20845  ; lat(25) = 60.000000
      lon(26) = 183.20845  ; lat(26) = 60.000000
      lon(27) = 203.20845  ; lat(27) = 60.000000
      lon(28) = 223.20845  ; lat(28) = 60.000000
      lon(29) = 243.20845  ; lat(29) = 60.000000
      lon(30) = 263.20844  ; lat(30) = 60.000000
      lon(31) = 283.20844  ; lat(31) = 60.000000
      lon(32) = 303.20844  ; lat(32) = 60.000000
      lon(33) = 323.20844  ; lat(33) = 60.000000
      lon(34) = 343.20844  ; lat(34) = 60.000000
      lon(35) = 3.2084351  ; lat(35) = 60.000000
      lon(36) = 23.208435  ; lat(36) = 60.000000
      lon(37) = 43.208435  ; lat(37) = 60.000000
      lon(38) = 83.208435  ; lat(38) = 50.000000
      lon(39) = 98.765671  ; lat(39) = 50.000000
      lon(40) = 114.32291  ; lat(40) = 50.000000
      lon(41) = 129.88014  ; lat(41) = 50.000000
      lon(42) = 145.43738  ; lat(42) = 50.000000
      lon(43) = 160.99461  ; lat(43) = 50.000000
      lon(44) = 176.55185  ; lat(44) = 50.000000
      lon(45) = 192.10909  ; lat(45) = 50.000000
      lon(46) = 207.66632  ; lat(46) = 50.000000
      lon(47) = 223.22356  ; lat(47) = 50.000000
      lon(48) = 238.78079  ; lat(48) = 50.000000
      lon(49) = 254.33803  ; lat(49) = 50.000000
      lon(50) = 269.89526  ; lat(50) = 50.000000
      lon(51) = 285.45251  ; lat(51) = 50.000000
      lon(52) = 301.00977  ; lat(52) = 50.000000
      lon(53) = 316.56702  ; lat(53) = 50.000000
      lon(54) = 332.12427  ; lat(54) = 50.000000
      lon(55) = 347.68152  ; lat(55) = 50.000000
      lon(56) = 3.2387695  ; lat(56) = 50.000000
      lon(57) = 18.796007  ; lat(57) = 50.000000
      lon(58) = 34.353245  ; lat(58) = 50.000000
      lon(59) = 49.910484  ; lat(59) = 50.000000
      lon(60) = 65.467720  ; lat(60) = 50.000000
      lon(61) = 96.582191  ; lat(61) = 40.000000
      lon(62) = 109.63626  ; lat(62) = 40.000000
      lon(63) = 122.69034  ; lat(63) = 40.000000
      lon(64) = 135.74442  ; lat(64) = 40.000000
      lon(65) = 148.79849  ; lat(65) = 40.000000
      lon(66) = 161.85257  ; lat(66) = 40.000000
      lon(67) = 174.90665  ; lat(67) = 40.000000
      lon(68) = 187.96072  ; lat(68) = 40.000000
      lon(69) = 201.01480  ; lat(69) = 40.000000
      lon(70) = 214.06888  ; lat(70) = 40.000000
      lon(71) = 227.12296  ; lat(71) = 40.000000
      lon(72) = 240.17703  ; lat(72) = 40.000000
      lon(73) = 253.23111  ; lat(73) = 40.000000
      lon(74) = 266.28519  ; lat(74) = 40.000000
      lon(75) = 279.33926  ; lat(75) = 40.000000
      lon(76) = 292.39334  ; lat(76) = 40.000000
      lon(77) = 305.44742  ; lat(77) = 40.000000
      lon(78) = 318.50150  ; lat(78) = 40.000000
      lon(79) = 331.55557  ; lat(79) = 40.000000
      lon(80) = 344.60965  ; lat(80) = 40.000000
      lon(81) = 357.66373  ; lat(81) = 40.000000
      lon(82) = 10.717804  ; lat(82) = 40.000000
      lon(83) = 23.771877  ; lat(83) = 40.000000
      lon(84) = 36.825951  ; lat(84) = 40.000000
      lon(85) = 49.880024  ; lat(85) = 40.000000
      lon(86) = 62.934097  ; lat(86) = 40.000000
      lon(87) = 75.988174  ; lat(87) = 40.000000
      lon(88) = 89.042252  ; lat(88) = 40.000000
      lon(89) = 115.15041  ; lat(89) = 30.000000
      lon(90) = 126.69741  ; lat(90) = 30.000000
      lon(91) = 138.24442  ; lat(91) = 30.000000
      lon(92) = 149.79143  ; lat(92) = 30.000000
      lon(93) = 161.33844  ; lat(93) = 30.000000
      lon(94) = 172.88545  ; lat(94) = 30.000000
      lon(95) = 184.43246  ; lat(95) = 30.000000
      lon(96) = 195.97948  ; lat(96) = 30.000000
      lon(97) = 207.52649  ; lat(97) = 30.000000
      lon(98) = 219.07350  ; lat(98) = 30.000000
      lon(99) = 230.62051  ; lat(99) = 30.000000
      lon(100) = 242.16753  ; lat(100) = 30.000000
      lon(101) = 253.71454  ; lat(101) = 30.000000
      lon(102) = 265.26154  ; lat(102) = 30.000000
      lon(103) = 276.80853  ; lat(103) = 30.000000
      lon(104) = 288.35553  ; lat(104) = 30.000000
      lon(105) = 299.90253  ; lat(105) = 30.000000
      lon(106) = 311.44952  ; lat(106) = 30.000000
      lon(107) = 322.99652  ; lat(107) = 30.000000
      lon(108) = 334.54352  ; lat(108) = 30.000000
      lon(109) = 346.09052  ; lat(109) = 30.000000
      lon(110) = 357.63751  ; lat(110) = 30.000000
      lon(111) = 9.1845093  ; lat(111) = 30.000000
      lon(112) = 20.731514  ; lat(112) = 30.000000
      lon(113) = 32.278519  ; lat(113) = 30.000000
      lon(114) = 43.825523  ; lat(114) = 30.000000
      lon(115) = 55.372528  ; lat(115) = 30.000000
      lon(116) = 66.919533  ; lat(116) = 30.000000
      lon(117) = 78.466537  ; lat(117) = 30.000000
      lon(118) = 90.013542  ; lat(118) = 30.000000
      lon(119) = 101.56055  ; lat(119) = 30.000000
      lon(120) = 124.65456  ; lat(120) = 20.000000
      lon(121) = 135.29633  ; lat(121) = 20.000000
      lon(122) = 145.93811  ; lat(122) = 20.000000
      lon(123) = 156.57990  ; lat(123) = 20.000000
      lon(124) = 167.22168  ; lat(124) = 20.000000
      lon(125) = 177.86346  ; lat(125) = 20.000000
      lon(126) = 188.50525  ; lat(126) = 20.000000
      lon(127) = 199.14703  ; lat(127) = 20.000000
      lon(128) = 209.78882  ; lat(128) = 20.000000
      lon(129) = 220.43060  ; lat(129) = 20.000000
      lon(130) = 231.07239  ; lat(130) = 20.000000
      lon(131) = 241.71417  ; lat(131) = 20.000000
      lon(132) = 252.35596  ; lat(132) = 20.000000
      lon(133) = 262.99774  ; lat(133) = 20.000000
      lon(134) = 273.63953  ; lat(134) = 20.000000
      lon(135) = 284.28131  ; lat(135) = 20.000000
      lon(136) = 294.92310  ; lat(136) = 20.000000
      lon(137) = 305.56488  ; lat(137) = 20.000000
      lon(138) = 316.20667  ; lat(138) = 20.000000
      lon(139) = 326.84845  ; lat(139) = 20.000000
      lon(140) = 337.49023  ; lat(140) = 20.000000
      lon(141) = 348.13202  ; lat(141) = 20.000000
      lon(142) = 358.77380  ; lat(142) = 20.000000
      lon(143) = 9.4155884  ; lat(143) = 20.000000
      lon(144) = 20.057365  ; lat(144) = 20.000000
      lon(145) = 30.699142  ; lat(145) = 20.000000
      lon(146) = 41.340919  ; lat(146) = 20.000000
      lon(147) = 51.982697  ; lat(147) = 20.000000
      lon(148) = 62.624474  ; lat(148) = 20.000000
      lon(149) = 73.266251  ; lat(149) = 20.000000
      lon(150) = 83.908028  ; lat(150) = 20.000000
      lon(151) = 94.549805  ; lat(151) = 20.000000
      lon(152) = 105.19158  ; lat(152) = 20.000000
      lon(153) = 115.83336  ; lat(153) = 20.000000
      lon(154) = 137.11691  ; lat(154) = 10.000000
      lon(155) = 147.27118  ; lat(155) = 10.000000
      lon(156) = 157.42545  ; lat(156) = 10.000000
      lon(157) = 167.57971  ; lat(157) = 10.000000
      lon(158) = 177.73398  ; lat(158) = 10.000000
      lon(159) = 187.88824  ; lat(159) = 10.000000
      lon(160) = 198.04251  ; lat(160) = 10.000000
      lon(161) = 208.19678  ; lat(161) = 10.000000
      lon(162) = 218.35104  ; lat(162) = 10.000000
      lon(163) = 228.50531  ; lat(163) = 10.000000
      lon(164) = 238.65958  ; lat(164) = 10.000000
      lon(165) = 248.81384  ; lat(165) = 10.000000
      lon(166) = 258.96811  ; lat(166) = 10.000000
      lon(167) = 269.12238  ; lat(167) = 10.000000
      lon(168) = 279.27664  ; lat(168) = 10.000000
      lon(169) = 289.43091  ; lat(169) = 10.000000
      lon(170) = 299.58517  ; lat(170) = 10.000000
      lon(171) = 309.73944  ; lat(171) = 10.000000
      lon(172) = 319.89371  ; lat(172) = 10.000000
      lon(173) = 330.04797  ; lat(173) = 10.000000
      lon(174) = 340.20224  ; lat(174) = 10.000000
      lon(175) = 350.35651  ; lat(175) = 10.000000
      lon(176) = 0.51077271 ; lat(176) = 10.000000
      lon(177) = 10.665038  ; lat(177) = 10.000000
      lon(178) = 20.819304  ; lat(178) = 10.000000
      lon(179) = 30.973568  ; lat(179) = 10.000000
      lon(180) = 41.127834  ; lat(180) = 10.000000
      lon(181) = 51.282101  ; lat(181) = 10.000000
      lon(182) = 61.436367  ; lat(182) = 10.000000
      lon(183) = 71.590630  ; lat(183) = 10.000000
      lon(184) = 81.744896  ; lat(184) = 10.000000
      lon(185) = 91.899162  ; lat(185) = 10.000000
      lon(186) = 102.05343  ; lat(186) = 10.000000
      lon(187) = 112.20770  ; lat(187) = 10.000000
      lon(188) = 122.36196  ; lat(188) = 10.000000
      lon(189) = 142.67049  ; lat(189) = 0.0000000
      lon(190) = 152.67049  ; lat(190) = 0.0000000
      lon(191) = 162.67049  ; lat(191) = 0.0000000
      lon(192) = 172.67049  ; lat(192) = 0.0000000
      lon(193) = 182.67049  ; lat(193) = 0.0000000
      lon(194) = 192.67049  ; lat(194) = 0.0000000
      lon(195) = 202.67049  ; lat(195) = 0.0000000
      lon(196) = 212.67049  ; lat(196) = 0.0000000
      lon(197) = 222.67049  ; lat(197) = 0.0000000
      lon(198) = 232.67049  ; lat(198) = 0.0000000
      lon(199) = 242.67049  ; lat(199) = 0.0000000
      lon(200) = 252.67049  ; lat(200) = 0.0000000
      lon(201) = 262.67047  ; lat(201) = 0.0000000
      lon(202) = 272.67047  ; lat(202) = 0.0000000
      lon(203) = 282.67047  ; lat(203) = 0.0000000
      lon(204) = 292.67047  ; lat(204) = 0.0000000
      lon(205) = 302.67047  ; lat(205) = 0.0000000
      lon(206) = 312.67047  ; lat(206) = 0.0000000
      lon(207) = 322.67047  ; lat(207) = 0.0000000
      lon(208) = 332.67047  ; lat(208) = 0.0000000
      lon(209) = 342.67047  ; lat(209) = 0.0000000
      lon(210) = 352.67047  ; lat(210) = 0.0000000
      lon(211) = 2.6704712  ; lat(211) = 0.0000000
      lon(212) = 12.670471  ; lat(212) = 0.0000000
      lon(213) = 22.670471  ; lat(213) = 0.0000000
      lon(214) = 32.670471  ; lat(214) = 0.0000000
      lon(215) = 42.670471  ; lat(215) = 0.0000000
      lon(216) = 52.670471  ; lat(216) = 0.0000000
      lon(217) = 62.670471  ; lat(217) = 0.0000000
      lon(218) = 72.670471  ; lat(218) = 0.0000000
      lon(219) = 82.670471  ; lat(219) = 0.0000000
      lon(220) = 92.670471  ; lat(220) = 0.0000000
      lon(221) = 102.67047  ; lat(221) = 0.0000000
      lon(222) = 112.67047  ; lat(222) = 0.0000000
      lon(223) = 122.67047  ; lat(223) = 0.0000000
      lon(224) = 132.67047  ; lat(224) = 0.0000000
      
end subroutine sphere_sample_local
!-------------------------------------------------------------------------------
