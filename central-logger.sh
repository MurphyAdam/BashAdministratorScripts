#!/bin/bash
# Author: Adam Clark
# Date: 27/09/2020
# Desciption: Logs watcher. 
# Pass in the path to the file you would like to watch and a string of keywords you'd like to watch. 
# You can also pass in an output file. Stdout is default.

## Get the name of the script without its path
clear
progname=${0##*/}
printf "[i] %s lunched\n" "$progname"

## Default values
verbose=0
filename=
keyword_list=
output='output.log'
backgroud=0

## List of options the program will accept;
## those options that take arguments are followed by a colon
optstring=f:k:o:v:b:

## The loop calls getopts until there are no more options on the command line
## Each option is stored in $opt, any option arguments are stored in OPTARG
while getopts $optstring opt
do
	case $opt in
		f) filename=$OPTARG;; ## $OPTARG contains the argument to the option
		k) keyword_list=$OPTARG;;
		o) output=$OPTARG;;
		v) verbose=$OPTARG;;
		b) backgroud=$OPTARG;;
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
		printf "[i] Log file: %s\n" "$filename"
	fi
else
	if [ $verbose -gt 0 ]
	then
		printf "[e] No filename was entered\n" >&2
	fi
	exit 1
fi
## Check whether file exists
if [ -f "$filename" ]
then
	if [ $verbose -gt 0 ]
	then
		printf "[i] Filename %s found\n" "$filename"
	fi
else
	if [ $verbose -gt 0 ]
	then
		printf "[e] File, %s, does not exist\n" "$filename" >&2
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
		printf "[i] Keyword list: %s\n" "$keyword_list"
	fi
else
	if [ $verbose -gt 0 ]
	then
		printf "[e] No Keyword list was entered\n" >&2
	fi
	exit 1
fi

printf "[i] Watching %s for entries '%s'\n" "$filename" "$keyword_list"

if [ $backgroud -gt 0 ]
then
	nohup $progname -f $filename -k $keyword_list -o $output &
	printf "[i] running central-logger with filename [%s], keyword_list [%s] and output_file [%s] in backgroud with nohup\n" "$filename" "$keyword_list" "$output"
	printf "[i] Redirecting STDOUT to nohup.out\n"
	exit 0
else
	printf "[i] running in foreground\n"
	tail -fn0 $filename | while read line
	do
		echo $line | egrep -i $keyword_list
		if [ $? = 0  ]
		then
			datetime=$( date --iso-8601=seconds )
			echo "[$datetime]" $line "[in $filename]" >> $output
			if [ $verbose -gt 0 ]
				then
				printf "[i] Keyword detected: %s\n" "$line"
			fi
		fi
	done
fi

exit 0