#!/bin/bash
# Convert a list of constants, 36 per line, to be 21 per line.

if [ $# -eq 0 ]; then
	file=/dev/stdin
else
	file="$@"
fi

awk '
	{
		# Read in constants
		f = 1
		for (i=1; i<=6; i++) {
			for (j=1; j<=6; j++) {
				C[i,j] = $f
				f += 1
			}
		}
		
		# Write out constants, 21 per line
		for (i=1; i<=6; i++) {
			for (j=i; j<=6; j++) {
				printf("%s ",C[i,j])
			}
		}
		
		printf("\n")
	}' $file

