ext_extract () {
	extensions=($(find $1 -type f -exec basename {} \; | grep "\." |sed 's/.*\.//' | tr "\n" " "))
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
	
	no_extension=($(find $1 -type f -exec basename {} \; | grep -v "\." | tr "\n" " "))
	if (( ${#no_extension[@]} > 0 )); then
		extensions_red+=("no_extension")
	fi
	
	echo "${extensions_red[@]}"
}

ext_extract $1
