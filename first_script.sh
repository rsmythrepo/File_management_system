declare -A ext_map
while IFS='=' read -r ext name; do
    ext_map["$ext"]="$name"
done < extension_map.txt


while read -r ext; do
    ext=$(echo "$ext" | xargs | sed 's/\.//')
    lang="${ext_map[$ext]}"


    if [[ -n "$lang" ]]; then
        mkdir -p "sorted/$lang"
        echo "Folder created: $lang"
        clear
    else
        echo "No mapping for: $ext"
    fi
done < extensions.txt
