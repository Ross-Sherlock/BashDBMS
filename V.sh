#!/bin/bash

if [ -z "$1" ]; then
	echo "Error: parameter problem"
	exit 1
else
	rm "$1-lock"
	echo "Lock removed"
	exit 0
fi
