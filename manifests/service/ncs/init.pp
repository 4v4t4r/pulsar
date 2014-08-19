# pulsar::service::ncs
#
# The recommendation is to disable Network Computing System (NCS).
# It provide tools for designing, implementing, and supporting applications
# requiring distributed data and distributed computing.
#
# Refer to Section(s) 2.12.3 Page(s) 208 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_inittabservices

# Needs to be fixed

class pulsar::service::ncs::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "AIX" {
      init_message { "pulsar::service::ncs": }
    }
  }
}

class pulsar::service::ncs::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "AIX" {
      disable_inittab { "ncs": }
    }
  }
}
