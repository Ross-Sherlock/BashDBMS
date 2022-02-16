#!/bin/bash

# Check that the correct number of args passed
if [ $# -ne 3 ]; then
	if [ $# -eq 2 ]; then
		echo "start_result"
		echo "$(<"$1/$2")"
		echo "end_result"
		exit 0
	else
        	echo 'parameters problem'
        	exit 1
	fi
else
	# Check database directory exists
        if [ -d "$1" ]; then
	# Check table exists
		if [ -f "$1/$2" ]; then
			#  Calculate no. of columns in table
			max=$(awk -F, 'NR==1{print NF}'  $1/$2)
			columns=$3
			# Create an array of columns from the columns the user entered
			# And sort this array so the largest number entered is the last
			# Element and the smallest is the first element
			IFS=',' read -r -a column_array <<< "$columns"
			IFS=$'\n' sorted=($(sort <<< "${column_array[*]}")); unset IFS
			largest_select=${sorted[-1]}
			smallest_select=${sorted[0]}
			# Ensure the largest is less is less than the number of columns in
			# the table and the smallest is positive
			if [ $largest_select -le $max ] && [ $smallest_select -gt 0 ]; then
				echo "start_result"
				cut -d, -f"$columns" $1/$2
				echo "end_result"
				exit 0
			else
				echo "Error: column does not exist"
				exit 1
			fi
		else
			echo "Error: table does not exist"
			exit 1
		fi
	else
		echo "Error: DB does not exist"
		exit 1
        fi
fi

