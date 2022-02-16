#!/bin/bash

# Check if correct number of args passed
if [ $# -ne 3 ]; then
        echo 'parameters problem'
        exit 1
else
	# Check that database directory exists 
        if [ -d "$1" ]; then
		# Check that table exists
		if [ -f "$1/$2" ]; then
			length=$(awk -F, 'NR==1{print NF}'  $1/$2)
			inserts=$3
			insert_length=$(echo "${inserts//,/ }" | wc -w)
			echo "$insert_l"
			# Check that tuple has same no of columns as table
			if [ "$insert_length" -eq "$length" ]; then
				echo $inserts >> $1/$2
				echo "OK: tuple inserted"
				exit 0
			else
				echo "Error: number of columns in tuple does not match schema"
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

