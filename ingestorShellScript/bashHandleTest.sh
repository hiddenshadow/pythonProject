#!/usr/bin/env bash

# https://stackoverflow.com/questions/3463106/how-to-keep-a-mysql-connection-open-in-bash

DB_HOST='localhost'
DB_PORT=3306
DB_USER='root'
DB_PASSWORD='Bima1'
DB_DATABASE='allocator'

STATS_QRY=' SELECT (SELECT COUNT(*) FROM allocator.bima_user) AS user, (SELECT COUNT(*) FROM allocator.bima_user_role_permission) AS user_role, (SELECT COUNT(*) FROM allocator.bima_customer) AS customer, (SELECT COUNT(*) FROM allocator.customer_meta_data) AS customer_meta;'


############### BASIC MYSQL SESSION IMPLEMENTATION FOR BASH (by Norman Geist 2015) #############
# requires coproc, stdbuf, mysql
#args: handle query
function mysql_check {
  local handle
  handle=(${1//_/ })
  #has right structure && is still running && we opened it?
  if [[ ${#handle[*]} == 3 ]] && ps -p ${handle[2]} 2>> /dev/null >> /dev/null && { echo "" >&${handle[1]}; } 2> /dev/null; then
    return 0
  fi
  return 1
}

# open mysql connection
#args: -u user [-H host] [-p passwd] -d db
#returns $HANDLE
function mysql_connect {
 	user=$1; pass=$2; host=$3; port=$4 db=$5;

  local argv argc user pass host db HANDLEID i
  #prepare args
  argv=($*)
  argc=${#argv[*]}

  # #get options
  # user=""
  # pass=""
  # host="localhost"
  # db=""
  # for ((i=0; $i < $argc; i++))
  # do
  #   if [[ ${argv[$i]} == "-h" ]]; then
  #     echo "Usage: -u user [-H host] [-p passwd] -d db"
  #     return 0
  #   elif [[ ${argv[$i]} == "-u" ]]; then
  #     i=$[$i+1]
  #     if [[ ${#argv[$i]} -gt 0 ]]; then
  #   user=${argv[$i]}
  #     else
  #   echo "ERROR: -u expects argument!"
  #   return 1
  #     fi
  #   elif [[ ${argv[$i]} == "-p" ]]; then
  #     i=$[$i+1]
  #     if [[ ${#argv[$i]} -gt 0 ]]; then
  #   pass="-p"${argv[$i]}
  #     else
  #   echo "ERROR: -p expects argument!"
  #   return 1
  #     fi
  #   elif [[ ${argv[$i]} == "-H" ]]; then
  #     i=$[$i+1]
  #     if [[ ${#argv[$i]} -gt 0 ]]; then
  #   host=${argv[$i]}
  #     else
  #   echo "ERROR: -H expects argument!"
  #   return 1
  #     fi
  #   elif [[ ${argv[$i]} == "-d" ]]; then
  #     i=$[$i+1]
  #     if [[ ${#argv[$i]} -gt 0 ]]; then
  #   db=${argv[$i]}
  #     else
  #   echo "ERROR: -d expects argument!"
  #   return 1
  #     fi
  #   fi
  # done
  # 
  # if [[ ${#user} -lt 1 || ${#db} -lt 1 ]]; then
  #   echo "ERROR: Options -u user and -d db are required!"
  #   return 1;
  # fi

  #init connection and channels
  #we do it in XML cause otherwise we can't detect the end of data and so would need a read timeout O_o
  HANDLEID="MYSQL$RANDOM"
  eval "coproc $HANDLEID { stdbuf -oL mysql -u $user -p$pass -h $host -p $port -D $db --force --unbuffered --xml -vvv 2>&1; }" 2> /dev/null
  HANDLE=$(eval 'echo ${'${HANDLEID}'[0]}_${'${HANDLEID}'[1]}_${'${HANDLEID}'_PID}')
  if mysql_check $HANDLE; then
    export HANDLE
    echo 'Got handle.'
    return 0
  else
    echo "ERROR: Connection failed to $user@$host->DB:$db!"
    return 1
  fi
}

#args: handle query
#return: $DATA[0] = affected rows/number of sets; 
#        $DATA[1] = key=>values pairs following
#        $DATA[2]key; DATA[3]=val ...
function mysql_query {
  local handle query affected line results_open row_open cols key val 
  if ! mysql_check $1; then
    echo "ERROR: Connection not open!"
    return 1
  fi
  echo "Connection open."
  handle=(${1//_/ })

  #delimit query; otherwise we block forever/timeout
  query=$2
  if [[ ! "$query" =~ \;\$ ]]; then
    query="$query;"
  fi
  #send query
  echo "$query" >&${handle[1]}

  #get output
  DATA=();
  DATA[0]=0
  DATA[1]=0
  results_open=0
  row_open=0
  cols=0
  while read -t $MYSQL_READ_TIMEOUT -ru ${handle[0]} line
  do 
    #WAS ERROR?
    if [[ "$line" == *"ERROR"* ]]; then
      echo "$line"
      return 1
    #WAS INSERT/UPDATE?
    elif [[ "$line" == *"Query OK"* ]]; then
      affected=$([[ "$line" =~ Query\ OK\,\ ([0-9]+)\ rows?\ affected ]] && echo ${BASH_REMATCH[1]})
      DATA[0]=$affected
      export DATA
      return 0
    fi

    #BEGIN OF RESULTS
    if [[ $line =~ \<resultset ]]; then
      results_open=1
    fi

    #RESULTS
    if [[ $results_open == 1 ]]; then
      if [[ $line =~ \<row ]]; then
    row_open=1
    cols=0
      elif [[ $line =~ \<field && $row_open == 1 ]]; then
    key=$([[ "$line" =~ name\=\"([^\"]+)\" ]] && echo ${BASH_REMATCH[1]})
    val=$([[ "$line" =~ \>(.*)\<\/ ]] && echo ${BASH_REMATCH[1]} || echo "NULL")
    DATA[${#DATA[*]}]=$key
    DATA[${#DATA[*]}]=$val
    cols=$[$cols+1]
      elif [[ $line =~ \<\/row ]]; then
    row_open=0
    DATA[0]=$[${DATA[0]}+1]
    DATA[1]=$cols
      fi
    fi

    #END OF RESULTS
    if [[ $line =~ \<\/resultset ]]; then
      export DATA
      return 0
    fi
  done
  #we can only get here
  #if read times out O_o
  echo "$FUNCNAME: Read timed out!"
  return 1
}

#args: handle
function mysql_close {
  local handle
  if ! mysql_check $1; then
    echo "ERROR: Connection not open!"
    return 1
  fi
  handle=(${1//_/ })
  echo "exit;" >&${handle[1]}

  if ! mysql_check $1; then
    return 0
  else
    echo "ERROR: Couldn't close connection!"
    return 1
  fi
}
############### END BASIC MYSQL SESSION IMPLEMENTATION FOR BASH ################################

# Example usage
#define timeout for read command, in case of server error etc.
export MYSQL_READ_TIMEOUT=10

# Connect to db and get $HANDLE
mysql_connect $DB_USER $DB_PASSWORD $DB_HOST $DB_PORT $DB_DATABASE

echo ${HANDLE[0]}
echo ${HANDLE[1]}
echo ${HANDLE[2]}

# #query db and get $DATA
# mysql_query $HANDLE "SELECT dt_whatever from tbl_lol WHERE dt_rofl=10"

mysql_query $HANDLE $STATS_QRY
echo $DATA


# #close connection
# mysql_close $HANDLE