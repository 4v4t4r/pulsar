# pulsar::service::console
#
# The consadm command can be used to select or display alternate console devices.
# Since the system console has special properties to handle emergency situations,
# it is important to ensure that the console is in a physically secure location
# and that unauthorized consoles have not been defined. The "consadm -p" command
# displays any alternate consoles that have been defined as auxiliary across
# reboots. If no remote consoles have been defined, there will be no output from
# this command.
#
# On Linux remove tty[0-9]* from /etc/securetty if run in lockdown mode
#
# Refer to Section(s) 9.1 Page(s) 72 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.1 Page(s) 116 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_consoleservices

class pulsar::service::console::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::console": }
    }
  }
}

class pulsar::service::console::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      handle_console_services { "pulsar::service::console": }
    }
  }
}
