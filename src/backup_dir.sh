#!/bin/bash

# Check if the target file name is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <target_filename>"
    exit 1
fi

# Target file name provided as the first argument
target_filename=$1

# Check if the ss_config_path file exists
if [ ! -f "ss_config_path" ]; then
    echo "ss_config_path file not found."
    exit 1
fi

# Create an array to store folder names to be backed up
folders_to_backup=()

# Read ss_config_path file line by line
while IFS= read -r line; do
    # Ignore lines starting with '#' (comments) and skip empty lines
    if [[ $line =~ ^\s*# ]] || [[ -z $line ]]; then
        continue
    fi
    
    # Trim leading and trailing whitespace
    line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    
    # Add folder name to the array if it's not sslist
    if [ "$line" != "sslist" ]; then
        folders_to_backup+=("$line")
    fi
done < "ss_config_path"

# Check if there are folders to backup
if [ ${#folders_to_backup[@]} -eq 0 ]; then
    echo "No folders to backup."
    exit 0
fi

# Create a temporary directory for backup
temp_dir=$target_filename'_tmp'

# Backup each folder to the temporary directory
for folder in "${folders_to_backup[@]}"; do
    cp -r "$folder" "$temp_dir"
done

# Create a tar.gz archive of the temporary directory
tar -czf "$target_filename.tar.gz" -C "$(dirname "$temp_dir")" "$(basename "$temp_dir")"

# Remove the temporary directory
rm -rf "$temp_dir"

echo "Backup completed: $target_filename.tar.gz"
