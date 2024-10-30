#!/bin/bash
MODULE=$1
cat <<EOF
#!/bin/bash
set +e

selinuxvariant=targeted
if /usr/sbin/semodule -s \$selinuxvariant -l >/dev/null; then
  # Unload policy
  /usr/sbin/semodule -s \$selinuxvariant -r $MODULE
fi
EOF
