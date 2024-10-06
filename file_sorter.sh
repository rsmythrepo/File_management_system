#!/bin/bash
# File Sorter 


# Function 1 - David
# Return the unnique file types in the current directory > config_file.txt 

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

        #eicho "${extensions_red[@]}" > config_file.txt
	for extension in "${extensions_red[@]}"; do
    		echo "$extension" 
	done > config_file.txt
}


# Function 2 - Anwar
# Take in the extensions to folder name map - extensions.txt 
# Make the folders based on config_file (if it does not exist already)

create_folders(){
	date
	while IFS='=' read -r ext name; do
    		ext_map["$ext"]="$name"
	done < extension_map.txt

	while read -r ext; do
    		ext=$(echo "$ext" | xargs | sed 's/\.//')
    		dir_name="${ext_map[$ext]}"


    		if [[ -n "$dir_name" ]]; then
        		mkdir -p "$dir_name"
        		echo "Folder created: $dir_name"
    		else
        		echo "No mapping for: $ext"
    		fi
	done < config_file.txt
}

# Function 3 - Raphaelle
# Sort files by extension into the folders

move_files_to_folders() {

	# Check if the size of extension map assosiative array is not empty
	if [ ${#ext_map[@]} -eq 0 ]; then
        	echo "Error: The extension map is empty."
        	exit 1
    	fi
	
	# For each extension in the map (! accesses the keys of assiative array
	for extension in "${!ext_map[@]}";i do

       	foldername="${ext_map[$extension]}"

		# Iterate over files in the current directory that match *extension
		for file in *"$extension"; 
		do
			# If the file exists 
			if [[ -e "$file" ]]; 
			then
				# and the file is none of these files 
        			if [[ "$file" != "extension_map.txt" && "$file" != ".log.log" &&  "$file" != "file_sorter.sh" &&  "$file" != "config_file.txt" && "$file" != "file_gen.sh" ]]
				then
					
        				# Match zero or more files and move them to the target folder
        				mv "$file" "$foldername/"
					echo "$file has been moved to $foldername folder"
				fi
			fi
        	done
    	done
}


# Function 4 - all
# Output file system information
# - file tree diagram 
# - information on folders: size 

metadata(){
    echo "         ==========================="
    echo "	|       File Structure      |"
    echo " 	 ==========================="
    base_dir="."
    find "$base_dir" -type d -not -path '*/.*' | sort | while read dir; do
        dep=$(echo $dir | sed "s|$base_dir||" | tr -cd '/' | wc -c)
        indent=$(printf '    %.0s' $(seq 1 $dep))
        count=$(find "$dir" -maxdepth 1 | wc -l)
        count=$((count - 1))  # Subtract 1 to exclude the directory itself
        sizedir=$(du -sh "$dir" | awk '{print $1}')
        echo "${indent}🗂️---$(basename "$dir")/ [$count items, $sizedir]"

        find "$dir" -maxdepth 1 -type f -not -path '*/.*' | sort | while read file; do
            sizefile=$(du -sh "$file" | awk '{print $1}')
            echo "${indent}    📄|---$(basename "$file") [$sizefile]"
        done
    done
}




ext_extract
create_folders >> .log.log 2> >(sed 's/^/[ERROR] /' >> .log.log)
move_files_to_folders >> .log.log 2> >(sed 's/^/[ERROR] /' >> .log.log)
rm config_file.txt
clear
echo "Files has been sorted successfully..."
sleep 1
clear
metadata
