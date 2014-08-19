# pulsar::login::serial
#
# The pmadm command provides service administration for the lower level of the
# Service Access Facility hierarchy and can be used to disable the ability to
# login on a particular port.
# By disabling the login: prompt on the system serial devices, unauthorized
# users are limited in their ability to gain access by attaching modems,
# terminals, and other remote access devices to these ports. Note that this
# action may safely be performed even if console access to the system is
# provided via the serial ports, because the login: prompt on the console
# device is provided through a different mechanism.
#
# Refer to Section(s) 3.1 Page(s) 9 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.12.1 Page(s) 206-7 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 6.1 Page(s) 46-7 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 6.2 Page(s) 87-8 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_inittabservices
# Requires fact: pulsar_serialservices

class pulsar::login::serial::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel =~ /SunOS|Linux|AIX/ {
      init_message { "pulsar::login::serial": }
    }
  }
}

class pulsar::login::serial::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel =~ /SunOS|Linux|AIX/ {
      disable_serial_console { "pulsar::login::serial": }
    }
  }
}
