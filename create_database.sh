#!/bin/bash

# Check if correct number of args passed
if [ $# -eq 0 ]; then
	echo 'Error: no parameter'
	exit 1
elif [ $# -gt 1 ]; then
	echo 'Error: too many parameters'
	exit 1
# Check if database already exists
elif [ -d $1 ]; then
	echo 'Error: Database already exists'
	exit 1
# Else, create database directory
else
		mkdir  "$1"
		echo 'OK: Database created'
fi
