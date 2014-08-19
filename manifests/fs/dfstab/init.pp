# pulsar::fs::dfstab
#
# The commands in the dfstab file are executed via the /usr/sbin/shareall
# script at boot time, as well as by administrators executing the shareall
# command during the uptime of the machine.
# It seems prudent to use the absolute pathname to the share command to
# protect against any exploits stemming from an attack on the administrator's
# PATH environment, etc. However, if an attacker is able to corrupt root's path
# to this extent, other attacks seem more likely and more damaging to the
# integrity of the system
#
# Refer to Section(s) 10.2 Page(s) 138-9 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_exports

# Needs to be fixed

class pulsar::fs::dfstab::init {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::fs::dfstab": }
    }
  }
}

class pulsar::fs::dfstab::main {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel == 'SunOS' {
      check_dfstab { "pulsar::fs::dfstab": }
    }
  }
}
