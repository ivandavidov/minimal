#!/bin/sh

# If you have persistent overlay support then you can edit this file and replace
# the default initialization  of the system. For example, you could use this:
#
# exec setsid cttyhach sh
#
# This gives you PID 1 shell inside the initramfs area. Since this is a PID 1
# shell, you can still invoke the original initialization logic by executing
# this command:
#
# exec /sbin/init

cat << CEOF

  Wait 5 seconds for the default system initialization process based on the
  files /sbin/init and /etc/inittab or press any key for PID 1 shell.

CEOF

read -t 5 -n1 -s key

if [ "$key" = "" ] ; then
  # Use default initialization logic based on configuration in '/etc/inittab'.
  echo "Executing /sbin/init as PID 1."
  exec /sbin/init
else

# Using no indentation for this snippet or otherwise it causes kernel panic.
cat << CEOF

  This is PID 1 shell. Execute the following in order to continue with the
  default system initialization process:

  exec /sbin/init

CEOF

  exec setsid cttyhack sh
fi

echo "(/etc/03_init.sh) - there is a serious bug..."

# Wait until any key has been pressed.
read -n1 -s

