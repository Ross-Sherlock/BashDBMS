#!/bin/bash

# Check that the correct number of args passed
if [ $# -ne 3 ]; then
        echo "Error: parameter problem"
	exit 1
elif
	 [ ! -d "$1" ]; then
	echo "Error: DB does not exist"
	exit 1
elif [ ! -f "$1/$2" ]; then
	echo "Error: table does not exist"
	exit 1
else
	# Calculate no. of columns in table
	max=$(awk -F, 'NR==1{print NF}'  $1/$2)
	tuple=$3
	for var in ${tuple//,/ }; do
		if [ "$var" -eq 1 ]; then
			echo "Error: you cannot remove the table header"
			exit 1
		fi
		if [ "$var" -gt "$max" ] || [ "$var" -lt 1 ]; then
			echo "Error: row $var does not exist."
			exit 1
		fi
	done
	sed -i "$3"d "$1/$2"
	echo "OK: Row(s) removed"
	exit 0
fi 

