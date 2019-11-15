#!/usr/bin/env sh

#ARGS
#PSQL_HOST
#PSQL_PORT
#PSQL_ROOT_USERNAME
#PSQL_ROOT_PASSWORD
#PSQL_USERNAME
#PSQL_PASSWORD
#PSQL_DATABASE

if [ -z $PSQL_HOST ]
then
	echo "environment valiable PSQL_HOST must be set"
	exit 1
fi

if [ -z $PSQL_ROOT_PASSWORD ]
then
	echo "environment valiable PSQL_ROOT_PASSWORD must be set"
	exit 1
fi

if [ -z $PSQL_USERNAME ]
then
	echo "environment valiable PSQL_USERNAME must be set"
	exit 1
fi

if [ -z $PSQL_PASSWORD ]
then
	echo "environment valiable PSQL_PASSWORD must be set"
	exit 1
fi

if [ -z $PSQL_DATABASE ]
then
	echo "environment valiable PSQL_DATABASE must be set"
	exit 1
fi
#set root passowrd for authorize
export PGPASSWORD=$PSQL_ROOT_PASSWORD

echo "CREATE DATABASE $PSQL_DATABASE;"
createdb -h"$PSQL_HOST" -p"$PSQL_PORT" -U"$PSQL_ROOT_USERNAME"  $PSQL_DATABASE
echo "CREATE USER $PSQL_USERNAME"
psql -h"$PSQL_HOST" -p"$PSQL_PORT" -U"$PSQL_ROOT_USERNAME" -c "CREATE USER \"$PSQL_USERNAME\" WITH ENCRYPTED PASSWORD '$PSQL_PASSWORD';"
echo "GRANT ALL PRIVILEGES ON DATABASE $PSQL_DATABASE TO $PSQL_USERNAME"
psql -h"$PSQL_HOST" -p"$PSQL_PORT" -U"$PSQL_ROOT_USERNAME" -c "GRANT ALL PRIVILEGES ON DATABASE \"$PSQL_DATABASE\" TO \"$PSQL_USERNAME\";"


SQL_FILES=`find . -type f -name '*.sql'`

if [ ! -z "$SQL_FILES" ]
then
# set user password for authorize
export PGPASSWORD=$PSQL_PASSWORD
	for i in $SQL_FILES
	do
		echo $i
		psql -h"$PSQL_HOST" -p"$PSQL_PORT" -U"$PSQL_USERNAME" $PSQL_DATABASE < $i
	done
else
	echo "No sql file to undump"
fi