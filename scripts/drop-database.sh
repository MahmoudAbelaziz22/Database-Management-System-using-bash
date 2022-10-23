#! /bin/bash

#import helper-functions.sh file
source ./scripts/helper-functions.sh

#to clear screen.
clear

#######################################
# Drop or delete databases function.
# Arguments:
#   Non
# Usage:      drop_database
#######################################
function drop_database() {

  cd ./Databases
  print_colored "white" "Your Existing Databases:\n"
  if [[ $(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d' | wc -l) = 0 ]]
  then
      print_colored "red" "No databases available to delete."
  else
      print_colored "purple" "$(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d')"
  fi
  cd ..
	
	print_colored "bwhite" "Enter the name of the database:"
	read database_name
  cd ./Databases
	# null entry
	if [[ "$database_name" = '' ]]
  then
      print_colored "red" "Invalid name, Please enter a correct name."
      cd ..
	    drop_database
	# db exists
	elif ! [[ -d "$database_name" ]]
  then
		  print_colored "red" "This database doesn't exist."
      cd ..
      drop_database
	# new db	
	else
      clear
      print_colored "green" "+------------------------------+"
      print_colored "green" "|-------Are you sure?----------|"
      print_colored "green" "|------------------------------|"
      print_colored "green" "| 1. Yes.                      |"
      print_colored "green" "| 2. No.                       |"
      print_colored "green" "+------------------------------+"
      print_colored "bwhite" "Are you sure, you want to delete $database_name from your databases:"
      read REPLY
      case $REPLY in
        1 )
          rm -rf "$database_name"
          print_colored "green" "$database_name removed from your databases."
          print_colored "white" "Press any key to continue..."
          read
          cd ..
          source ./scripts/dive-into-database.sh
          dive_into_database
          ;;
        2 ) 
          cd ..
          source ./scripts/dive-into-database.sh
          dive_into_database      
          ;;
      esac

	fi
}