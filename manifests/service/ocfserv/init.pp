# pulsar::service::ocfserv
#
# Turn off ocfserv
#.

# Requires fact: pulsar_systemservices

class pulsar::service::ocfserv::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::ocfserv": }
    }
  }
}

class pulsar::service::ocfserv::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease =~ /10|11/ {
        disable_service { 'svc:/network/rpc/ocfserv:default': }
      }
    }
  }
}
