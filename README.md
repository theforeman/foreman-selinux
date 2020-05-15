Foreman SELinux poclicy
=======================

SELinux policies for Foreman and subcomponents

Compiling
---------

To locally compile the policy do something like:

    PCY=foreman
    sed -i s/@@VERSION@@/99.9/ $PCY.te
    make -f /usr/share/selinux/devel/Makefile load DISTRO=rhel7 NAME=$PCY

Make sure you provide the correct distribution. Possible values are:

* fedoraN (defines m4 macro `distro_fedoraN`)
* rhelN (defines m4 macro `distro_rhelN`)

There's a target to do compile and load policy on a remote system via ssh:

    make remote-load HOST=foreman.example.com DISTRO=rhel7 NAME=foreman

Often it is necessary to relabel relevant files and directories:

    ssh my.host.lan
    my# ./foreman-selinux-relabel

Debugging CIL
-------------

From time to time, SELinux spills out a cryptic error. To generate CLI source from te/pp file, do:

    cat foreman.pp | /usr/libexec/selinux/hll/pp > /tmp/foreman.cil

License
-------

Copyright (c) 2013 Red Hat, Inc.

This program and entire repository is free software: you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>.

