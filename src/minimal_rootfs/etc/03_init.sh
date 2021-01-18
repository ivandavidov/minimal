#!/bin/sh

# System initialization sequence:
#
# /init
#  |
#  +--(1) /etc/01_prepare.sh
#  |
#  +--(2) /etc/02_overlay.sh
#          |
#          +-- /etc/03_init.sh (this file)
#               |
#               +-- /sbin/init
#                    |
#                    +--(1) /etc/04_bootscript.sh
#                    |       |
#                    |       +-- /etc/autorun/* (all scripts)
#                    |
#                    +--(2) /bin/sh (Alt + F1, main console)
#                    |
#                    +--(2) /bin/sh (Alt + F2)
#                    |
#                    +--(2) /bin/sh (Alt + F3)
#                    |
#                    +--(2) /bin/sh (Alt + F4)

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

# Print first message on screen.
cat /etc/msg/03_init_01.txt

# Wait 5 second or until any ~keyboard key is pressed.
read -t 5 -n1 -s key

if [ "$key" = "" ] ; then
  # Use default initialization logic based on configuration in '/etc/inittab'.
  echo -e "Executing \\e[32m/sbin/init\\e[0m as PID 1."
  exec /sbin/init
else
  # Print second message on screen.
  cat /etc/msg/03_init_02.txt

  if [ "$PID1_SHELL" = "true" ] ; then
    # PID1_SHELL flag is set which means we have controlling terminal.
    unset PID1_SHELL
    exec sh
  else
    # Interactive shell with controlling tty as PID 1.
    exec setsid cttyhack sh
  fi
fi

echo "(/etc/03_init.sh) - there is a serious bug."

# Wait until any key has been pressed.
read -n1 -s

