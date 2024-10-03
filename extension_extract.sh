ext_extract () {
	src_ext_arr=($(find $1 -type f -exec basename {} \; | grep "\." |sed 's/.*\.//' | tr "\n" " "))
	src_arr_red=()
	length=${#src_ext_arr[@]}

	for ((i=0; i<length; i++));
	do
		duplicate=0
		length_reduced=${#src_arr_red[@]}
		for ((j=0; j<length_reduced; j++));
		do
			if [[ ${src_ext_arr[i]} =~ ${src_arr_red[j]} ]]; then
				duplicate=1
				break
			fi
		done
		
		if ((duplicate==0)); then
			src_arr_red+=(${src_ext_arr[i]})
		fi
	done

	echo "${src_arr_red[@]}"
}

ext_extract $1
