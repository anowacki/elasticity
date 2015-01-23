#!/bin/bash
# CIJ_sphere.bash
# Shell script to plot phase velocity surfaces for elastic constants on a sphere
# with the viewpoint of one's choosing

###############################################
# CIJ_plot_cij2phasevels must be in your PATH #
###############################################

usage () {
	{
	echo "`basename $0`: Plots phase velocity surfaces for sets of elastic constants."
	echo "Usage: `basename $0` (-r density (.ecs file))"
	echo "Options:"
	echo "  -P|-S                   : Show P wave velocity or S wave anisotropy sphere. (S)"
	echo "  -a [azi inc]            : Set viepoint: azimuth is in CIJ_phasevels"
	echo "                            convention (az x1->-x2; inc x1x2->x3) (45 30)"
	echo "  -b(atch)                : Don't display plot for batch plotting. (display)"
	echo "  -c(pt) [colour palette] : Choose alternative colour palette."
	echo "                            Must be inbuilt to GMT. (wysiwyg)"
	echo "  -h(elp)                 : Print this message."
	echo "  -d [azi inc label]      : Mark a point on the sphere with a label."
	echo "  -n [no. contours]       : Number of contours (10)"
	echo "  -noaxes                 : Don't plot principal axes. (plot)"
	echo "  -norm(alise)            : Input ecs require density normalisation."
	echo "  -o [outfile]            : Send output to output file. (temporary file)"
	echo "  -s(cale) [(vp1 vp2)|(avs1 avs2)] : Set limits on colour scale.  (automatic)"
	# echo "  -t(itle) [title string] : Set title for plot, including GMT codes. (none)"
	echo "  Density can be determined from .ecs file or specified.  Must be determined"
	echo "  for list input either on command line with -r, or as last value on stdin."
	} > /dev/stderr
	exit 1
}

# Wrapper function to make a temporary file with the desired suffix and exit the
# script if we can't do so.
make_temp_file () {
	[ $# -ne 1 ] && echo "`basename $0`: make_temp_file: Require name of temp file" &&
		exit 2
	local f=$(mktemp /tmp/CIJ_plot."$1"XXXXXX) ||
		{ echo "`basename $0`: make_temp_file: Can't create file $f"; exit 3; }
	echo $f
}

WIDTH=5
vlength=0.3 # / cm

# Defaults
lower=0  # Upper hemisphere
scale=0  # Automatic scale
list=1   # Read from stdin
PROJ=G   # Projection always G
nlevels=10 # Numver of contours
cmap=wysiwyg # Colour palette
S=1      # S wave anisotropy sphere
inc=30   # View incidence up from x1-x2 plane towards x3
azi=45   # View azimuth from x1 towards x2
nd=0     # No additional directions plotted

# Get options and density
while [ -n "$1" ]; do
	case "$1" in
		-P)
			p=1
			shift
			;;
		-S)
			unset p
			shift
			;;
		-a)
			azi="$2"
			inc="$3"
			shift 3
			;;
		-b|-batch)
			batch=1
			shift
			;;
		-c|-cpt)
			cmap=$2
			shift 2
			;;
		-d)
			((nd++))
			dazi[nd]="$2"
			dinc[nd]="$3"
			dlabel[nd]="$4"
			shift 4
			;;
		-h|-help|--help)
			usage
			;;
		-s|-scale)
			scale=1
			vp1=$2
			vp2=$3
			avs1=$2
			avs2=$3
			shift 3
			;;
		-t|-title)
			title="$2"
			shift 2
			;;
		-o)
			FIG="$2"
			OUTPUT=1
			shift 2
			;;
		-r)
			rho=$2
			shift 2
			;;
		-noaxes)
			noaxes=1
			shift
			;;
		-n|-nlevels)
			nlevels=$2
			shift 2
			;;
		-norm|-normalise)
			normalise=1
			shift
			;;
		*)
			list=0
			file=$1
			if ! [ -r "$1" ]; then
				echo "`basename $0`: unrecognised option or can't read file: $1" > /dev/stderr
				usage
				exit 2
			fi
			shift
			;;
	esac
