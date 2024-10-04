#!/bin/bash

# Path to the mapping file
mapping_file="extension_map.txt"

# Total number of files to create
total_files=50

# Directory to create the files in
output_dir="."

# Check if the mapping file exists
if [[ ! -f "$mapping_file" ]]; then
  echo "Mapping file not found: $mapping_file"
  exit 1
fi

# Create the directory if it doesn't exist
mkdir -p "$output_dir"

# Read all extensions from the mapping file
declare -A extensions
while IFS='=' read -r ext desc; do
  if [[ -n "$ext" && -n "$desc" ]]; then
    # Replace spaces in description with underscores
    desc=${desc// /_}
    extensions["$ext"]="$desc"
  fi
done < "$mapping_file"

# Calculate how many files to create per extension
ext_count=${#extensions[@]}
files_per_ext=$((total_files / ext_count))
remaining_files=$((total_files % ext_count))

# Create files for each extension, distributing the remaining files
for ext in "${!extensions[@]}"; do
  desc=${extensions[$ext]}
  file_count=$files_per_ext

  # If we have remaining files, distribute one more to this extension
  if [[ $remaining_files -gt 0 ]]; then
    file_count=$((file_count + 1))
    remaining_files=$((remaining_files - 1))
  fi

  # Create the files for this extension
  for i in $(seq 1 $file_count); do
    # Create files with no spaces in the name
    touch "$output_dir/file_${desc}_$i.$ext"
  done
done

echo "Total of $total_files files created in $output_dir."

