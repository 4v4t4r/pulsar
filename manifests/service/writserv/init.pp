# pulsar::service::writeserv
#
# The recommendation is to disable writesrv. This allows users to chat using
# the system write facility on a terminal.
#
# Refer to Section(s) 2.12.6 Page(s) 210-1 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_inittabservices

class pulsar::service::writeserv::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "AIX" {
      init_message { "pulsar::service::writeserv": }
    }
  }
}

class pulsar::service::writeserv::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "AIX" {
      disable_inittab { "writesrv": }
    }
  }
}
