declare -A ext_map
while IFS='=' read -r ext name; do
    ext_map["$ext"]="$name"
done < extension_map.txt


while read -r ext; do
    ext=$(echo "$ext" | xargs | sed 's/\.//')
    dir_name="${ext_map[$ext]}"


    if [[ -n "$dir_name" ]]; then
        mkdir -p "sorted/$dir_name"
        echo "Folder created: $dir_name"
        clear
    else
        echo "No mapping for: $ext"
    fi
done < extensions.txt
