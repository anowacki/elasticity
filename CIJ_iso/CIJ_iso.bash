#!/bin/bash
# Outputs 36 elastic constants given input vp and vs.  Unnormalised.

if [ $# -ne 2 ]; then
	echo "Usage: `basename $0` [vp] [vs]" > /dev/stderr
	echo "   Writes 36 ecs to stdout" > /dev/stderr
	exit 1
fi

vp=$1
vs=$2

echo $vp $vs |\
	awk '{
		p=$1
		s=$2
		if (p < 500) {
			p *= 1000  # Convert into m/s if given values less than 500
			s *= 1000
		}
		c[1,1] = p**2
		c[2,2] = c[1,1]
		c[3,3] = c[1,1]
		
		c[4,4] = s**2
		c[5,5] = c[4,4]
		c[6,6] = c[4,4]
		
		c[1,2] = c[1,1] - 2*c[4,4]
		c[1,3] = c[1,2]
		c[2,3] = c[1,2]
		
		for (i=1; i<=6; i++) {
			for (j=1; j<=6; j++) {
				if (i > j) c[i,j] = c[j,i]  # Make symmetrical
				printf("%e ",c[i,j])
			}
		}
		
		printf("\n")
	}'