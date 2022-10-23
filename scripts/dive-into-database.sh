#! /bin/bash
source ./helper-functions.sh

# to clear screen.
clear

#######################################
# Dive into databses screen function.
# Arguments:
#   Non
# Usage:      dive_into_database
#######################################
function dive_into_database() {
    
    cd ./Databases
    echo -e "\t\tYour Existing Databases:\n"
    if [[ $(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d' | wc -l) = 0 ]]
    then
      print_colored "red" "No databases available."
    else
      print_colored "purple" "$(find -maxdepth 1 -type d | cut -d'/' -f2 | sed '1d')"
    fi
    cd ..
    
    print_colored "green" "+------------------------------+"
    print_colored "green" "|----------Database------------|"
    print_colored "green" "|------------------------------|"
    print_colored "green" "| 1. Create a new database.    |"
    print_colored "green" "| 2. Drop Database.            |"
    print_colored "green" "| 3. Use existing Database.     |"
    print_colored "green" "| 4. Exit.                     |"
    print_colored "green" "+------------------------------+"

    print_colored "bwhite" "Please Select a Service: \c"
    read REPLY
    case $REPLY in
    1 ) source ./scripts/create-database.sh
        create_database
     exit
    ;;
    2 ) source ./scripts/drop-database.sh
        drop_database
    exit
    ;;
    3 ) source ./scripts/use-existing-database.sh
        use_existing_database
    exit
    ;;
    4 ) close_program 
    ;;
    * ) print_colored "red" "Invalid choice, Please Select a Correct Service Number."
    ;;
    esac
}

