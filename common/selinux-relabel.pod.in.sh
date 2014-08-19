#!/bin/bash
PROG=$1
NAME=$2
cat <<EOF
=head1 NAME

$PROG-selinux-relabel - call restorecon on $NAME files

=head1 SYNOPSIS

    $PROG-selinux-relabel

=head1 DESCRIPTION

The B<$PROG-selinux-relabel> program will call restorecon(8) on all
$NAME files effectively restoring SELinux context.

The program is executed during the installation of the
$NAME SELinux package and it is not usually required to run
it manually.

=head1 SEE ALSO

$PROG-selinux-enable(8), restorecon(8)
EOF
