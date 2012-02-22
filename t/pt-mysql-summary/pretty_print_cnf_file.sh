#!/bin/bash

TESTS=2
TMPDIR=$TEST_TMPDIR

cat <<EOF > $TMPDIR/expected

[mysqld]
datadir                             = /mnt/data/mysql
socket                              = /mnt/data/mysql/mysql.sock
old_passwords                       = 1
ssl-key                             = /opt/mysql.pdns/.cert/server-key.pem
ssl-cert                            = /opt/mysql.pdns/.cert/server-cert.pem
ssl-ca                              = /opt/mysql.pdns/.cert/ca-cert.pem
innodb_buffer_pool_size             = 16M
innodb_flush_method                 = O_DIRECT
innodb_log_file_size                = 64M
innodb_log_buffer_size              = 1M
innodb_flush_log_at_trx_commit      = 2
innodb_file_per_table               = 1
ssl                                 = 1
server-id                           = 1
log-bin                             = sl1-bin

[mysql.server]
user                                = mysql
basedir                             = /mnt/data

[mysqld_safe]
log-error                           = /var/log/mysqld.log
pid-file                            = /var/run/mysqld/mysqld.pid

[mysql]

[xtrabackup]
target-dir                          = /data/backup
EOF

pretty_print_cnf_file samples/my.cnf-001.txt > $TMPDIR/got
no_diff $TMPDIR/got $TMPDIR/expected


# TODO BUG NUMBER#
cp samples/my.cnf-001.txt $TMPDIR/test_pretty_print_cnf_file
echo "some_var_yadda=0" >> $TMPDIR/test_pretty_print_cnf_file
echo "some_var_yadda                      = 0" >> $TMPDIR/expected

pretty_print_cnf_file $TMPDIR/test_pretty_print_cnf_file > $TMPDIR/got
no_diff $TMPDIR/got $TMPDIR/expected
