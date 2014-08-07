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

There's a Rake task to do this on remote system via ssh:

    rake pkg:load host=my.host.lan distro=rhel7 name=foreman

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

