#!/bin/bash
# Display 21 or 36 ecs in a nice 6x6 grid.

# Default to density-noramlised constants
r=1

# Optionally supply density as argument by which to multiply
if [ $# -eq 1 ]; then 
	r=$1
fi

if [ $# -gt 1 ]; then
	echo "`basename $0`: Display a line of 21 or 36 elastic constants in a 6x6 matrix." > /dev/stderr
	exit 1
fi

awk -v r=$r '
	NF == 36 {
		l = 1
		for (i=1; i<=6; i++) {
			for (j=1; j<=6; j++){
				c[i,j] = r*$l
				if (c[i,j] > max) max = c[i,j]  # Find maximum value
				l += 1
			}
		}
	}
	
	NF == 21 {
		l = 1
		for (i=1; i<=6; i++) {
			for (j=i; j<=6; j++) {
				c[i,j] = r*$l
				c[j,i] = c[i,j]
				if (c[i,j] > max) max = c[i,j]
				l += 1
			}
		}
	}
	
	NF != 36 && NF != 21 {  # Incorrect input
		print "CIJ_disp: Must supply a line of 36 or 21 elastic constants." > "/dev/stderr"
		error = 1
		exit 2
	}
	
	END {
		if (error == 1) exit 2
		# Scale the constants for display purposes
		pow = int(log(max)/log(10))
		printf("x 10^%d:\n",pow)
		
		for (i=1; i<=6; i++) {
			printf("  ")
			for (j=1; j<=6; j++) {
				if (c[i,j]/(10**pow) < 1e-10) {
					printf("     0  ")
				} else {
					printf("%6.4f  ",c[i,j]/(10**pow))
				}
				if (j == 6) printf("\n")
			}
		}
		
		exit 0
	}' /dev/stdin

# Return exit code from awk script
success=$?

exit $success
