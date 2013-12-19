#!/bin/bash
# CIJ_plot.bash
# Shell script to plot phase velocity surfaces for elastic constants.
# Usage:
#		CIJ_plot [-lower] [-scale vpmin vpmax avsmin avsmax] [-r density] [.ecs file]

##########################################
# Set path to CIJ_plot_cij2phasevels here:
BINDIR=~nowacki/Applications/Elasticity/CIJ_plot/src/
##########################################

usage () {
	{
	echo "`basename $0`: Plots phase velocity surfaces for sets of elastic constants."
	echo "Usage: `basename $0` (-r density (.ecs file))"
	echo "Options:"
	echo "	-b(atch)                : Don't display plot for batch plotting. (display)"
	echo "	-c(pt) [colour palette] : Choose alternative colour palette."
	echo "	                          Must be inbuilt to GMT. (wysiwyg)"
	echo "	-h(elp)                 : Print this message."
# Not implemented yet
#	echo "	-l(ower)                : Plot lower hemsiphere (upper)"
	echo "	-n [no. contours]       : Number of contours (10)"
	echo "	-norm(alise)            : Input ecs require density normalisation."
	echo "	-o [outfile]            : Send output to output file. (temporary file)"
	echo "	-p(roj) [projection]    : GMT code for projection (of A,E,G). (A)"
	echo "	-s(cale) [vp1 vp2 avs1 avs2] : Set limits on colour scale.  (automatic)"
	echo "  -t(itle) [title string] : Set title for plot, including GMT codes. (none)"
	echo "	Density can be determined from .ecs file or specified.  Must be determined"
	echo "	for list input either on command line with -r, or as last value on stdin."
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
PROJ=A   # Projections
nlevels=10 # Numver of contours
cmap=wysiwyg # Colour palette

# Get options and density
while [ -n "$1" ]; do
	case "$1" in
		-b|-batch)
			batch=1
			shift
			;;
		-c|-cpt)
			cmap=$2
			shift 2
			;;
# 		-l|-lower)  # Plot lower hemisphere, not upper
# 			lower=1
# 			shift
# 			;;
		-s|-scale)
			scale=1
			vp1=$2
			vp2=$3
			avs1=$4
			avs2=$5
			shift 5
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
		-p|-proj)
			if [[ "$2" != "A" && "$2" != "E" && "$2" != "G" ]]; then
				echo "Must specify one of [A,E,G] for projection type" > /dev/stderr
				echo "'G' gives the CIJ_plot traditional view." > /dev/stderr
				exit 3
			fi
			PROJ=$2
			shift 2
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

########################################
# P wave velocity plot
# rm -rf /tmp/CIJ_plot_*.{ps,P,S,F,cpt,grd}
  P=`make_temp_file P`
  S=`make_temp_file S`
  F=`make_temp_file F`
CPT=`make_temp_file cpt`
GRD=`make_temp_file grd`
trap "rm -f $P $S $F $CPT $GRD" EXIT

echo "$ecs $rho" | ${BINDIR}/CIJ_plot_cij2phasevels P > $P
echo "$ecs $rho" | ${BINDIR}/CIJ_plot_cij2phasevels S > $S
echo "$ecs $rho" | ${BINDIR}/CIJ_plot_cij2phasevels F > $F

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
awk 'NF==3' $P | surface -G$GRD -Rd -I1

grdimage $GRD -J${PROJ}0/0/${WIDTH}c -R-90/90/-90/90 -C$CPT -B90 -K -P > "$FIG" 2>/dev/null
psscale -C$CPT -D`echo $WIDTH*1.05 | bc -l`c/`echo $WIDTH/2 | bc -l`c/${WIDTH}c/0.3c \
	-O -K >> "$FIG"
echo "0 90 12 0 0 CM @%2%V@%%@-P@-@_ / km s@+-1" |\
	pstext -J -R -N -O -K -D0/`echo 0.15*$WIDTH | bc -l`c >> "$FIG"
echo "0 90 10 0 0 CM @%2%x@%%@-1" | pstext -J -R -O -K -N -D0/`echo 0.05*$WIDTH | bc -l`c >> "$FIG"
echo "-90 0 10 0 0 CM @%2%x@%%@-2" | pstext -J -R -O -K -N -D-`echo 0.05*$WIDTH | bc -l`c/0 >> "$FIG"
echo "0 0 10 0 0 BL $AVp %" | pstext -J -R -O -K -N -D-`echo 0.5*$WIDTH | bc -l`c >> "$FIG"

#######################################
# S wave velocity and fast shear wave plot
min=`tail -n1 $S | awk '{printf("%0.2e", $2*0.95)}'`
max=`tail -n1 $S | awk '{printf("%0.2e", $3*1.05)}'`
if [ $scale -eq 1 ]; then
	d=`echo $avs2 $avs1 $nlevels | awk '{printf("%0.1e",($1-$2)/$3)}'` #`echo "($max-$min)/10" | bc -l`
	makecpt -C${cmap} -T$avs1/$avs2/$d $flip > $CPT
else
	d=`echo $max $min $nlevels | awk '{printf("%0.1e",($1-$2)/$3)}'` #`echo "($max-$min)/10" | bc -l`
	makecpt -C${cmap} -T$min/$max/$d $flip > $CPT
fi
awk 'NF==3' $S | surface -G$GRD -Rd -I1

grdimage $GRD -X`echo ${WIDTH}*1.5 | bc -l`c -J -R -C$CPT -B90 -O -K >> "$FIG" 2>/dev/null
psscale -C$CPT -D`echo $WIDTH*1.05 | bc -l`c/`echo $WIDTH/2 | bc -l`c/${WIDTH}c/0.3c \
	-O -K >> "$FIG"
echo "0 90 12 0 0 CM A@%2%V@%%@-S@- / %" |\
	pstext -J -R -N -O -K -D0/`echo 0.15*$WIDTH | bc -l`c >> "$FIG"


# S fast orientation plot
awk -v s=$vlength 'NF==3{print $0,s "c"}' $F |\
	psxy -J -R -SvB0.08c/0/0 -Gblack -W0.005c,white -N -O -K >> "$FIG"

######################################
# Title
[ -n "$title" ] && echo "0 90 13 0 0 CM $title" |
	pstext -D`echo "-${WIDTH}*0.75" | bc -l`c/`echo "0.3*$WIDTH" | bc -l`c -J -R -O -K -N >> "$FIG"

# Finalise Postscript
psxy -J -R -O -T >> "$FIG"

[ -z "$batch" ] && gv "$FIG" 2>/dev/null

[ -z $OUTPUT ] && /bin/rm -f "$FIG"

exit 0
