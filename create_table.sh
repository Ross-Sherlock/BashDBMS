#!/bin/bash

# Check correct number of args passed
if [ $# -lt 3 ]; then
        echo 'Error: Too few parameters'
        exit 1
elif [ $# -gt 3 ]; then
	echo 'Error: Too many parameters'
	exit 1
# Check if table exists
elif [ -f "$1/$2" ]; then
	echo 'Error: Table already exists'
	exit 1
else
# Check that database directory exists
	if [ -d "$1" ]; then
		touch $1/$2
		echo $3 > $1/$2
		echo 'OK: Table created'
		exit 0
	else
		echo 'Error: DB does not exist'
		exit 1
	fi
fi
