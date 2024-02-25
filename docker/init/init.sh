#!/bin/bash

source ./../../.env

echo "init database start"
mysql -u root $DB_NAME -p <  ./query/init/make_tbl.sql
mysql -u root $DB_NAME -p <  ./query/init/pre_insert_datum.sql

for ((i=1; i<=10; i++)); do
    mysql -u root $DB_NAME -p <  ./query/init/insert_datum.sql
done

mysql -u root $DB_NAME -p <  ./query/init/after_insert_datum.sql

echo "init database DONE!"