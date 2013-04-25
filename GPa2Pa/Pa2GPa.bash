#!/bin/bash

awk '{for (i=1; i<=NF; i++){ \
		printf("%s ", $i/1.e9); \
	  }; \
	  printf("\n") \
	  }' /dev/stdin
