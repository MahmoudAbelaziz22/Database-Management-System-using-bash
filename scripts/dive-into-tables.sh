#! /bin/bash

source ../../scripts/tables-functions.sh

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
    print_colored "green" "| 8. Exit.                     |"
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
    5 ) echo -e "display table"
    exit 
    ;;
    6 ) echo -e "display row"
    dive_into_table 
    ;;
    7 ) echo -e "delete row"
    dive_into_table 
    ;;
    8 ) exit
  
    ;;
    * ) print_colored "red" "Invalid choice, Please Select a Correct Service Number."
    ;;
    esac
}