done

# Set FIG to a temp file if not otherwise set
[ -z "$FIG" ] && FIG=`make_temp_file ps`

# Don't flip the seismic colourmap
flip="-I"
if [[ "$cmap" == "seis" ]]; then
	flip=""
fi

# Produce values for phase velocity surface
if [ $list -eq 0 ]; then  # Single .ecs file entry
	ecs=`ecs2ij $file`
else                      # Single set of ecs from stdin
	ecs=`cat /dev/stdin | head -n1`
fi

# If we have 37 numbers on stdin, the last is density.  Override this with -r option.
if [ $list -eq 1 ]; then
	necs=`echo $ecs | wc -w`
	if [ $necs -eq 37 -a -z "$rho" ]; then
		rho=`echo $ecs | awk '{print $NF}'`
		ecs=`echo $ecs | awk '{$NF=""; print}'`
	elif [ $necs -eq 36 -a -z "$rho" ]; then
		echo "`basename $0`: rho must be found on stdin (last value), in .ecs file, or with -r [rho]." > /dev/stderr
		exit 5
	fi
fi

# If no r supplied and we aren't reading from a .ecs file, stop
if [ $list -eq 1 -a -z "$rho" ]; then
	echo "`basename $0`: must either use rho of .ecs file or specify if reading ecs from stdin." > /dev/stderr
	exit 5
elif [ $list -eq 0 -a -z "$rho" ]; then   # Taking rho from .ecs file
	rho=`awk '$1==7&&$2==7{print $3}' $file`
	echo "Density: $rho kg/m^3"
fi

# If required, normalise by density
if [ -n "$normalise" ]; then
	ecs=`echo $ecs | awk -v r=$rho '{for (i=1;i<=NF;i++) printf("%s ",$i*r)}'`
fi

# Get projection
azi=$(echo "-1*$azi" | bc -l)
PROJ=${PROJ}${azi}/${inc}/${WIDTH}c

# Set up common temp files
CPT=`make_temp_file cpt`
GRD=`make_temp_file grd`
  S=`make_temp_file S`
  F=`make_temp_file F`
  P=`make_temp_file P`
trap "rm -f $P $S $F $CPT $GRD" EXIT

# Start of postscript
psxy -J${PROJ} -Rd -K -T -P 2>&1 > "$FIG" | grep -v "Warning"

########################################
# P wave velocity plot
if [ $p ]; then

	echo "$ecs $rho" | CIJ_plot_cij2phasevels PS > $P

	min=`tail -n1 $P | awk '{printf("%0.2e", $2*0.99)}'`
	max=`tail -n1 $P | awk '{printf("%0.2e", $3*1.01)}'`
	AVp=`tail -n1 $P | awk '{printf("%0.1f", 200*($3-$2)/($2+$3) )}'`
	if [ $scale -eq 1 ]; then # Have defined scale
		d=`echo $vp2 $vp1 $nlevels | awk '{printf("%0.1e",($1-$2)/$3)}'`
		makecpt -C${cmap} -T$vp1/$vp2/$d $flip > $CPT
	else                     # Automatic scale
		d=`echo $max $min $nlevels | awk '{printf("%0.1e",($1-$2)/$3)}'`
		makecpt -C${cmap} -T$min/$max/$d $flip > $CPT
	fi
	grep -v ">" $P | surface -G$GRD -Rd -I1

	grdimage $GRD -J${PROJ} -Rd -C$CPT -Bnsew -O -K >> "$FIG" 2>/dev/null
	psscale -C$CPT -D`echo $WIDTH*1.05 | bc -l`c/`echo $WIDTH/2 | bc -l`c/${WIDTH}c/0.3c \
		-B/:"@%2%V@%%@-P@- / km s@+-1": -O -K >> "$FIG"
	

