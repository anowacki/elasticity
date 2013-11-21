program EC_grid_21to36

   use EC_grid
   
   implicit none
   
   type(ECgrid) :: grid
   character(len=250) :: fname
   real               :: test_36(6,6),test_21(3,7)
   integer            :: iostatus,necs,a,b,c
   
   if (command_argument_count() /= 2) then
	  write(0,'(a)') 'Usage: 21to36 [ECxyz file 1] [ECxyz file 2]'
	  stop
   endif
   
   call get_command_argument(1,fname)
   
! Test for which way round the input file is
   open(10,file=fname,status='old')
   read(10,fmt=*,iostat=iostatus) a,b,c,test_21
   if (iostatus == 0) necs = 21
   rewind(10)
   read(10,fmt=*,iostat=iostatus) a,b,c,test_36
   if (iostatus == 0) necs = 36
   if (iostatus < 0) then
	  continue
   else if (iostatus > 0) then
	  write(0,*) 'There are more than 36 ECs in input file.'
	  stop
   endif
   close(10)
   
!  Read in ecs
   call EC_grid_load(trim(fname),grid,necs=necs,quiet=.true.)
   
!  Swap output format
   if (necs==21) then
	  necs=36
   else if (necs==36) then
	  necs=21
   endif
   
!  Write out to the new file
   call get_command_argument(2,fname)
   call EC_grid_write(trim(fname),grid,necs=necs)


end program EC_grid_21to36
