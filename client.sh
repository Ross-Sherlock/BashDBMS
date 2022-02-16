#!/bin/bash

# If client pipe already exists, exit with code 1
if [ $# -eq 1 ]; then
	id=$1
	if [ ! -p "${id}.pipe" ]; then
		mkfifo "${id}.pipe"
	else
		echo "${id}.pipe already exists"
		exit 1
	fi

while true; do

# trap ctrl_c and add removal of pipe functionality
trap ctrl_c INT

function ctrl_c() {
	rm -f "${id}.pipe"
	exit 0
}

	read input
	if [[ "$input" = "shutdown" || "$input" = "exit" ]]; then
		echo "$input ${id}" > server.pipe
		rm -f "${id}.pipe"
		exit 0
	else
		echo "$input ${id}" > server.pipe
		while read result; do
			# Get first word of first line of pipe read
			first=$(echo "$result" | head -n1 | awk '{print $1;}')
			# If first word is OK, command was successful
			if [ "$first" == "OK:" ]; then
				echo "Command successfully executed"
			# If first word is error, command unsuccessful
			elif [ "$first" == "Error:" ]; then
				echo "Error: Unsuccessful"
			# If first word is start_result then continiue without printing
			# Same for end result
			elif [[ "$first" == "start_result" || "$first" == "end_result" ]]; then
				continue
			else
				echo "$result"
			fi
			done < "${id}.pipe"
	fi
done

else
	echo "Error: One arg must be passed"
fi
