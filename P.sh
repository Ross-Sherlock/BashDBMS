#!/bin/bash

if [ ! -e "$1" ]; then
	touch "$1-placeholder"
	while ! ln -s "$1-placeholder" "${1}-lock" 2>/dev/null; do
		echo "$1 is being accessed by another user"
		sleep 4
		done
		rm "$1-placeholder"
		exit 0
else
	while ! ln -s "$1" "${1}-lock" 2>/dev/null; do
	echo "$1 is being accessed by another user"
	sleep 4
	done
	echo "Lock created"
	exit 0
fi
