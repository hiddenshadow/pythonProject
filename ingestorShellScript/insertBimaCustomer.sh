#!/bin/bash

# For valid data max should be same as max user_id.
# As there is only single insert query to db, max count is 750, limited by length of the argument passed to nohup.
# COUNT=750
COUNT=3

STR=30
END=$(($STR+$COUNT-1))

DB_HOST='localhost'
DB_PORT=3306
DB_USER='root'
DB_PASSWORD='Bima1'
DB_DATABASE='allocator'

# DB_HOST='bima-mentor.coic6imdwwxx.ap-south-1.rds.amazonaws.com'
# DB_PORT=6603
# DB_USER='root'
# DB_PASSWORD='Hellobima'

VALUES=''

CREATED_DATE='NOW()'
CREATED_BY=10109

STATUS_MIN=1;
STATUS_MAX=1;

DEPENDANT_COUNT_MIN=1;
DEPENDANT_COUNT_MAX=3;

MSISDN_MIN=11111111;
MSISDN_MAX=19999999;

declare -a FIRST_NAMES=("Amir" "Sharuk" "Ritesh" "Prabhas" "Mohan" "Salman" "Sunil" "Rajni")
FIRST_NAMES_LEN=${#FIRST_NAMES[@]}

declare -a LAST_NAMES=("Khan" "Deshmuk" "Raju" "Lal" "Roy" "Bachan" "Shetty" "Das")
LAST_NAMES_LEN=${#LAST_NAMES[@]}

declare -a FIRST_NAMES_FEM=("Jhansi" "Aishwarya" "Vijaya" "Catherine" "Shamili" "Urmila" "Ramya" "Jaya")
FIRST_NAMES_FEM_LEN=${#FIRST_NAMES[@]}


for i in $(seq $STR $END)
do
  	echo ''
  	echo 'i:'$i;
	
	lna=$(shuf -i 0-$(($LAST_NAMES_LEN-1)) -n 1)
  	
  	DEPENDANT_COUNT=$(shuf -i $DEPENDANT_COUNT_MIN-$DEPENDANT_COUNT_MAX -n 1)
  	USER_ID=$i
  	# Last name same for all dependents
	DEP_LAST_NAME=${LAST_NAMES[$lna]}

  	echo 'DEPENDANT_COUNT: '$DEPENDANT_COUNT

  	for d in $(seq $DEPENDANT_COUNT_MIN $DEPENDANT_COUNT)
	do

		fn=$(shuf -i 0-$(($FIRST_NAMES_LEN-1)) -n 1)
  		
		MSISDN=$(shuf -i $MSISDN_MIN-$MSISDN_MAX -n 1)
		STATUS=$(shuf -i $STATUS_MIN-$STATUS_MAX -n 1)

		# Taking male names in case d is odd.
		rem=$(( $d % 2 )) 
		 
		if [ $rem -eq 0 ]
		then
		  DEP_FIRST_NAME=${FIRST_NAMES_FEM[$fn]}
		else
		  DEP_FIRST_NAME=${FIRST_NAMES[$fn]}
		fi

		# (user_id, first_name, last_name, msisdn, status, created_by, created_date)
		CUR_VALUE='('$USER_ID', "'$DEP_FIRST_NAME'", "'$DEP_LAST_NAME'", '$MSISDN', '$STATUS', '$CREATED_BY','$CREATED_DATE')'

		VALUES=$VALUES''$CUR_VALUE

		if [ $d -lt $DEPENDANT_COUNT ]; then
		VALUES=$VALUES','
		echo 'd:'$d
		fi

	done
	
	# ROLE_ID=$(shuf -i $ROLE_ID_MIN-$ROLE_ID_MAX -n 1)
	# CUR_VALUE='('$USER_ID', '$PARTNER_COUNTRY_ID', '$ROLE_ID', '$STATUS', '$CREATED_BY','$CREATED_DATE')'
	# VALUES=$VALUES''$CUR_VALUE

	if [ $i -lt $END ]; then
		VALUES=$VALUES','
	fi
done

# insert into allocator.bima_customer (user_id, first_name, last_name, msisdn, status, created_by, created_date) values (1, "fn", "ln", 898998, 1, 10109, NOW());
QUERY='insert into '$DB_DATABASE'.bima_customer (user_id, first_name, last_name, msisdn, status, created_by, created_date) values '

QUERY=$QUERY' '$VALUES';'

SSH_CMD="mysql -h'"$DB_HOST"' -P"$DB_PORT" -u'"$DB_USER"' -p'"$DB_PASSWORD"' -e'"$QUERY"'"

echo 'Executing query command : '$SSH_CMD;
# echo ''
eval nohup $SSH_CMD &> a.out

echo 'Done inserting dependent Bima customers for '$COUNT' Users.'