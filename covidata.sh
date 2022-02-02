#!/bin/bash

#set -x

# error=1 means wrong number of arguments for get
# error=2 means wrong number of arguments for compare
# error=3 means wrong procedure without procedure
# error=4 means wrong number of arguments for -r get
# error=5 means wrong number of arguments for -r compare
# error=6 means wrong procedure with -r

function errorMsg
{
	error=$1
	if [[ $error == 'Wrong number of arguments' ]]
	then
		if [[ $option == 'get' ]]
		then
			#error_message="Wrong number of arguments"
			syntax="./covidata.sh procedure id inputFile outputFile"
			example="./covidata.sh get 35 data.csv result.csv"
		elif [[ $option == 'compare' ]]
		then
			syntax="./covidata.sh procedure id inputFile outputFile compFile"
                        example="./covidata.sh compare 10 data.csv result2.csv result.csv" 
		elif [[ $option == '-r' ]]
		then
			if [[ $procedure == 'get' ]]
			then
				syntax="./covidata.sh switch procedure id startTime endTime inputFile"
				example="./covidata.sh -r get 35 2020-01 2020-03 data,csv result.csv"
			elif [[ $procedure == 'compare' ]]
			then
				syntax="./covidata.sh switch procedure id startTime endTime inputFile outFile"
				example="./covidata,sh -r compare 10 2020-01 2020-03 data.csv result2.csv result.csv"
			fi
		fi
	elif [[ $error == "Procedure not provided" ]]
	then
		if [[ $option == '-r' ]]
		then
			syntax="./covidata.sh switch procedure id startTime endTime inputFile outputFile or ./covidata.sh switch procedure id startTime endTime inputFile outputFile compFile"
               		example="./covidata.sh -r get 35 2020-01 2020-03 data.csv result.csv or./covidata.sh -r compare 10 2020-01 2020-03 data.csv result2.csv result.csv"
		else
			syntax="./covidata.sh procedure id inputFile outputFile or ./covidata.sh procedure id inputfile outputfile compfile"
			example="./covidata.sh get 35 data.csv result.csv or./covidata.sh compare 10 data.csv result2.csv result.csv"
		fi
#	elif [[ $error == 2 ]]
#	then
#		error_message="Wrong number of arguments"
#		syntax="./covidata.sh procedure id inputFile outputFile compFile"
#		example="./covidata.sh compare 10 data.csv result2.csv result.csv" 	
#	elif [[ $error == 3 ]]
#	then
#		error_message='Procedure not provided' 
#		syntax="./covidata.sh procedure id inputFile outputFile or ./covidata.sh procedure id inputfile outputfile compfile"
#		example="./covidata.sh get 35 data.csv result.csv or./covidata.sh compare 10 data.csv result2.csv result.csv"
#	elif [[ $error == 4 ]]
#	then
#		error_message='Wrong number of arguments'
#		syntax="./covidata.sh switch procedure id startTime endTime inputFile"
#		example="./covidata.sh -r get 35 2020-01 2020-03 data,csv result.csv"
#	elif [[ $error == 5 ]]
#	then
#		error_message='Wrong number of arguments'
#		syntax="./covidata.sh switch procedure id startTime endTime inputFile outFile"
#		example="./covidata,sh -r compare"
#	elif [[ $error == 6 ]]
#	then
#		error_message='Procedure not provided'
#		syntax="./covidata.sh switch procedure id startTime endTime inputFile outputFile or ./covidata.sh switch procedure id startTime endTime inputFile outputFile compFile"
#               example="./covidata.sh -r get 35 2020-01 2020-03 data.csv result.csv or./covidata.sh -r compare 10 2020-01 2020-03 data.csv result2.csv result.csv"
	elif [[ $error == 'Input file name does not exist' ]]
	then
		if [[ $option == '-r' ]]
		then
			if [[ $procedure == 'get' ]]
			then
				syntax="./covidata.sh switch procedure id startTime endTime existed_inputFile"
				example="./covidata.sh -r get 35 2020-01 2020-03 data,csv result.csv"
			elif [[ $procedure == 'compare' ]]
			then
				syntax="./covidata.sh switch procedure id startTime endTime existed_inputFile outFile"
				example="./covidata,sh -r compare 10 2020-01 2020-03 data.csv result2.csv result.csv"
			fi
		elif [[ $option == 'get' ]]
		then
			syntax="./covidata.sh procedure id existed_inputFile outputFile"
			example="./covidata.sh get 35 data.csv result.csv"
		elif [[ $option == 'compare' ]]
		then
			syntax="./covidata.sh procedure id existed_inputFile outputFile compFile"
                        example="./covidata.sh compare 10 data.csv result2.csv result.csv" 
		fi
	fi
	echo $error
	echo -e "Script syntax: $syntax"
	echo -e "Legal usage examples: $example"
}


