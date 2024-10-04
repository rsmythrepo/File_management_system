# File Sorter 

# input: 50 files, 10

# function 1 - David
# Return the file types in a folder > filetypes.txt (unique)
# output: txt file

declare -A ext_map

ext_extract () {
        extensions=($(find . -type f -exec basename {} \; | grep "\." |sed 's/.*\.//'))
        extensions_red=()
        length=${#extensions[@]}

        for ((i=0; i<length; i++));
        do
                duplicate=0
                length_reduced=${#extensions_red[@]}
                for ((j=0; j<length_reduced; j++));
                do
                        if [[ ${extensions[i]} =~ ${extensions_red[j]} ]]; then
                                duplicate=1
                                break
                        fi
                done

                if ((duplicate==0)); then
                        extensions_red+=(${extensions[i]})
                fi
        done

        no_extension=($(find . -type f -exec basename {} \; | grep -v "\."))
        if (( ${#no_extension[@]} > 0 )); then
                extensions_red+=("no_extension")
        fi

        echo "${extensions_red[@]}" > config_file.txt
}


# function 2 - Anwar                                                                          # Make the folders based on file type (if it does not exist already)
# output: append folder names to extension.txt (example .py=Python

create_folders(){
	while IFS='=' read -r ext name; do
    		ext_map["$ext"]="$name"
	done < extension_map.txt


	while read -r ext; do
    		ext=$(echo "$ext" | xargs | sed 's/\.//')
    		dir_name="${ext_map[$ext]}"


    		if [[ -n "$dir_name" ]]; then
        		mkdir -p "sorted/$dir_name"
        		echo "Folder created: $dir_name"
    		else
        		echo "No mapping for: $ext"
    		fi
	done < config_file.txt
}

# function 3 - Raphaelle
# Sort files by extension into the folders

# Function to move files based on config file
move_files_to_folders() {
    for extension in "${!ext_map[@]}"; do
        folder="${ext_map[$extension]}"
        
	for file in *"$extension"; 
	do
        	if [[ "$file" != "extension_map.txt" &&  "$file" != "file_sorter.sh" &&  "$file" != "config_file.txt" ]]
		then

        		# Match zero or more files and move them to the target folder
        		mv "$file" "$folder/"
		fi
        done
    done
}


ext_extract
create_folders
read_config_file 
move_files_to_folders


# function 4 - all
# file system information
# - "Loading message"
# - file tree diagram (recursive algorithm)
# - information on folders: size, amount of files (table view)
# - "Your files have been sorted"



