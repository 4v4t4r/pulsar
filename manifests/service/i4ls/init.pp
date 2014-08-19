# pulsar::service::i4ls
#
# The recommendation is to disable the i4ls license manager.
# This is typically used for C and Cobol license management.
#
# Refer to Section(s) 2.12.2 Page(s) 207 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_systemservices

# Needs to be fixed

class pulsar::service::i4ls::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "AIX" {
      init_message { "pulsar::service::i4ls": }
    }
  }
}

class pulsar::service::i4ls::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "AIX" {
      disable_inittab { "i4ls": }
    }
  }
}
