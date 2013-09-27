#!/bin/bash

/bin/rpm -q ctags > /dev/null

if [ $? == 0 ]; then
    if [ -d /usr/share/selinux/devel ]; then
        ctags -e --langdef=te --langmap=te:..te.if.spt \
            --regex-te='/^type[ \t]+(\w+)(,|;)/\1/t,type/' \
            --regex-te='/^typealias[ \t]+\w+[ \t+]+alias[ \t]+(\w+);/\1/t,type/' \
            --regex-te='/^attribute[ \t]+(\w+);/\1/a,attribute/' \
            --regex-te='/^[ \t]*define\(`(\w+)/\1/d,define/' \
            --regex-te='/^[ \t]*interface\(`(\w+)/\1/i,interface/' \
            --regex-te='/^[ \t]*bool[ \t]+(\w+)/\1/b,bool/' /usr/share/selinux/devel/include/*/*.if /usr/share/selinux/devel/include/support/*.spt *.te
    else
        echo "You need to install selinux-policy-devel package"
        exit 1
    fi
else
    echo "You need to install ctags package"
    exit 1
fi
