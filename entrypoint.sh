#!/usr/bin/env sh

#ARGS
#PSQL_HOST
#PSQL_PORT
#PSQL_ROOT_USERNAME
#PSQL_ROOT_PASSWORD
#PSQL_ROOT_DATABASE
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
export PGHOST=$PSQL_HOST
export PGPORT=$PSQL_PORT
export PGUSER=$PSQL_ROOT_USERNAME
export PGDATABASE=$PSQL_ROOT_DATABASE

psql -c "CREATE DATABASE \"$PSQL_DATABASE\";"
psql -c "CREATE USER \"$PSQL_USERNAME\" WITH ENCRYPTED PASSWORD '$PSQL_PASSWORD';"
psql -c "GRANT ALL PRIVILEGES ON DATABASE \"$PSQL_DATABASE\" TO \"$PSQL_USERNAME\";"

#fix repmitions if database from dump
for tbl in `psql -qAt -c "select tablename from pg_tables where schemaname = 'public';" $PSQL_DATABASE`
do
	psql -c "alter table \"$tbl\" owner to $PSQL_USERNAME" $PSQL_DATABASE

done

for tbl in `psql -qAt -c "select sequence_name from information_schema.sequences where sequence_schema = 'public';" $PSQL_DATABASE`
do
	psql -c "alter sequence \"$tbl\" owner to $PSQL_USERNAME" $PSQL_DATABASE
done

for tbl in `psql -qAt -c "select table_name from information_schema.views where table_schema = 'public';" $PSQL_DATABASE`
do
	psql -c "alter view \"$tbl\" owner to $PSQL_USERNAME" $PSQL_DATABASE
done


SQL_FILES=`find . -type f -name '*.sql'`

if [ ! -z "$SQL_FILES" ]
then
# set user password for authorize
export PGPASSWORD=$PSQL_PASSWORD
export PGUSER=$PSQL_USERNAME
export PGDATABASE=$PSQL_DATABASE
	for i in $SQL_FILES
	do
		echo $i
		psql < $i
	done
else
	echo "No sql file to undump"
fi
