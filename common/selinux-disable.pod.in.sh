#!/bin/bash
PROG=$1
NAME=$2
cat <<EOF
=head1 NAME

$PROG-selinux-disable - disable $NAME SELinux policy

=head1 SYNOPSIS

    $PROG-selinux-disable

=head1 DESCRIPTION

The B<$PROG-selinux-disable> program will unload and disable $NAME
SELinux module. It also removes all the relevant user defined ports.

The program is executed during the installation of the
$NAME SELinux package and it is not usually required to run
it manually.

=head1 SEE ALSO

$PROG-selinux-relabel(8), $PROG-selinux-enable(8)
EOF