option=$1

if [[ $option == -r ]]
then		
	shift;
	procedure=$1
	if [[ $procedure == 'get' ]]
	then
		if [[ $# != 6 ]]
		then
			errorMsg 'Wrong number of arguments'
			exit 4
		fi

		id=$2
		startTime=$3
		endTime=$4
		inputFile=$5
		outputFile=$6
		if [[ ! -f $inputFile ]]
		then
			errorMsg 'Input file name does not exit'
			exit 7
		fi	
		startYear=${startTime:0:4}
		startMonth=${startTime:5:2}
		endYear=${endTime:0:4}
		endMonth=${endTime:5:2}
		startDay="01"
		endDay="15"
		format='rowcount,avgconf,avgdeaths,avgtests'
		tmp='tmp.csv'
		> $outputFile
		> $tmp
		while [ $startMonth -le $endMonth ]
		do
			avgconf=0
                        avgdeaths=0
                        avgtests=0
			count=0
			theNewStartDate=$startYear-$startMonth-$startDay
			theNewEndDate=$startYear-$startMonth-$endDay
			awk -v StartDate=$theNewStartDate -v EndDate=$theNewEndDate -v startYear=$startYear -v startMonth=$startMonth -v startDay=$startDay -v endDay=$endDay -v id=$id -v count=$count -v outputFile=$outputFile -v avgconf=$avgconf -v avgdeaths=$avgdeaths -v avgtests=$avgtests -v format=$format -v tmp=$tmp 'Begin { FS="," } 
			{ FS="," } { if ( $5 >= StartDate && $5 <= EndDate && $1 ~ id ) { print $0 >> outputFile; avgconf=avgconf+$6; avgdeaths=avgdeaths+$8; avgtests+=$11; count++} }
			END { OFS=","; print format >> tmp; print count, avgconf / count, avgdeaths / count, avgtests / count >> tmp } ' < $inputFile
			theNewStartDate=$startYear-$startMonth-$startDay
			theNewEndDate=$startYear-$startMonth-$endDay
			if [ $startDay -eq "01" ]
			then
				startDay="16"
				endDay="31"
			elif [ $startDay -eq "16" ]
			then
				startDay="01"
				endDay="15"

				startMonth=$(expr $startMonth + 1)

				if [ ${#startMonth} -lt 2 ] 
				then
					startMonth=0$startMonth
				fi
			fi
		done
		cat $tmp >> $outputFile
		rm $tmp
	elif [[ $procedure == compare ]]
	then
		if [[ $# != 7 ]]
		then
			errorMsg 'Wrong number of arguments'
			exit 5
		fi

		id=$2
		startTime=$3
		endTime=$4
		inputFile=$5
		outputFile=$6
		compFile=$7
		
		if [[ ! -f $inputFile ]]
		then
			errorMsg 'Input file name does not exit'
			exit 8
		fi	

		IFS=',' read -r -a array <<< $(tail -1 $compFile)
		
		c_count=${array[0]}
		c_conf=${array[1]}
		c_deaths=${array[2]}
		c_tests=${array[3]}

		startYear=${startTime:0:4}
		startMonth=${startTime:5:2}
		endYear=${endTime:0:4}
		endMonth=${endTime:5:2}
		startDay="01"
		endDay="15"
		data=$(tail -1 $compFile)
		format1='rowcount,avgconf,avgdeaths,avgtests'
		format2='diffcount,diffavgconf,diffavgdeath,diffavgtests'
		input_tmp='tmp1.csv'
		stats_tmp='tmp2.csv'
		comp_tmp='tmp3.csv'
		
		> $outputFile
		echo "$format1" > tmp1.csv
		echo $format2 > $stats_tmp
		echo $format1 > $comp_tmp

		
		while [ $startMonth -le $endMonth ]
		do
			avgconf=0
                        avgdeaths=0
                        avgtests=0
			count=0
			theNewStartDate=$startYear-$startMonth-$startDay
			theNewEndDate=$startYear-$startMonth-$endDay
			awk  -v input_tmp='tmp1.csv' -v stats_tmp='tmp2.csv' -v comp_tmp='tmp3.csv' -v data="$data" -v format2=$format2 -v c_count=$c_count -v c_conf=$c_conf -v c_tests=$c_tests -v c_deaths=$c_deaths -v StartDate=$theNewStartDate -v EndDate=$theNewEndDate -v startYear=$startYear -v startMonth=$startMonth -v startDay=$startDay -v endDay=$endDay -v id=$id -v count=$count -v outputFile=$outputFile -v avgconf=$avgconf -v avgdeaths=$avgdeaths -v avgtests=$avgtests -v format1=$format1  'Begin { FS="," } 
			{ FS="," } { if ( $5 >= StartDate && $5 <= EndDate && $1 ~id ) { print $0 >> outputFile; avgconf=avgconf+$6; avgdeaths=avgdeaths+$8; avgtests+=$11; count++} }
			END { OFS=","; print count, avgconf / count , avgdeaths / count , avgtests / count >> input_tmp ; print data >> comp_tmp ; print count - c_count , ( avgconf / count ) - c_conf , ( avgdeaths / count ) - c_deaths , (avgtests / count) - c_tests >> stats_tmp }' < $inputFile
			theNewStartDate=$startYear-$startMonth-$startDay
			theNewEndDate=$startYear-$startMonth-$endDay
			if [ $startDay -eq "01" ]
			then
				startDay="16"
				endDay="31"
			elif [ $startDay -eq "16" ]
			then
				startDay="01"
				endDay="15"

				startMonth=$(expr $startMonth + 1)

				if [ ${#startMonth} -lt 2 ] 
				then
					startMonth=0$startMonth
				fi
			fi
		done
		head -n -2 $compFile >> $outputFile
		cat $input_tmp >> $outputFile
		cat $comp_tmp >> $outputFile
		cat $stats_tmp >> $outputFile
		rm $input_tmp $comp_tmp $stats_tmp
	else
		errorMsg 'Procedure not provided'
		exit 6
	fi

elif [[ $option == 'get' ]]
then
	if [[ $# == 4 ]]
	then
		ID=$2
		inputfile=$3
		if [[ ! -f $inputfile ]]
		then
			errorMsg 'Input file name does not exit'
			exit 9

		fi	
		outputfile=$4
		set avgconf
		set avgdeaths
		set avgtests
		set count
		> $outputfile
		format='rowcount,avgconf,avgdeaths,avgtests'
		awk -v id=$ID  -v c="$avgconf" -v d="$avgdeaths" -v o="$outputfile" -v t="$averagetests" -v cou="$count" -v f="$format" '
		Begin { FS=","}
		{ FS=","} { if ( $1 ~ id) {print $0 >> o; c=c+$6; d=d+$8; t+=$11; cou++ } }
		END { OFS=","; print f >> o; print cou, c / cou ,d / cou ,t / cou >> o}
		' < $inputfile 
	else
		errorMsg 'Wrong number of arguments'
		exit 1
	fi
elif [[ $option == 'compare' ]]
then
	if [[ $# != 5 ]]
	then
		errorMsg 'Wrong number of arguments'
		exit 2
	else
		ID=$2
		inputfile=$3
		if [[ ! -f $inputfile ]]
		then
			errorMsg 'Input file name does not exit'
			exit 10
		fi	
		outputfile=$4
		compfile=$5
		set avgconf
		set avgdeaths
		set avgtests
		set count
		IFS=',' read -r -a array <<< $(tail -1 $compfile)
		c_count=${array[0]}
		c_conf=${array[1]}
		c_deaths=${array[2]}
		c_tests=${array[3]}
		format1='rowcount,avgconf,avgdeaths,avgtests'
		format2='diffcount,diffavgconf,diffavgdeaths,diffavgtests'
		head -n -2 $compfile > tmp
		c_stats=$(tail -2 $compfile)
		> $outputfile
		awk -v id="$ID" -v comp_data_file='tmp' -v c="$avgconf" -v d="$avgdeaths" -v t="$averagetests" -v cou="$count" -v f1="$format1" -v f2="$format2" -v o="$outputfile" -v comp="$compfile" -v comp_c="$c_count" -v comp_con="$c_conf" -v comp_dea="$c_deaths" -v comp_tests="$c_tests" -v comp_stats="$c_stats" '
		Begin { FS=","}
		{ FS=","}{ if ( $1 ~ id) { print $0 > o; c=c+$6; d=d+$8; t+=$11; cou++ } }
		END { OFS=","; print f1 >> comp_data_file ; print cou, c / cou ,d / cou ,t / cou >> comp_data_file; print comp_stats >> comp_data_file ; print f2 >> comp_data_file; print (cou - comp_c),(c/cou - comp_con),(d/cou - comp_dea),(t/cou - comp_tests) >> comp_data_file } ' < $inputfile
		cat tmp >> $outputfile
		rm tmp
	fi
else
	errorMsg 'Procedure not provided' 
	exit 3
fi
