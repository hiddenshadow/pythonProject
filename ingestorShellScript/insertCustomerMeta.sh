#!/bin/bash

# Need to fetch start and count based on the customer ids available.
# For valid data max should be same as max user_id.
# As there is only single insert query to db, max count is 1200, limited by length of the argument passed to nohup.
# COUNT=1200
COUNT=1

STR=7373834758347593
END=$(($STR+$COUNT-1))

DB_HOST='localhost'
DB_PORT=3306
DB_USER='root'
DB_PASSWORD='Bima1'
DB_DATABASE='allocator'

DB_HOST='bima-mentor.coic6imdwwxx.ap-south-1.rds.amazonaws.com'
DB_PORT=6603
DB_USER='root'
DB_PASSWORD='Hellobima'

#############
echo 'Read values:'

QUERY='select min(id),max(id)  from allocator.customer_meta_data;'

SSH_CMD='mysql -h"'$DB_HOST'" -P'$DB_PORT' -u"'$DB_USER'" -p"'$DB_PASSWORD'" -s -N -e"'$QUERY'"'

echo 'Executing query command : '$SSH_CMD;
echo ''

eval $SSH_CMD > a.out

MIN=`cat a.out | tail -1 | awk '{ print $1}'`
MAX=`cat a.out | tail -1 | awk '{ print $2}'`

echo 'MIN: '$MIN', MAX: '$MAX

# STR=$MIN
# END=$MAX
#############

VALUES=''

CREATED_DATE='NOW()'
CREATED_BY=10109

AGE_MIN=1;
AGE_MAX=111;


declare -a GENDERS=("FEMALE" "MALE")

for i in $(seq $STR $END)
do
  	# echo 'i:'$i;

  	CUSTOMER_ID=$i
  	
  	META_KEY="GENDER"
  	META_VALUE="MALE"

	# Taking male in case i is odd.
	rem=$(( $i % 2 ))
	META_VALUE=${GENDERS[$rem]}

	# (customer_id, meta_key, meta_value, created_by, created_date)
  	CUR_VALUE='('$CUSTOMER_ID',"'$META_KEY'","'$META_VALUE'",'$CREATED_BY','$CREATED_DATE')'
	VALUES=$VALUES''$CUR_VALUE

	VALUES=$VALUES','

	META_KEY="AGE"
  	META_VALUE=$(shuf -i $AGE_MIN-$AGE_MAX -n 1)

  	CUR_VALUE='('$CUSTOMER_ID',"'$META_KEY'","'$META_VALUE'",'$CREATED_BY','$CREATED_DATE')'
	VALUES=$VALUES''$CUR_VALUE

	if [ $i -lt $END ]; then
		VALUES=$VALUES','
		# echo $i
	fi
done

# insert into allocator.customer_meta_data (customer_id, meta_key, meta_value, created_by, created_date) values ();
QUERY='insert ignore into '$DB_DATABASE'.customer_meta_data (customer_id, meta_key, meta_value, created_by, created_date) values '

QUERY=$QUERY' '$VALUES';'

SSH_CMD="mysql -h'"$DB_HOST"' -P"$DB_PORT" -u'"$DB_USER"' -p'"$DB_PASSWORD"' -e'"$QUERY"'"

# echo 'Executing query command : '$SSH_CMD;
# echo ''
eval nohup $SSH_CMD &> a.out

echo 'Done inserting Meta data for '$(($END-$STR))' Customers.'