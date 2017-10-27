#!/bin/bash
#local root Bima1

DB_HOST='localhost'
DB_PORT=3306
DB_USER='root'
DB_PASSWORD='Bima1'
DB_DATABASE='allocator'

QUERY='select min(id),max(id)  from allocator.customer_meta_data;'

SSH_CMD='mysql -h"'$DB_HOST'" -P'$DB_PORT' -u"'$DB_USER'" -p"'$DB_PASSWORD'" -s -N -e"'$QUERY'"'

echo 'Executing query command : '$SSH_CMD;
echo ''

eval $SSH_CMD > a.out

MIN=`cat a.out | tail -1 | awk '{ print $1}'`
MAX=`cat a.out | tail -1 | awk '{ print $2}'`

echo 'MIN: '$MIN', MAX: '$MAX


COUNT=1
STR=101
END=$(($STR+$COUNT-1))


i=2
if [ $i -lt 3 ]; then
	echo 'asd'
fi


# CUR_TIME_SEC=$(date +%s)
# echo "$CUR_TIME_SEC"

# echo "$CUR_TIME_SEC"

# FIRST_NAMES=['redhat' 'debian' 'gentoo' ]
FIRST_NAMES="redhat debian gentoo"
FIRST_NAMES_LEN=${#FIRST_NAMES[@]}

echo 'FIRST_NAMES_LEN: '$FIRST_NAMES_LEN

for i in $(seq $STR $END)
do
	echo ''
	echo 'i:'$i;

	f=$(shuf -i 0-$(($FIRST_NAMES_LEN-1)) -n 1)
	echo 'f:'$f

	echo ${FIRST_NAMES[$f]}

done

# # CUR_TIME_SEC=$(date +%s)
# CUR_TIME_SEC_CMD='date +%s'
# echo $CUR_TIME_SEC_CMD

# OUT=$("($CUR_TIME_SEC_CMD)")
# echo $OUT



# define array
# name server names FQDN
# NAMESERVERS=("ns1.nixcraft.net." "ns2.nixcraft.net." "ns3.nixcraft.net.")

# tLen=${#NAMESERVERS[@]}# use for loop read all nameservers
# for (( i=0; i<${tLen}; i++ ));
# do
# echo ${NAMESERVERS[$i]}
# done



# ## declare an array variable
# declare -a arr=("element1")

# ## now loop through the above array
# for i in "${arr[@]}"
# do
#    echo "$i"
#    # or do whatever with individual element of the array
# done





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
