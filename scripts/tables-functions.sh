#! /bin/bash

#######################################
# this function to check datatype matching.
# Arguments:
#   Non
# Usage:      check_dataType
#######################################
function check_dataType() {

	datatype=$(head -1 $2 | cut -d ':' -f$3 | awk -F "-" 'BEGIN { RS = ":" } {print $2}')
	if [[ "$1" = '' ]]
	then
		echo 1
	elif [[ "$1" = -?(0) ]]
	then
		echo 0 # error!
	elif [[ "$1" = ?(-)+([0-9])?(.)*([0-9]) ]]
	then
		if [[ $datatype == integer ]]
		then
			# datatype integer and the input is integer
			echo 1
		else
			# datatype string and input is integer
			echo 1
		fi
	else
		if [[ $datatype == integer ]]
		then
			# datatype integer and input is string
			echo 0 
		else
			# datatype string and input is string
			echo 1
		fi
	fi
}
#######################################
# this function to check value size matching.
# Arguments:
#   Non
# Usage:      check_size
#######################################
function check_size() {

	datasize=$(head -1 $2 | cut -d ':' -f$3 | awk -F "-" 'BEGIN { RS = ":" } {print $3}')
	if [[ "${#1}" -le $datasize ]]
	then
		echo 1
	else
		echo 0
	fi
}

