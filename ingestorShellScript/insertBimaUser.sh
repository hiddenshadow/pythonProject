#!/bin/bash

# As there is only single insert query to db, max count is 750, limited by lenght of the argument passed to nohup.
# COUNT=750
COUNT=1

STR=1
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


declare -a FIRST_NAMES=("Rahul" "Suresh" "Mahendra" "Murali" "Ashwin" "Virat" "Sourav" "Venkat")
FIRST_NAMES_LEN=${#FIRST_NAMES[@]}

declare -a LAST_NAMES=("Dravid" "Raina" "Dhoni" "Karthik" "Ramchandra" "Kohli" "Ganguly" "Laxman")
LAST_NAMES_LEN=${#LAST_NAMES[@]}


CREATED_DATE='NOW()'
CREATED_BY=10109
# USER_PASSWORD_TOKEN_EXPIRY='now() + INTERVAL 1 DAY'
# USER_PASSWORD_TOKEN='r5SPC2M0xdboIsm8jPJANA=='
USER_PASSWORD='r5SPC2M0xdboIsm8jPJANA=='

VALUES=''

for i in $(seq $STR $END)
do
  	# echo 'i:'$i;

  	fn=$(shuf -i 0-$(($FIRST_NAMES_LEN-1)) -n 1)
  	lna=$(shuf -i 0-$(($LAST_NAMES_LEN-1)) -n 1)
  	USER_MOBILE=$(shuf -i 1230000000-1239999999 -n 1)

	CUR_TIME_SEC=$(date +%s)
	USER_NAME='un_'$CUR_TIME_SEC'_'$i
	USER_FIRST_NAME=${FIRST_NAMES[$fn]}
	USER_LAST_NAME=${LAST_NAMES[$lna]}
	
	USER_MOBILE=$USER_MOBILE
	USER_EMAIL=$USER_NAME'@junk.kom'

  	CUR_VALUE='("'$USER_NAME'","'$USER_FIRST_NAME'","'$USER_LAST_NAME'","'$USER_PASSWORD'",'$USER_MOBILE',"'$USER_EMAIL'",'$CREATED_BY','$CREATED_DATE')'
	
	VALUES=$VALUES''$CUR_VALUE

	if [ $i -lt $END ]; then
		VALUES=$VALUES','
		echo $i
	fi
done

QUERY='insert into '$DB_DATABASE'.bima_user (user_name, user_first_name, user_last_name, user_password, user_mobile, user_email, created_by, created_date) values '

QUERY=$QUERY' '$VALUES';'

SSH_CMD="mysql -h'"$DB_HOST"' -P"$DB_PORT" -u'"$DB_USER"' -p'"$DB_PASSWORD"' -e'"$QUERY"'"
# SSH_CMD=$QUERY

echo 'Executing query command : '$SSH_CMD;
# echo ''
eval nohup $SSH_CMD &> a.out


echo 'Done inserting '$COUNT' entries.'

# mysql  -h "bima-mentor.coic6imdwwxx.ap-south-1.rds.amazonaws.com" -P 6603 -u"root" -p"Hellobima" 

# mysql -h host -u root -proot -e "show databases;";


# user_name - unique - using count
# user_password - same as user_name
# user_mobile - starting with 1, append count
# user_password_token - append count
# user_password_token_expiry - set time in future ?

# id, user_name, user_first_name, user_last_name, user_password, user_mobile, user_email, user_password_token, user_password_token_expiry, user_status, is_mobile_verified, is_email_verified, user_retry_count, created_by, updated_by, created_date, updated_date, user_availability

# DB_HOST='bima-mentor.coic6imdwwxx.ap-south-1.rds.amazonaws.com'
# DB_PORT=6603
# DB_USER='root'
# DB_PASSWORD='Hellobima'

# mysql -h'localhost' -P3306 -u'root' -p'Bima1' -e'use allocator;insert into bima_user (user_name, user_first_name, user_last_name, user_password, user_mobile, user_email, user_password_token, user_password_token_expiry, created_by, created_date) values ("un_1507881366", "user_first_name", "user_last_name", "un_1507881366",1200068927,"un_1507881366@junk.kom", "un_1507881366_token", now() + INTERVAL 1 DAY, 10109, NOW());'

# USE_DB_QRY='use allocator;'

# CUR_TIME_SEC_CMD='date +%s'