#!/bin/bash

dir="$1"
ext="$2"

if [ -z "$dir" ]; then
	exit 1
fi

# Resolve the input directory to an absolute path
abs_dir=$(realpath "$dir")

while [ -d "$dir" ]; do

	# Check if the directory is the root directory ("/")
	if [ "$abs_dir" = "/" ]; then
		# List all subdirectories (excluding hidden ones)
		subdirs=$(find "$abs_dir" -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*' -printf '%p/\n')
	else
		# List all subdirectories (including "..")
		subdirs=$(echo "$abs_dir/.." && find "$abs_dir" -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*' -printf '%p/\n')
	fi

	# List all files with the specified extension (if specified)
	if [ -n "$ext" ]; then
		files=$(find "$abs_dir" -mindepth 1 -maxdepth 1 -type f -iname "*.$ext" -not -path '*/\.*' -print)

		# Merge the subdirs and files variables into one variable
		output=$(printf "%s\n%s" "$subdirs" "$files")
	else
		# Only list directories
		output="$subdirs"
	fi

	# Update the dir variable, e.g. by asking the user for input
	dir=${abs_dir}/$(echo "$output" | sed "s|${abs_dir}/||g" | sort | wofi --dmenu)

	echo $abs_dir $dir

	# Escape was pressed, exit
	if [ "$abs_dir/" = "$dir" ]; then
		exit 1
	fi

	# Resolve the input directory to an absolute path
	abs_dir=$(realpath "$dir")
done

echo $dir
