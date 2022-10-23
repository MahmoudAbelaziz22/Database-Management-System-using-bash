#! bin/bash

#import helper-functions.sh file
source ./scripts/helper-functions.sh

#to clear screen.
clear

#######################################
# Use an existing database function.
# Arguments:
#   Non
# Usage:      use_existing_database
#######################################
function use_existing_database() {

  cd ./Databases

  if [[ $(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d' | wc -l) = 0 ]]
  then
      print_colored "red" "No databases available."
      print_colored "white" "Press any key to continue..."
      read
      cd ..
      source ./scripts/dive-into-database.sh
      dive_into_database
  else
      print_colored "white" "Your Existing Databases:\n"
      print_colored "purple" "$(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d')"
      print_colored "bwhite" "Enter the name of the database: "
      read database_name
      if [[ "$database_name" = '' ]]
      then
          print_colored "red" "Invalid name, Please enter a correct name."
          cd ..
          use_existing_database
      # db exists
      elif ! [[ -d "$database_name" ]]
      then
          print_colored "red" "This database doesn't exist."
          cd ..
          use_existing_database	
      # new db
      else
          cd "$database_name"
          print_colored "green" "The database loaded successfully."
          source ../../scripts/dive-into-tables.sh
          dive_into_table

      fi
  fi  
}