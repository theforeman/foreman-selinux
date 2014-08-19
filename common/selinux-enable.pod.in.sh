#!/bin/bash
PROG=$1
NAME=$2
cat <<EOF
=head1 NAME

$PROG-selinux-enable - enable $NAME SELinux policy

=head1 SYNOPSIS

    $PROG-selinux-enable

=head1 DESCRIPTION

The B<$PROG-selinux-enable> program will load $NAME
SELinux module. It defines some SELinux booleans which are required
for operation.

The program is executed during the installation of the
$NAME SELinux package and it is not usually required to run
it manually.

=head1 SEE ALSO

$PROG-selinux-relabel(8), $PROG-selinux-disable(8)
EOF
