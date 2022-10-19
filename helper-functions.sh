#######################################
# Print Colored Text to screen.
# Arguments:
#   COLOR,Text    
# Usage:      print_colored "color" "text" 
#######################################
function print_colored() {
   case $1 in
     "green") COLOR="\033[0;32m" ;;
     "red") COLOR="\033[0;31m" ;;
     "white") COLOR="\033[0;37m" ;;
     "bwhite") COLOR="\033[1;37m" ;;
     "blue") COLOR="\033[44m" ;;
     "purple") COLOR="\033[0;35m" ;;
      "*") COLOR="\033[0m"
    esac
   echo -e "${COLOR} $2 ${NC}" 
}
#######################################
# Print welcome messages to screen.
# Arguments:
#   Non
# Usage:      welcome_message
#######################################
function welcome_message() {
    clear
    print_colored "blue" "************************************************************"
    print_colored "blue" "**             Bash Shell Scripting Project               **"
    print_colored "blue" "**              Database Management System                **"
    print_colored "blue" "**                                                        **"
    print_colored "blue" "**          Created by: Eng. Mahmoud Abdelaziz            **"
    print_colored "blue" "************************************************************"

}
#######################################
# Close the program function.
# Arguments:
#   Non
# Usage:      close_program
#######################################
function close_program() {
    clear
    print_colored "green" "+------------------------------+"
    print_colored "green" "| 1. Yes                       |"
    print_colored "green" "| 2. No                        |"
    print_colored "green" "+------------------------------+"
    print_colored "white" "Are you sure you want to close the program? \c"
    read REPLY
        case $REPLY in
        1 ) clear
            exit ;;
        2 )  ;;
        * ) print_colored "red" "Invalid choice, Please Select a Correct Service Number." ;;
        esac
}
#######################################
# Dive into databses screen function.
# Arguments:
#   Non
# Usage:      dive_into_database
#######################################
function dive_into_database() {
    clear
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
    print_colored "green" "| 3. Use existing Databas.     |"
    print_colored "green" "| 4. Exit.                     |"
    print_colored "green" "+------------------------------+"

    print_colored "bwhite" "Please Select a Service: \c"
    read REPLY
    case $REPLY in
    1 ) source ./create-database.sh
        create_database
     exit
    ;;
    2 ) echo "Drop Database."
    exit
    ;;
    3 ) echo "Use existing Databas." 
    exit
    ;;
    4 ) close_program 
    ;;
    * ) print_colored "red" "Invalid choice, Please Select a Correct Service Number."
    ;;
    esac
}

