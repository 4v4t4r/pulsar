# pulsar::service::rarp
#
# rarp: Turn off rarp if not in use
# rarp is required for jumpstart servers
#.

# Requires fact: pulsar_systemservices

class pulsar::service::rarp::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::rarp": }
    }
  }
}

class pulsar::service::rarp::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "SunOS" {
        disable_service { 'svc:/network/rarp:default': }
      }
      if $kernel == "Linux" {
        disable_service { 'rarpd': }
      }
    }
  }
}
