# File Sorter 

# input: 50 files, 10

# function 1 - David
# Return the file types in a folder > filetypes.txt (unique)
# output: txt file 

# function 2 - Anwar                                                                          # Make the folders based on file type (if it does not exist already)
# output: append folder names to extension.txt (example .py=Python)

# function 3 - Raphaelle
# Sort files by extension into the folders

# function 4 - all
# file system information
# - "Loading message"
# - file tree diagram (recursive algorithm)
# - information on folders: size, amount of files (table view)
# - "Your files have been sorted"

# Declaration of assosiative array                                                                    
declare -A filetype_foldername_array

# Function to read the config file
read_config_file(){

	config_file="testfile_rs.txt"

	# Check if the file exists
    	if [[ ! -f "$config_file" ]]; then
        	echo "File not found!"
        	exit 1
    	fi

	# Read the file line by line
	while IFS= read -r line; 
	do
		# Skip empty lines
        	[[ -z "$line" ]] && continue
	
		# Split the line into key and value using the '=' delimiter
        	IFS='=' read -r key value <<< "$line"

        	# Trim whitespace (if any)
        	key=$(echo "$key" | xargs)
        	value=$(echo "$value" | xargs)
			
		echo $key
		echo $value

        	# Add the key and value to the associative array
        	filetype_foldername_array["$key"]="$value"

	done < "$config_file"
}

# Function to move files based on config file
move_files_to_folders() {
    for extension in "${!filetype_foldername_array[@]}"; do
        folder="${filetype_foldername_array[$extension]}"
        
	for file in *"$extension"; 
	do
        	if [[ "$file" != "testfile_rs.txt" &&  "$file" != "file_sorter.sh" ]]
		then

        		# Match zero or more files and move them to the target folder
        		mv "$file" "$folder/"
		fi
        done
    done
}

read_config_file 
move_files_to_folders



