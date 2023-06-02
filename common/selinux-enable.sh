#!/bin/bash
MODULE=$1
cat <<EOF
#!/bin/bash
set +e

for selinuxvariant in targeted
do
  if /usr/sbin/semodule -s \$selinuxvariant -l >/dev/null; then
    # Remove old policy module on priority 400 if it exists
    /usr/sbin/semodule -s \$selinuxvariant -r ${MODULE}
    # Load new policy module
    /usr/sbin/semodule -X 200 -s \$selinuxvariant \
      -i /usr/share/selinux/packages/\${selinuxvariant}/${MODULE}.pp.bz2
  fi
done
EOF
