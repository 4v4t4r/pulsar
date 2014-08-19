# pulsar::service::uucp
#
# Turn off uucp
#.

# Requires fact: pulsar_systemservices

class pulsar::service::uucp::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::uucp": }
    }
  }
}

class pulsar::service::uucp::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      disable_service { "uucp": }
    }
  }
}
