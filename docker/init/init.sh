#!/bin/bash

# queryディレクトリ内のSQLファイルへの絶対パスを指定
# QUERY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/query"
QUERY_DIR="$(cd $(dirname $0); pwd)/query"

# SQLファイルを実行

mysql -u $MYSQL_USER $MYSQL_DATABASE -p$MYSQL_PASSWORD < $QUERY_DIR/make_tbl.sql
echo "The initialization query is progressing [■□□□□□□□□□□□□]"

mysql -u $MYSQL_USER $MYSQL_DATABASE -p$MYSQL_PASSWORD < $QUERY_DIR/pre_insert_datum.sql
echo "The initialization query is progressing [■■□□□□□□□□□□□]"

for ((i=1; i<=10; i++)); do
    mysql -u $MYSQL_USER  $MYSQL_DATABASE -p$MYSQL_PASSWORD < $QUERY_DIR/insert_datum.sql
    echo -ne "\rThe initialization query is progressing "
    for ((j=1; j<=i+2; j++)); do
        echo -n "[■"
    done
    for ((k=i+3; k<=12; k++)); do
        echo -n "□"
    done
    echo -n "]"
    sleep 1 
done

mysql -u $MYSQL_USER  $MYSQL_DATABASE -p$MYSQL_PASSWORD < $QUERY_DIR/after_insert_datum.sql
echo "The initialization query is progressing [■■■■■■■■■■■■■]"

