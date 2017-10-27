#!/bin/bash

# For valid data max should be same as max user_id.
# As there is only single insert query to db, max count is 1000, limited by length of the argument passed to nohup.
# COUNT=1000
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

VALUES=''

CREATED_DATE='NOW()'
CREATED_BY=10109
CID_MIN=1; 
CID_MAX=5;
ROLE_ID_MIN=1;
ROLE_ID_MAX=4;
STATUS_MIN=1;
STATUS_MAX=1;


for i in $(seq $STR $END)
do
  	# echo 'i:'$i;

	USER_ID=$i
	PARTNER_COUNTRY_ID=$(shuf -i $CID_MIN-$CID_MAX -n 1)
	ROLE_ID=$(shuf -i $ROLE_ID_MIN-$ROLE_ID_MAX -n 1)
	STATUS=$(shuf -i $STATUS_MIN-$STATUS_MAX -n 1)

  	# (user_id, partner_country_id, role_id, status, created_by, created_date)
  	CUR_VALUE='('$USER_ID', '$PARTNER_COUNTRY_ID', '$ROLE_ID', '$STATUS', '$CREATED_BY','$CREATED_DATE')'

	VALUES=$VALUES''$CUR_VALUE

	if [ $i -lt $END ]; then
		VALUES=$VALUES','
		# echo $i
	fi
done

# insert into allocator.bima_user_role_permission (user_id, partner_country_id, role_id, status, created_by, created_date) value (1501, 11111, 1, 1, 10109, NOW());

QUERY='insert ignore into '$DB_DATABASE'.bima_user_role_permission (user_id, partner_country_id, role_id, status, created_by, created_date) values '

QUERY=$QUERY' '$VALUES';'

SSH_CMD="mysql -h'"$DB_HOST"' -P"$DB_PORT" -u'"$DB_USER"' -p'"$DB_PASSWORD"' -e'"$QUERY"'"
# SSH_CMD=$QUERY

# echo 'Executing query command : '$SSH_CMD;
# echo ''
eval nohup $SSH_CMD &> a.out

echo 'Done inserting '$COUNT' entries.'