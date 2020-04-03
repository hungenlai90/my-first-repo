#!/usr/bin/env bash

function guessinggame {
	echo "How many files are in the current directory? Please guess the number."
	num_files=$(ls -1 | wc -l)
	read response
	while [[ $response -ne $num_files ]]
	do
	  if [[ $response -gt $num_files ]]
	  then
	  	echo "The number is too high. Guess lower."
	  elif [[ $response -lt $num_files ]]
	  then
	  	echo "The number is too low. Guess higher."
	  fi
	  read response
	done
	echo "Congratulations! You got the right answer. There are $num_files files."
}	  

guessinggame