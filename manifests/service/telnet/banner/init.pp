# pulsar::service::telnet::banner
#
# The BANNER variable in the file /etc/default/telnetd can be used to display
# text before the telnet login prompt. Traditionally, it has been used to
# display the OS level of the target system.
# The warning banner provides information that can be used in reconnaissance
# for an attack. By default, Oracle distributes this file with the BANNER
# variable set to null. It is not necessary to create a separate warning banner
# for telnet if a warning is set in the /etc/issue file.
#
# Refer to Section(s) 8.5 Page(s) 71 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 8.5 Page(s) 114-5 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_telnetd

class pulsar::service::telnet::banner::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::telnet::banner": }
    }
  }
}

class pulsar::service::telnet::banner::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      add_line_to_file { "BANNER=/etc/issue": path => "telnetd" }
    }
  }
}
