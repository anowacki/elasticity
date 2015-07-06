#!/bin/bash
# Display 21 or 36 ecs in a nice 6x6 grid.

usage () {
	{
		echo "Usage: `basename $0` (density) < (36|21 ecs from stdin)"
		echo "Displays elastic constants in a nice 6x6 matrix."
		echo "If supplied, use first argument as density to normalise constants."
	} 1>&2
	exit 1
}

# Default to density-noramlised constants
r=1

# Optionally supply density as argument by which to multiply
if [ $# -eq 1 ]; then 
	r=$1
fi

# If the first argument isn't a valid number, assume we want the usage
[ $# -ge 1 ] && { printf "%f" "$1" >/dev/null 2>&1 || usage; }

awk -v r=$r '
	function abs(x) { return x > 0 ? x : -x }

	$1 != "#" && $1 != "%" {

		# 36 ECs or 36 ECs with density
		if (NF == 36  || NF == 37) {
			if (NF == 37 && r == 1) r = $37
			l = 1
			for (i=1; i<=6; i++) {
				for (j=1; j<=6; j++){
					c[i,j] = r*$l
					if (abs(c[i,j]) > max || (i == 1 && j == 1)) max = c[i,j]  # Find maximum value
					l += 1
				}
			}
		}

		# 21 ECs or 21 ECs with density
		if (NF == 21 || NF == 22) {
			if (NF == 22 && r == 1) r = $22
			l = 1
			for (i=1; i<=6; i++) {
				for (j=i; j<=6; j++) {
					c[i,j] = r*$l
					c[j,i] = c[i,j]
					if (abs(c[i,j]) > max || (i == 1 && j == 1)) max = c[i,j]
					l += 1
				}
			}
		}

		if (NF != 36 && NF != 37 && NF != 21 && NF != 22) {  # Incorrect input
			print "CIJ_disp: Must supply a line of 36 or 21 elastic constants "\
				"(optionally with density in last column)." > "/dev/stderr"
			error = 1
			exit 2
		}

		# Scale the constants for display purposes
		pow = int(log(max)/log(10))
		if (max == 0) pow = 0
		printf("x 10^%d:\n",pow)
		for (i=1; i<=6; i++) {
			printf("  ")
			for (j=1; j<=6; j++) {
				if (abs(c[i,j]/(10**pow)) < 1e-10) {
					printf("      0  ")
				} else {
					printf("%7.4f  ",c[i,j]/(10**pow))
				}
				if (j == 6) printf("\n")
			}
		}
		if (NF==22 || NF == 37) printf("Density: %6.2f kg/m^3\n", r)
	}
	END {
		if (error == 1) exit 2		
		exit 0
	}' /dev/stdin

# Return exit code from awk script
success=$?

exit $success
