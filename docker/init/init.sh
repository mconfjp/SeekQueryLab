#!/bin/bash

# queryディレクトリ内のSQLファイルへの絶対パスを指定
# QUERY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/query"
QUERY_DIR="$(cd $(dirname $0); pwd)/query"

# SQLファイルを実行
mysql -u $MYSQL_USER $MYSQL_DATABASE -p$MYSQL_PASSWORD < $QUERY_DIR/make_tbl.sql
mysql -u $MYSQL_USER $MYSQL_DATABASE -p$MYSQL_PASSWORD < $QUERY_DIR/pre_insert_datum.sql
for ((i=1; i<=10; i++)); do
    mysql -u $MYSQL_USER  $MYSQL_DATABASE -p$MYSQL_PASSWORD < $QUERY_DIR/insert_datum.sql
done
mysql -u $MYSQL_USER  $MYSQL_DATABASE -p$MYSQL_PASSWORD < $QUERY_DIR/after_insert_datum.sql
