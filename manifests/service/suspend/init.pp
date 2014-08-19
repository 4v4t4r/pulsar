# pulsar::service::suspend
#
# The /etc/default/sys-suspend settings control which users are allowed to use
# the sys-suspend command to shut down the system.
# Bear in mind that users with physical access to the system can simply remove
# power from the machine if they are truly motivated to take the system
# off-line, and granting sys-suspend access may be a more graceful way of
# allowing normal users to shut down their own machines.
#
# Refer to Section(s) 10.4 Page(s) 140 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_syssuspend

class pulsar::service::suspend::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::suspend": }
    }
  }
}

class pulsar::service::suspend::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      add_line_to_file { "PERMS=-": path => "syssuspend" }
    }
  }
}
