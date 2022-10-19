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
