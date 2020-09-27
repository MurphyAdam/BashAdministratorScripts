progname=${0##*/} ## Get the name of the script without its path
## Default values
verbose=1
filename=
keyword_list=
output='output.txt'
## List of options the program will accept;
## those options that take arguments are followed by a colon
optstring=f:k:o:v
## The loop calls getopts until there are no more options on the command line
## Each option is stored in $opt, any option arguments are stored in OPTARG
while getopts $optstring opt
do
	case $opt in
		f) filename=$OPTARG ;; ## $OPTARG contains the argument to the option
		k) keyword_list=$OPTARG;;
		o) output=$OPTARG;;
		v) verbose=$(( $verbose + 1 )) ;;
		*) exit 1 ;;
	esac
done
## Remove options from the command line
## $OPTIND points to the next, unparsed argument
shift "$(( $OPTIND - 1 ))"
## Check whether a filename was entered
if [ -n "$filename" ]
then
	if [ $verbose -gt 0 ]
		then
		printf "Log file: %s\n" "$filename"
	fi
else
	if [ $verbose -gt 0 ]
	then
		printf "No log file was entered\n" >&2
	fi
	exit 1
fi
## Check whether file exists
if [ -f "$filename" ]
then
	if [ $verbose -gt 0 ]
	then
		printf "Filename %s found\n" "$filename"
	fi
else
	if [ $verbose -gt 0 ]
	then
		printf "File, %s, does not exist\n" "$filename" >&2
	fi
exit 2
fi


## Remove options from the command line
## $OPTIND points to the next, unparsed argument
shift "$(( $OPTIND - 1 ))"
## Check whether a keyword_list was entered
if [ -n "$keyword_list" ]
then
	if [ $verbose -gt 0 ]
		then
		printf "Keyword list: %s\n" "$keyword_list"
	fi
else
	if [ $verbose -gt 0 ]
	then
		printf "No Keyword list was entered\n" >&2
	fi
	exit 1
fi

tail -fn0 $filename | while read line
do
	echo $line | egrep -i $keyword_list
	if [ $? = 0  ]
	then
		echo $line >> $output
		if [ $verbose -gt 0 ]
			then
			printf "Keyword detected: %s\n" "$line"
		fi
	fi
done

## If the verbose option is selected,
## print the number of arguments remaining on the command line
if [ $verbose -gt 0 ]
then
	printf "Number of arguments is %d\n" "$#"
fi