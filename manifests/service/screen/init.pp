# pulsar::service::screen
#
# Disabling screen sharing mitigates the risk of remote connections being made
# without the user of the console knowing that they are sharing the computer.
#
# Refer to Section 2.4.3 Page(s) 18-19 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::screen::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::screen": }
    }
  }
}

class pulsar::service::screen::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      disable_service { "com.apple.screensharing.server": }
    }
  }
}
