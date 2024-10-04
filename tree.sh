


metadata(){

	echo "File Structure"
	echo "============================="

	find . -type d -not -path '*/.*' | while read dir; 
			do
					
				sizedir=$(du -sh $dir | awk '{print $1}')
				echo "$sizedir |--- $dir" | sed 's/"\.\\"//"'


				find $dir -type f -not -path '*/.*' |  while read file;  
				do
					sizefile=$(du -sh $file | awk '{print $1}')
					echo "      |--- $(basename $file) $sizefile"	
				done
			done 

}

metadata
