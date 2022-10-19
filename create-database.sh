#! /bin/bash

# including helper function file.
source ./helper-functions.sh

function create_database() {
 

	print_colored "bwhite" "Enter the name of the database: "
	read database_name
    cd ./Databases
	# if null entry
	if [[ $database_name = "" ]]
    then
        print_colored "red" "Invalid name, Please enter a correct name."
        cd ..
        create_database
	# if special characters
	elif [[ $database_name =~ [/.:\|\-] ]]
    then
		print_colored "red" "You can't enter these characters => . / : - |"
        cd ..
        create_database
	# if database name exists		
	elif [[ -e $database_name ]]
    then
        print_colored "red" "This database name is already used."
        cd ..
        create_database
	# if new DB
	elif [[ $database_name =~ ^[a-zA-Z] ]]
    then
		mkdir -p "$database_name"
		cd "./$database_name" > /dev/null 2>&1
		newloc=`pwd`
		if [[ "$newloc" = `pwd` ]]
        then
            print_colored "green" "Database created sucessfully in $(pwd)"
            cd ../..
			./tables.sh
		else
			cd - > /dev/null 2>&1
            print_colored "red" "Can't access this location."
            cd ..
            create_database
			echo press any key
			read
		fi

	# if numbers or other special characters
	else
        print_colored "red" "Database name can't start with numbers or special characters."
        cd ..
        create_database
		echo press any key
		read
	fi
}