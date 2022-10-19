#! /bin/bash
#
# Databse management system project main file.

# including helper function file.
source ./helper-functions.sh

welcome_message

while true
do 
    if [ ! -d "./Databases" ]; then
    mkdir  ./Databases
    fi
    print_colored "green" "+------------------------------+"
    print_colored "green" "|------------DBMS--------------|"
    print_colored "green" "|------------------------------|"
    print_colored "green" "| 1. Dive into Our Database.   |"
    print_colored "green" "| 2. Exit.                     |"
    print_colored "green" "+------------------------------+"
    print_colored "bwhite" "Please Select a Service: \c"
    read REPLY
    case $REPLY in
    1 ) dive_into_database
    ;;
    2 ) close_program 
    ;;
    * ) print_colored "red" "Invalid choice, Please Select a Correct Service Number."
    ;;
    esac
    clear
done