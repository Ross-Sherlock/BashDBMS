#!/bin/bash
if [ ! -p server.pipe ]; then
	mkfifo server.pipe
else
	echo "server.pipe already exists"
fi


while true; do

# Ensure pipe is removed when ctrl+c is used
trap ctrl_c INT
function ctrl_c() {
	rm -f "server.pipe"
	exit 0
}

	# Read input from client
	read -a Arr input < server.pipe

	# Capture client id
	id="${Arr[-1]}"

	# Remove client id from array
	unset Arr[-1]

	case "${Arr[0]}" in
		create_database)
			./P.sh "${Arr[1]}"
			if [ $? -eq 0 ]; then
				./create_database.sh "${Arr[@]:1}" > "${id}.pipe"
				./V.sh "${Arr[1]}"
			fi
			;;
		create_table)
			./P.sh "${Arr[1]}"
			if [ $? -eq 0 ]; then
				./create_table.sh "${Arr[@]:1}" > "${id}.pipe"
				./V.sh "${Arr[1]}"
			fi
			;;
		insert)
			./P.sh "${Arr[1]}-${Arr[2]}"
			if [ $? -eq 0 ]; then
				./insert.sh "${Arr[@]:1}" > "${id}.pipe"
				./V.sh "${Arr[1]}-${Arr[2]}"
			fi
			;;
		select)
			./P.sh "${Arr[1]}-${Arr[2]}"
			if [ $? -eq 0 ]; then
				./select.sh "${Arr[@]:1}" > "${id}.pipe"
				./V.sh "${Arr[1]}-${Arr[2]}"
			fi
			;;
		remove)
			./P.sh "${Arr[1]}-${Arr[2]}"
			if [ $? -eq 0 ]; then
				./remove.sh "${Arr[@]:1}" > "${id}.pipe"
				./V.sh "${Arr[1]}-${Arr[2]}"
			fi
			;;
		shutdown)
			rm -f server.pipe
			exit 0
			;;
		*)
			echo "Error: bad request"
			exit 1
esac
done

