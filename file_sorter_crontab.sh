#!/bin/bash
# File Sorter 

# input: 50 files, 10
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
                        if [[ ${extensions[i]} == ${extensions_red[j]} ]]; then
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


# function 2 - Anwar 
# Make the folders based on file type (if it does not exist already)
# output: append folder names to extension.txt (example .py=Python

create_folders(){
	echo "[Date]: Folders created on $(date)"
	while IFS='=' read -r ext name; do
    		ext_map["$ext"]="$name"
	done < extension_map.txt

	while read -r ext; do		
    		dir_name="${ext_map[$ext]}"
    		if [[ -n "$dir_name" ]]; then
        		mkdir -p "$dir_name"
        		echo "Folder created: $dir_name"
    		else
        		echo "No mapping for: $ext"
    		fi
	done < config_file.txt
}

# function 3 - Raphaelle
# Sort files by extension into the folders
# Function to move files based on config file

# Function 3 - Raphaelle
# Sort files by extension into the folders

move_files_to_folders() {

        # Check if the size of extension map assosiative array is not empty
        if [ ${#ext_map[@]} -eq 0 ]; then
                echo "Error: The extension map is empty."
                exit 1
        fi

        # For each extension in the map (! accesses the keys of assiative array
        for extension in "${!ext_map[@]}"; do

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

# function 4 - all
# file system information
# - file tree diagram (recursive algorithm)
# - information on folders: size, amount of files 

metadata(){
    echo "         ========= m3sorter ========
    	|       File Structure      |
    	 ==========================="
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

setup(){
        script_path="$HOME/.M3_sorter/"
        script="./file_sorter.sh"
        map="./extension_map.txt"
        alias_name="m3sorter"
        mkdir -p $script_path
        cp $script $map $script_path
        chmod +x "$script_path/$script"
        if [[ ":$PATH:" != *":$script_path:"* ]]; then
                echo "export PATH=\"$script_path:\$PATH\"" >> "$HOME/.bashrc"
                echo "alias $alias_name='$script_path/$script'" >> "$HOME/.bashrc"
                echo "Installation complete. To finish setup, please run:"
                echo "source ~/.bashrc"
        else
                echo "Setup already completed"
        fi
}

removal(){
    script_path="$HOME/.M3_sorter/"
    alias_name="m3sorter"
    sed -i "\|export PATH=\"$script_path:\\\$PATH\"|d" "$HOME/.bashrc"
    sed -i "/alias $alias_name=/d" "$HOME/.bashrc"
    export PATH=$(echo $PATH | sed -e 's|$HOME/.M3_sorter:||')
    rm -rf $script_path
    echo "Removal complete. To apply changes, please run:"
    echo "source ~/.bashrc"
}
crontab() {
    path=$(pwd)
    map="$HOME/.M3_sorter/extension_map.txt"
    script=".m3sorter_crontab.sh"
    cat <<EOL > "$script"
#!/bin/bash
declare -A ext_map
$(declare -f ext_extract)
$(declare -f create_folders)
$(declare -f move_files_to_folders)
ext_extract
create_folders >> .log.log 2> >(sed 's/^/[ERROR] /' >> .log.log)
move_files_to_folders >> .log.log 2> >(sed 's/^/[ERROR] /' >> .log.log)
EOL
    cp "$map" "$path"
    chmod +x "$script"
    clean_path=$(printf "%q" "$path/$script") # clear the path from spaces and spec char
    CRON_JOB="*/3 * * * * $clean_path"
    if crontab -l 2>/dev/null | grep -qF "$clean_path"; then
        echo "M3sorter is already in Crontab. No changes made."
    else
        (crontab -l 2>/dev/null || true; echo "$CRON_JOB") | crontab -
        echo "M3sorter is added successfully to Crontab"
    fi
}

if [ $1 == "-setup" ]; then
	setup
elif [ $1 == "-remove" ]; then
        removal
elif [ $1 == "-tree" ]; then
	metadata
elif [ $1 == "-crontab" ]; then
	crontab
elif [ -z $1 ]; then
	ext_extract
	create_folders >> .log.log 2> >(sed 's/^/[ERROR] /' >> .log.log)
	move_files_to_folders >> .log.log 2> >(sed 's/^/[ERROR] /' >> .log.log)
	rm config_file.txt
	clear
	echo "Files has been sorted successfully..."
	sleep 1
	clear
	metadata
else
	echo "Invalid option. Add:
        '-setup': To setup the m3sorter. (only needed once).
	'-remove': To undo the setup.
	'-tree': To display the tree of the accual folder. 
       	Run only m3sorter without any option to sort your folder."
fi
