#!/bin/bash
MODULE=$1
cat <<EOF
#!/bin/bash
set +e

for selinuxvariant in targeted
do
  if /usr/sbin/semodule -s \$selinuxvariant -l >/dev/null; then
    # Load policy
    /usr/sbin/semanage module -S \$selinuxvariant \
      -a /usr/share/selinux/\${selinuxvariant}/${MODULE}.pp.bz2
  fi
done
EOF
