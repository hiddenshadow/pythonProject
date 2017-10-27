#!/usr/bin/env bash

# https://kvz.io/blog/2013/11/21/bash-best-practices/

# README:
# 1. Script takes count as input. Inserts those many number of users in total in bima_user table.
# 2. For each user inserted, a role is also inserted in bima_user_role_permission table.
# 3. For each user a customer entry is also made in bima_customer.
# 4. And for each customer, Gender & Age entries are made in customer meta data customer_meta_data table.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

<<<<<<< 766f1285b7cb26497433150293debb439f455873


COUNT=2
=======
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters. Pass number of users to be created as first parameter, as"
    echo '	/usr/bin/env bash ingestAllData.sh [<COUNT>]'
    echo 'Example usage:'
    echo '/usr/bin/env bash ingestAllData.sh 3'
    exit 1
fi


COUNT=$1
>>>>>>> Ingest All Data. Inserted Customer corresponding to User. + gitignore.

STR=1
END=$(($STR+$COUNT-1))

DB_HOST='localhost'
DB_PORT=3306
DB_USER='root'
DB_PASSWORD='Bima1'
DB_DATABASE='allocator'

declare -a FIRST_NAMES=("Rahul" "Suresh" "Mahendra" "Murali" "Ashwin" "Virat" "Sourav" "Venkat")
FIRST_NAMES_LEN=${#FIRST_NAMES[@]}

declare -a FIRST_NAMES_FEM=("Jhansi" "Aishwarya" "Vijaya" "Catherine" "Shamili" "Urmila" "Ramya" "Jaya")
FIRST_NAMES_FEM_LEN=${#FIRST_NAMES[@]}

declare -a LAST_NAMES=("Dravid" "Raina" "Dhoni" "Karthik" "Ramchandra" "Kohli" "Ganguly" "Laxman")
LAST_NAMES_LEN=${#LAST_NAMES[@]}

CREATED_DATE='NOW()'
CREATED_BY=10109
USER_PASSWORD='r5SPC2M0xdboIsm8jPJANA=='
CID_MIN=1; 
CID_MAX=5;
ROLE_ID_MIN=1;
ROLE_ID_MAX=4;
USER_ROLE_STATUS_MIN=1;
USER_ROLE_STATUS_MAX=1;
DEPENDANT_COUNT_MIN=1;
DEPENDANT_COUNT_MAX=3;
MSISDN_MIN=11111111;
MSISDN_MAX=19999999;
DEP_STATUS_MIN=1;
DEP_STATUS_MAX=1;
AGE_MIN=1;
AGE_MAX=111;
VALUES=''

SSH_CMD="mysql -h'"$DB_HOST"' -P"$DB_PORT" -u'"$DB_USER"' -p'"$DB_PASSWORD"' -s -N -e'"

USER_INSERT_QUERY='insert into '$DB_DATABASE'.bima_user (user_name, user_first_name, user_last_name, user_password, user_mobile, user_email, created_by, created_date) values '

SELECT_LAST_INSERTED='SELECT LAST_INSERT_ID();'

INSERT_USER_ROLE_QUERY='insert ignore into '$DB_DATABASE'.bima_user_role_permission (user_id, partner_country_id, role_id, status, created_by, created_date) values '

INSERT_DEPENDANT_QUERY='insert into '$DB_DATABASE'.bima_customer (user_id, first_name, last_name, msisdn, status, created_by, created_date) values '

INSERT_DEP_META_QUERY='insert ignore into '$DB_DATABASE'.customer_meta_data (customer_id, meta_key, meta_value, created_by, created_date) values '


for i in $(seq $STR $END)
do
  	echo 'Inserting user number: '$i;
  	CUR_VALUE=''

  	fn=$(shuf -i 0-$(($FIRST_NAMES_LEN-1)) -n 1)
  	lna=$(shuf -i 0-$(($LAST_NAMES_LEN-1)) -n 1)
  	USER_MOBILE=$(shuf -i 1230000000-1239999999 -n 1)

	CUR_TIME_SEC=$(date +%s)
	USER_NAME='un_'$CUR_TIME_SEC'_'$i
	USER_LAST_NAME=${LAST_NAMES[$lna]}
	USER_EMAIL=$USER_NAME'@junk.kom'

	# Taking male names in case i is odd.
	usr_rem=$(( $i % 2 ))

	if [ $usr_rem -eq 0 ]
	then
		USER_FIRST_NAME=${FIRST_NAMES_FEM[$fn]}
		USER_GENDER="FEMALE"
	else
		USER_FIRST_NAME=${FIRST_NAMES[$fn]}
		USER_GENDER="MALE"
	fi


  	CUR_VALUE='("'$USER_NAME'","'$USER_FIRST_NAME'","'$USER_LAST_NAME'","'$USER_PASSWORD'",'$USER_MOBILE',"'$USER_EMAIL'",'$CREATED_BY','$CREATED_DATE')'
	
	CUR_USER_INSERT_QUERY=$USER_INSERT_QUERY' '$CUR_VALUE';'$SELECT_LAST_INSERTED

	CUR_USER_INSERT_QUERY=$SSH_CMD''$CUR_USER_INSERT_QUERY"'"
	# echo 'Executing query: '$CUR_USER_INSERT_QUERY;
	eval $CUR_USER_INSERT_QUERY &> a.out

	LAST_USER_ID=`cat a.out | tail -1 | awk '{ print $1}'`
	# echo '	LAST_USER_ID: '$LAST_USER_ID

	if [ $LAST_USER_ID -gt 0 ]
	then
		# echo "	inserting user role for: "$LAST_USER_ID

		PARTNER_COUNTRY_ID=$(shuf -i $CID_MIN-$CID_MAX -n 1)
		ROLE_ID=$(shuf -i $ROLE_ID_MIN-$ROLE_ID_MAX -n 1)
		USER_ROLE_STATUS=$(shuf -i $USER_ROLE_STATUS_MIN-$USER_ROLE_STATUS_MAX -n 1)


		INSERT_USER_ROLE_VAL='('$LAST_USER_ID', '$PARTNER_COUNTRY_ID', '$ROLE_ID', '$USER_ROLE_STATUS', '$CREATED_BY','$CREATED_DATE')'
		CUR_INSERT_USER_ROLE=$INSERT_USER_ROLE_QUERY' '$INSERT_USER_ROLE_VAL';'$SELECT_LAST_INSERTED
		CUR_INSERT_USER_ROLE=$SSH_CMD''$CUR_INSERT_USER_ROLE"'"

		# echo 'Executing query : '$CUR_INSERT_USER_ROLE;
		eval $CUR_INSERT_USER_ROLE &> a.out

		LAST_USER_ROLE_ID=`cat a.out | tail -1 | awk '{ print $1}'`
		echo '	LAST_USER_ROLE_ID: '$LAST_USER_ROLE_ID

		if [ $LAST_USER_ID -le 0 ]
		then
			echo 'Error inserting user role for '$LAST_USER_ID
			break
		fi

		echo "		Inserting customers for: "$LAST_USER_ID
		DEPENDANT_COUNT=$(shuf -i $DEPENDANT_COUNT_MIN-$DEPENDANT_COUNT_MAX -n 1)
		DEP_LAST_NAME=$USER_LAST_NAME

		DEPENDANT_COUNT=$(( $DEPENDANT_COUNT + 1 )) # Adding customer entry corresponding to User.

		echo '		DEPENDANT_COUNT: '$DEPENDANT_COUNT
		for d in $(seq $DEPENDANT_COUNT_MIN $DEPENDANT_COUNT)
		do
			echo '		Inserting customer '$d', for user: '$LAST_USER_ID
			fn=$(shuf -i 0-$(($FIRST_NAMES_LEN-1)) -n 1)

			MSISDN=$(shuf -i $MSISDN_MIN-$MSISDN_MAX -n 1)
			DEP_STATUS=$(shuf -i $DEP_STATUS_MIN-$DEP_STATUS_MAX -n 1)

			# Taking male names in case d is odd.
			rem=$(( $d % 2 ))

			if [ $rem -eq 0 ]
			then
				DEP_FIRST_NAME=${FIRST_NAMES_FEM[$fn]}
				GENDER_VAL="FEMALE"
			else
				DEP_FIRST_NAME=${FIRST_NAMES[$fn]}
				GENDER_VAL="MALE"
			fi

			# Using User data for creating customer entry for first entry.
			if [ $d -eq 1 ]
			then
				DEP_FIRST_NAME=$USER_FIRST_NAME
				GENDER_VAL=$USER_GENDER
			fi


			# (user_id, first_name, last_name, msisdn, status, created_by, created_date)
			CUR_INSERT_DEP_VALUE='('$LAST_USER_ID', "'$DEP_FIRST_NAME'", "'$DEP_LAST_NAME'", '$MSISDN', '$DEP_STATUS', '$CREATED_BY','$CREATED_DATE')'
			CUR_INSERT_DEPENDANT_QUERY=$INSERT_DEPENDANT_QUERY' '$CUR_INSERT_DEP_VALUE';'$SELECT_LAST_INSERTED
			CUR_INSERT_DEPENDANT_QUERY=$SSH_CMD''$CUR_INSERT_DEPENDANT_QUERY"'"

			# echo 'Executing query : '$CUR_INSERT_DEPENDANT_QUERY;
			eval $CUR_INSERT_DEPENDANT_QUERY &> a.out

			LAST_DEPENDANT_ID=`cat a.out | tail -1 | awk '{ print $1}'`
			echo '		LAST_DEPENDANT_ID: '$LAST_DEPENDANT_ID

			if [ $LAST_DEPENDANT_ID -le 0 ]
			then
				echo 'Error inserting customer for user: '$LAST_USER_ID
				break
			else
				# echo '			Adding meta data, Gender for customer: '$LAST_DEPENDANT_ID

				CUR_META_VALUES=''

				CUSTOMER_ID=$LAST_DEPENDANT_ID
			  	META_KEY="GENDER"
			  	META_VALUE=$GENDER_VAL

				# (customer_id, meta_key, meta_value, created_by, created_date)
			  	CUR_META_VALUES='('$CUSTOMER_ID',"'$META_KEY'","'$META_VALUE'",'$CREATED_BY','$CREATED_DATE')'

				CUR_INS_DEP_META_QRY=$INSERT_DEP_META_QUERY' '$CUR_META_VALUES';'$SELECT_LAST_INSERTED

			  	CUR_INS_DEP_META_QRY=$SSH_CMD''$CUR_INS_DEP_META_QRY"'"

				# echo 'Executing query : '$CUR_INS_DEP_META_QRY;
				eval $CUR_INS_DEP_META_QRY &> a.out

				LAST_DEPENDANT_META_ID=`cat a.out | tail -1 | awk '{ print $1}'`
				echo '			Gender Meta data Id: '$LAST_DEPENDANT_META_ID

				if [ $LAST_DEPENDANT_META_ID -le 0 ]
				then
					echo 'Error inserting meta data Gender for '$LAST_DEPENDANT_ID
					break
				fi

				# echo '			Adding meta data, Age for customer: '$LAST_DEPENDANT_ID
				META_KEY="AGE"
			  	META_VALUE=$(shuf -i $AGE_MIN-$AGE_MAX -n 1)

			  	CUR_META_VALUES='('$CUSTOMER_ID',"'$META_KEY'","'$META_VALUE'",'$CREATED_BY','$CREATED_DATE')'

				CUR_INS_DEP_META_QRY=$INSERT_DEP_META_QUERY' '$CUR_META_VALUES';'$SELECT_LAST_INSERTED

			  	CUR_INS_DEP_META_QRY=$SSH_CMD''$CUR_INS_DEP_META_QRY"'"

				# echo 'Executing query : '$CUR_INS_DEP_META_QRY;
				eval $CUR_INS_DEP_META_QRY &> a.out

				LAST_DEPENDANT_META_ID=`cat a.out | tail -1 | awk '{ print $1}'`
				echo '			Age Meta data Id: '$LAST_DEPENDANT_META_ID

				if [ $LAST_DEPENDANT_META_ID -le 0 ]
				then
					echo 'Error inserting meta data, Age for '$LAST_DEPENDANT_ID
					break
				fi
			fi

		done

	else
		echo 'Error inserting user '$i
	fi

	echo ''
done

exit 0;