#######################################
# this function to create metadata for a value.
# Arguments:
#   Non
# Usage:      createMetaData
#######################################
function createMetaData() {
	# create the metadata
	if [[ -f "$table_name" ]]
	then
		# number of columns
		is_not_valid=true
		while $is_not_valid
		do
			print_colored "bwhite" "How many columns do you want?"
			read number_of_column
			if [[ "$number_of_column" = +([1-9])*([0-9]) ]]
			then
				is_not_valid=false
			else
				print_colored "red" "Invalid entry."
			fi
		done

		## primary key name
		not_valid_entry=true
		while $not_valid_entry
		do
			print_colored "bwhite" "Enter primary key name:"
			read primary_key_name
			# null entry
			if [[ $primary_key_name = "" ]]
			then
				print_colored "red" "Invalid entry, please enter a correct name."
			# special characters
			elif [[ $primary_key_name =~ [/.:\|\-] ]]
			then
				print_colored "red" "You can't enter these characters => . / : - |"
			# valid entry
			elif [[ $primary_key_name =~ ^[a-zA-Z] ]]
			then
				echo -n "$primary_key_name" >> "$table_name"
				echo -n "-" >> "$table_name"
				not_valid_entry=false
			# numbers or other special characters
			else
				print_colored "red" "Primary key can't start with numbers or special characters."	
			fi
		done
		# primary key dataType
		not_valid_datatype=true
		while $not_valid_datatype
		do
			print_colored "bwhite" "Enter primary key datatype:"
			select choice in "integer" "string"
			do
				if [[ "$REPLY" = "1" || "$REPLY" = "2" ]]
				then
					echo -n "$choice" >> "$table_name"
					echo -n "-" >> "$table_name"
					not_valid_datatype=false
				else
					print_colored "red" "Invalid choice."
				fi
				break
			done
		done
		# primary key size
		not_valid_size=true
		while $not_valid_size
		do
			print_colored "bwhite" "Enter primary key size:"
			read size
			if [[ "$size" = +([1-9])*([0-9]) ]]
			then
				echo -n "$size" >> "$table_name"
				echo -n ":" >> "$table_name"
				not_valid_size=false
			else
				print_colored "red" "Invalid entry"
			fi
		done
		## iterate over the enterd num of columns to enter its metadata
		for (( i = 1; i < number_of_column; i++ ))
		do
			# field name
			not_valid_entry=true
			while $not_valid_entry
			do
				print_colored "bwhite" "Enter field $[i+1] name:"
				read field_name
				# null entry
				if [[ $field_name = "" ]]
				then
					print_colored "red" "Invalid entry, please enter a correct name."			
				# special characters
				elif [[ $field_name =~ [/.:\|\-] ]]
				then
					print_colored "red" "You can't enter these characters => . / : - |"
				# valid entry
				elif [[ $field_name =~ ^[a-zA-Z] ]]
				then
					echo -n "$field_name" >> "$table_name"
					echo -n "-" >> "$table_name"
					not_valid_entry=false
				# numbers or other special characters
				else
					print_colored "red" "field name can't start with numbers or special characters."
				fi
			done
			# field dataType
			not_valid_datatype=true
			while $not_valid_datatype
			do
				print_colored "bwhite" "Enter field $[i+1] datatype"
				select choice in "integer" "string"
				do
					if [[ "$REPLY" = "1" || "$REPLY" = "2" ]]
					then
						echo -n "$choice" >> "$table_name"
						echo -n "-" >> "$table_name"
						not_valid_datatype=false
					else
						print_colored "red" "Invalid choice."

					fi
					break
				done
			done
			# field size
			not_valid_size=true
			while $not_valid_size
			do
				print_colored "bwhite" "Enter field $[i+1] size:"
				read size
				if [[ "$size" = +([1-9])*([0-9]) ]]
				then
					echo -n "$size" >> "$table_name"
					# if last column
					if [[ i -eq $number_of_column-1 ]]
					then
						echo $'\n' >> "$table_name"
						print_colored "green" "table created successfully."
						echo press any key
						read
				
					# next column
					else
						echo -n ":" >> "$table_name"
					fi
					not_valid_size=false
				else
					print_colored "red" "Invalid entry."
				fi
			done
		done
	else
		print_colored "red" "Invalid entry."
		echo press any key
		read
	fi
}
#######################################
# this function to create a table.
# Arguments:
#   Non
# Usage:      create_table
#######################################
function create_table() { 
	# table name
	print_colored "bwhite" "Enter table's name:"
	read table_name	
	# null entry
	if [[ $table_name = "" ]]
	then
		print_colored "red" "Invalid entry, please enter a correct name."
		create_table
	# special characters
	elif [[ $table_name =~ [/.:\|\-] ]]
	then
		print_colored "red" "You can't enter these characters => . / : - |"
		create_table
	# table name exists
	elif [[ -e "$table_name" ]]
	then
		print_colored "red" "This table name exists."
		create_table
	# new table
	elif  [[ $table_name =~ ^[a-zA-Z] ]]
	then
		touch "$table_name"
		createMetaData;
		dive_into_table
	else
		print_colored "red" "Table name can't start with numbers or special characters."
		create_table
	fi
}
#######################################
# this function to update a table.
# Arguments:
#   Non
# Usage:      update_table
#######################################
function update_table() {
	# choose table
	print_colored "bwhite" "Enter name of the table:"
	read table_name
	# not exist
	if ! [[ -f "$table_name" ]]
	then
		print_colored "red" "this table doesn't exist."
		update_table
	else
		# table exists
		echo Enter primary key \"$(head -1 "$table_name" | cut -d ':' -f1 |\
		awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$table_name"\
		| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$table_name"\
		| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $3}') of the record
		read REPLY
		recordNum=$(cut -d ':' -f1 "$table_name" | sed '1d'\
		| grep -x -n -e "$REPLY" | cut -d':' -f1)
		# null entry
		if [[ "$REPLY" == '' ]]
		then
			print_colored "red" "No entry."
		# record not exists
		elif [[ "$recordNum" = '' ]]
		then
			print_colored "red" "this primary key doesn't exist."
		# record exists
		else
			let recordNum=$recordNum+1
			# to get number of columns in table
			number_of_column=$(head -1 "$dbtable" | awk -F: '{print NF}') 
			# to show the other values of record
			echo "---------------------------------------------"
			print_colored "bwhite" "other fields and values of this record:"
			for (( i = 2; i <= number_of_column; i++ ))
			do
				echo \"$(head -1 $table_name | cut -d ':' -f$i |\
				awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$table_name" | cut -d ':' -f$i |\
				awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$table_name" | cut -d ':' -f$i |\
				awk -F "-" 'BEGIN { RS = ":" } {print $3}'): $(sed -n "${recordNum}p" "$table_name" | cut -d: -f$i)
			done
		    echo "----------------------------------------------"
		    # to show the other fields' names of this record
			print_colored "white" "record fields:"
			option=$(head -1 $table_name | awk 'BEGIN{ RS = ":"; FS = "-" } {print $1}')
			echo "$option"
			getFieldName=true
			while $getFieldName
			do
				echo "----------------------------------------------"
				print_colored "bwhite" "Enter field name to update:"
				read REPLY
				# null entry
				if [[ "$REPLY" = '' ]]
				then
				    print_colored "red" "Invalid entry."
				# field name not exists
				elif [[ $(echo "$option" | grep -x "$REPLY") = "" ]]
				then
				    print_colored "red" "no such field with the entered name, please enter a valid field name."
				# field name exists
				else
				# get field number
					fieldnum=$(head -1 "$table_name" | awk 'BEGIN{ RS = ":"; FS = "-" } {print $1}'\
					| grep -x -n "$REPLY" | cut -d: -f1)
					updatingField=true
					while $updatingField
					do
						# updating field's primary key
						if [[ "$fieldnum" = 1 ]]
						then
							echo enter primary key \"$(head -1 "$table_name" | cut -d ':' -f1 |\
							awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$table_name"\
							| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$table_name"\
							| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $3}')
							read REPLY
							check_type=$(check_dataType "$REPLY" "$table_name" 1)
							check_size=$(check_size "$REPLY" "$table_name" 1)
							pk_used=$(cut -d ':' -f1 "$table_name" | awk '{if(NR != 1) print $0}' | grep -x -e "$REPLY")
							# null entry
							if [[ "$REPLY" == '' ]]
							then
							    print_colored "red" "No entry, id can't be null."
							#match datatype
							elif [[ "$check_type" == 0 ]]
							then
								print_colored "red" "Invalid entry."
							# not matching size
							elif [[ "$check_size" == 0 ]]
							then
								print_colored "red" "entry size invalid."
								# pk is used
							elif ! [[ "$pk_used" == '' ]]
							then
								print_colored "red" "this primary key already used"
								# pk is valid
							else 
								awk -v fn="$fieldnum" -v rn="$recordNum" -v nv="$REPLY"\
								'BEGIN { FS = OFS = ":" } { if(NR == rn)	$fn = nv } 1' "$table_name"\
								> "$table_name".new && rm "$table_name" && mv "$table_name".new "$table_name"
								updatingField=false
								getFieldName=false
							fi
							# updating other field 
						else
							updatingField=true
							while $updatingField
							do
								echo enter \"$(head -1 $table_name | cut -d ':' -f$fieldnum |\
								awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$table_name" | cut -d ':' -f$fieldnum |\
								awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$table_name" | cut -d ':' -f$fieldnum |\
								awk -F "-" 'BEGIN { RS = ":" } {print $3}')
								read
								check_type=$(check_dataType "$REPLY" "$table_name" "$fieldnum")
								check_size=$(check_size "$REPLY" "$table_name" "$fieldnum")
								# match datatype
								if [[ "$check_type" == 0 ]]
								then
								    print_colored "red" "Invalid entry."
								# not matching size
								elif [[ "$check_size" == 0 ]]
								then
									print_colored "red" "Invalid entry size."
									# entry is valid
								else
									awk -v fn="$fieldnum" -v rn="$recordNum" -v nv="$REPLY"\
									'BEGIN { FS = OFS = ":" } { if(NR == rn)	$fn = nv } 1' "$table_name"\
									> "$table_name".new && rm "$table_name" && mv "$table_name".new "$table_name"
									updatingField=false
									getFieldName=false
								fi
							done
						fi
					done
					print_colored "green" "field updated successfully."
				fi
			done
	    fi
		echo press any key
		read
    fi
}
#######################################
# this function to delete a table.
# Arguments:
#   Non
# Usage:      delete_table
#######################################
function delete_table() {

	print_colored "bwhite" "Enter name of the table you want to delete:"
	read table_name
	# not exist
	if ! [[ -f "$table_name" ]]
	then
		print_colored "red" "this table doesn't exist."
        delete_table
	# exists
	else
	    clear
        print_colored "green" "+------------------------------+"
        print_colored "green" "|-------Are you sure?----------|"
        print_colored "green" "|------------------------------|"
        print_colored "green" "| 1. Yes.                      |"
        print_colored "green" "| 2. No.                       |"
        print_colored "green" "+------------------------------+"
        print_colored "bwhite" "Are you sure, you want to delete $table_name table:"
		read REPLY
        case $REPLY in
			1 )
				rm "$table_name"
				print_colored "green" "table deleted."
				echo press any key
				read
				;;
			2 ) dive_into_table
				;;
			* ) print_colored "red" "Invalid entry."
				;;
		esac
	fi
}
#######################################
# this function to insert data into table.
# Arguments:
#   Non
# Usage:      insert_data
#######################################
function insert_data() {
	# choose the table
	print_colored "bwhite" "Enter name of the table:"
	read table_name
	# not exist
	if ! [[ -f "$table_name" ]]
	then
		print_colored "red" "this table doesn't exist."
        insert_data
	else
		## table exists
		is_inserting_data=true
		while $is_inserting_data
		do
			# enter pk
			print_colored "bwhite" "Enter primary key \"$(head -1 "$table_name" | cut -d ':' -f1 | awk -F "-" '{print $1}')\" of type $(head -1 "$table_name" | cut -d ':' -f1 | awk -F "-" '{print $2}') and size $(head -1 "$table_name" | cut -d ':' -f1 | awk -F "-" '{print $3}')"
			read REPLY
			# match data & size
			check_type=$(check_dataType "$REPLY" "$table_name" 1)
			check_size=$(check_size "$REPLY" "$table_name" 1)
			#=> print all records except first record
			pk_used=$(cut -d ':' -f1 "$table_name" | awk '{if(NR != 1) print $0}' | grep -x -e "$REPLY")
			# null entry
			if [[ "$REPLY" == '' ]]
			then
				print_colored "red" "No entry."
			# special characters
			elif [[ $REPLY =~ [/.:\|\-] ]]
			then
				print_colored "red" "You can't enter these characters => . / : - | "
			# not matching datatype 
			elif [[ "$check_type" == 0 ]]
			then 
				print_colored "red" "Invalid entry."
			# not matching size	
			elif [[ "$check_size" == 0 ]]
			then
				print_colored "red" "Invalid entry size."
			#! if primary key exists
			elif ! [[ "$pk_used" == '' ]]
			then
				print_colored "red" "this primary key is already used."
			# primary key is valid
			else 
				echo -n "$REPLY" >> "$table_name"
				echo -n ':' >> "$table_name"
				# to get number of columns in table
				number_of_column=$(head -1 "$table_name" | awk -F: '{print NF}')
				## to iterate over the columns after the primary key, in order to enter its data
				for (( i = 2; i <= number_of_column; i++ ))
				do
				   # enter other data
				   inserting_other_data=true
				   while $inserting_other_data
				   do
						print_colored "bwhite" "Enter \"$(head -1 "$table_name" | cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$table_name" | cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$table_name" | cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $3}')"
						read REPLY
						# match data with its col datatype & size
						check_type=$(check_dataType "$REPLY" "$table_name" "$i")
						check_size=$(check_size "$REPLY" "$table_name" "$i")
						# not matching datatype
						if [[ "$check_type" == 0 ]]
						then
							print_colored "red" "invalid entry."
						# not matching size
						elif [[ "$check_size" == 0 ]]
						then
							print_colored "red" "Invalid entry size."
						# special characters
						elif [[ $REPLY =~ [/.:\|\-] ]]
						then
							print_colored "red" "You can't enter these characters => . / : - |"
						# entry is valid
						else
							# if last column
							if [[ i -eq $number_of_column ]]
							then
								echo "$REPLY" >> "$table_name"
								inserting_other_data=false
								is_inserting_data=false
								print_colored "green" "Inserted successfully."
							else
							# next column 
								echo -n "$REPLY": >> "$table_name"
								inserting_other_data=false
							fi
						fi
				    done
			    done
		    fi
	    done
	    echo press any key
	    read
    fi
}
#######################################
# this function to display a table data into screen.
# Arguments:
#   Non
# Usage:      display_table
#######################################
function display_table {
	# choose table
	print_colored "bwhite" "Enter table's name:"
	read table_name
	##########
	# not exist
	if ! [[ -f "$table_name" ]]
	then
		print_colored "red" "this table doesn't exist."
		display_table
	else
		## table exists
		# display table's data
		print_colored "green" "------------------------------------------------------------"
		print_colored "green" "$(head -1 "$table_name" | awk 'BEGIN{ RS = ":"; FS = "-" } {print $1}' | awk 'BEGIN{ORS="\t"} {print $0}')"
		print_colored "green" "------------------------------------------------------------"
		print_colored "green" " $(sed '1d' "$table_name" | awk -F: 'BEGIN{OFS="\t"} {for(n = 1; n <= NF; n++) $n=$n}  1')"
		print_colored "green" "------------------------------------------------------------"
		print_colored "white" "press any key:"
		read
	fi
}
#######################################
# this function to display a row data into screen.
# Arguments:
#   Non
# Usage:      display_row
#######################################
function display_row {
	# choose table
	print_colored "bwhite" "Enter table's name:"
	read table_name
	# not exist
	if ! [[ -f "$table_name" ]]
	then
		print_colored "red" "this table doesn't exist."
		display_row
	else
		## table exists
		# enter pk
		print_colored "bwhite" "Enter primary key \"$(head -1 "$table_name" | cut -d ':' -f1 |\
		awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$table_name"\
		| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$table_name"\
		| cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $3}') of the record "
		read REPLY
		record_number=$(cut -d ':' -f1 "$table_name" | sed '1d'\
		| grep -x -n -e "$REPLY" | cut -d':' -f1)
		# null entry
		if [[ "$REPLY" == '' ]]
		then
			print_colored "red" "No entry."
		# record not exists
		elif [[ "$record_number" = '' ]]
		then
			print_colored "red" "this primary key doesn't exist."
		# record exists
		else
			let record_number=$record_number+1
			number_of_column=$(head -1 "$table_name" | awk -F: '{print NF}') 
			# to show the other values of record
			print_colored "bwhite" "fields and values of this record:"
			for (( i = 2; i <= number_of_column; i++ ))
			do
				print_colored  "green" "\"$(head -1 $table_name | cut -d ':' -f$i | awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" : $(sed -n "${record_number}p" "$table_name" | cut -d: -f$i)"
			done
		fi
		print_colored "white" "press any key"
		read
	fi
}
#######################################
# this function to delete a row data.
# Arguments:
#   Non
# Usage:      display_row
#######################################
function delete_row {
	# choose table
	print_colored "bwhite" "Enter table's name:"
	read table_name
	# not exist
	if ! [[ -f "$table_name" ]]
	then
		print_colored "red" "this table doesn't exist."
		delete_row
	else
		# table exists
		print_colored "bwhite" "\"Enter primary key \"$(head -1 "$table_name" | cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $1}')\" of type $(head -1 "$table_name" | cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $2}') and size $(head -1 "$table_name" | cut -d ':' -f1 | awk -F "-" 'BEGIN { RS = ":" } {print $3}')\" of the record to delete"
		read REPLY
		# get Number of this record
		record_number=$(cut -d ':' -f1 "$table_name" | awk '{if(NR != 1) print $0}' | grep -x -n -e "$REPLY" | cut -d':' -f1)
		# null entry
		if [[ "$REPLY" == '' ]]
		then
			print_colored "red" "No entry."
		# record not exists
		elif [[ "$record_number" = '' ]]
		then
			print_colored "red" "this primary key doesn't exist."
		# record exists
		else
		    clear
            print_colored "green" "+------------------------------+"
            print_colored "green" "|-------Are you sure?----------|"
            print_colored "green" "|------------------------------|"
            print_colored "green" "| 1. Yes.                      |"
            print_colored "green" "| 2. No.                       |"
            print_colored "green" "+------------------------------+"
            print_colored "bwhite" "Are you sure, you want to delete $table_name table:"
		    read REPLY
            case $REPLY in
              1 )
				  let record_number=$record_number+1
				  sed -i "${record_number}d" "$table_name"
				  print_colored "green" "Record deleted successfully."
				  ;;
			  2 ) dive_into_table
				  ;;
			  * ) print_colored "red" "Invalid entry."
				  ;;
		    esac
		fi
		print_colored "white" "press any key"
		read
	fi
}