#######################################
# S wave anisotropy plot
else
	
	echo "$ecs $rho" | CIJ_plot_cij2phasevels SS > $S
	echo "$ecs $rho" | CIJ_plot_cij2phasevels FS > $F
	min=`tail -n1 $S | awk '{printf("%0.2e", $2*0.95)}'`
	max=`tail -n1 $S | awk '{printf("%0.2e", $3*1.05)}'`
	if [ $scale -eq 1 ]; then
		d=`echo $avs2 $avs1 $nlevels | awk '{printf("%0.1e",($1-$2)/$3)}'` #`echo "($max-$min)/10" | bc -l`
		makecpt -C${cmap} -T$avs1/$avs2/$d $flip > $CPT
	else
		d=`echo $max $min $nlevels | awk '{printf("%0.1e",($1-$2)/$3)}'` #`echo "($max-$min)/10" | bc -l`
		makecpt -C${cmap} -T$min/$max/$d $flip > $CPT
	fi

	grep -v ">" $S | surface -G$GRD -Rd -I1

	grdimage $GRD -J${PROJ} -Rd -C$CPT -Bnsew -O -K >> "$FIG" 2>/dev/null
	psscale -C$CPT -D`echo $WIDTH*1.05 | bc -l`c/`echo $WIDTH/2 | bc -l`c/${WIDTH}c/0.3c \
		-B/:"A@%2%V@%%@-S@- / %": -O -K >> "$FIG"
	# echo "0 0 12 0 0 CM A@%2%V@%%@-S@- / %" |\
	# 	pstext -J -R -N -O -K -D0/`echo 0.15*$WIDTH | bc -l`c >> "$FIG"

	# S fast orientation plot
	awk -v s=$vlength 'NF==3{print $0,s "c"}' $F |\
		psxy -J -R -SVB0.08c/0/0 -Gblack -W0.005c,white -O -K 2>&1 >> "$FIG" |
		# Don't output warnings about not being able to plot the whole world
		# when we're looking at the poles
		grep -v "Warning"
	
fi

####################################
# Principal axes if desired
if [ -z "$noaxes" ]; then
	dirs=`awk -v azi=$azi -v inc=$inc '
		function abs(x) {return (x>0) ? x : -x}
		# Plot either + or - each axis depending on what view we are using
		BEGIN {
			if (inc >= 0) print "  0  90 10 0 0 CB  @%2%x@%%@-3"
			if (inc <  0) print "  0 -90 10 0 0 CB -@%2%x@%%@-3"
			
			azi = (azi+3600+180)%360 - 180  # In range -180 to 180
			if (azi >= 0) print " 90   0 10 0 0 CB  @%2%x@%%@-2"
			if (azi <  0) print "-90   0 10 0 0 CB -@%2%x@%%@-2"
			if (abs(azi) <= 90) print "  0   0 10 0 0 CB  @%2%x@%%@-1"
			if (abs(azi) >  90) print "  0 180 10 0 0 CB -@%2%x@%%@-1"
		}'`
	echo "$dirs" |
	psxy -J -R -O -K -Ss0.2c -Gwhite -W0.5p -N 2>&1 >> "$FIG" | grep -v "Warning"
	echo "$dirs" |
	pstext -J -R -O -K -D0/0.25c -Wwhite -N 2>&1 >> "$FIG" | grep -v "Warning"
fi

####################################
# Additional directional labels
for ((i=1; i<=nd; i++)); do
	echo $(echo "-1*${dazi[i]}" | bc -l) ${dinc[i]} |
		psxy -J -R -O -K -Sc0.3c -Gyellow -W0.5p -N 2>&1 >> "$FIG" | grep -v "Warning"
	echo $(echo "-1*${dazi[i]}" | bc -l) ${dinc[i]} 11 0 0 CB "${dlabel[i]}" |
		pstext -J -R -O -K -D0/0.25c -Wwhite -N 2>&1 >> "$FIG" | grep -v "Warning"
done

# Finalise Postscript
psxy -J -R -O -T 2>&1 >> "$FIG" | grep -v "Warning"

[ -z "$batch" ] && gv "$FIG" 2>/dev/null

[ -z $OUTPUT ] && /bin/rm -f "$FIG"

exit 0
