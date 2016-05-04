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
#                    |       +-- udhcpc
#                    |           |
#                    |           +-- /etc/05_rc.udhcp
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

# Print message on screen.
cat << CEOF

  Press empty key (ESC, TAB, SPACE, ENTER) or wait 5 seconds to continue with
  the system initialization process. Press any other key for PID 1 rescue shell
  outside of the initramfs area.

CEOF

# Wait 5 second or until any keybord key is pressed.
read -t 5 -n1 -s key

if [ "$key" = "" ] ; then
  # Use default initialization logic based on configuration in '/etc/inittab'.
  echo "Executing /sbin/init as PID 1."
  exec /sbin/init
else
  # Print message on screen.
  cat << CEOF
  This is PID 1 rescue shell outside of the initramfs area. Execute the
  following in order to continue with the system initialization:

  exec /sbin/init

CEOF

  if [ "$PID1_SHELL" = "true" ] ; then
    # PID1_SHELL flag is set which means we have controlling terminal.
    exec sh
  else
    # Interactive shell with controlling tty as PID 1.
    exec setsid cttyhack sh
  fi
fi

echo "(/etc/03_init.sh) - there is a serious bug..."

# Wait until any key has been pressed.
read -n1 -s

