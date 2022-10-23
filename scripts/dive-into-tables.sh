#! /bin/bash

#import tables-functions.sh file.
source ../../scripts/tables-functions.sh

#######################################
# Dive into tables screen function.
# Arguments:
#   Non
# Usage:      dive_into_table
#######################################
function dive_into_table(){
    clear
    print_colored "green" "+------------------------------+"
    print_colored "green" "|------------Table-------------|"
    print_colored "green" "|------------------------------|"
    print_colored "green" "| 1. Create table.             |"
    print_colored "green" "| 2. Update table.             |"
    print_colored "green" "| 3. Delete table.             |"
    print_colored "green" "| 4. Insert into table.        |"
    print_colored "green" "| 5. Display table.            |"
    print_colored "green" "| 6. Display row.              |"
    print_colored "green" "| 7. Delete row.               |"
    print_colored "green" "| 8. Back.                     |"
    print_colored "green" "+------------------------------+"

    print_colored "bwhite" "Please Select a Service: \c"
    read REPLY
    case $REPLY in
        1 ) create_table
        ;;
        2 ) update_table
            dive_into_table
            ;;
        3 ) delete_table
            dive_into_table
            ;;
        4 ) insert_data
            dive_into_table 
            ;;
        5 ) display_table
            dive_into_table 
            ;;
        6 ) display_row
            dive_into_table 
            ;;
        7 ) delete_row
            dive_into_table 
            ;;
        8 ) cd ../..
            source ./scripts/dive-into-database.sh
            dive_into_database 
            ;;
        * ) print_colored "red" "Invalid choice, Please Select a Correct Service Number."
            ;;
    esac
}