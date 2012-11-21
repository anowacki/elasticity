#!/bin/bash
# Script to take EC_grid of cijs (ASCII) and convert into an x-y-z-Au file

if [ $# -ne 1 ]; then
	echo "Usage: $0 [ijxyz file] > [outfile]"
	exit 1
fi

awk '{print $1,$2,$3}' > /tmp/EC_grid2Au.xyz

awk '{$1=""; $2=""; $3="";
	if (NF==39){
		do (i=1; i<=6; i++){
			do (j=1; j<=6; j++){
				
			}
		}
	}
}'