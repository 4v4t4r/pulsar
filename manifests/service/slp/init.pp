# pulsar::service::slp
#
# Turn off slp
#.

# Requires fact: pulsar_systemservices

class pulsar::service::slp::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        init_message { "pulsar::service::slp": }
      }
    }
  }
}

class pulsar::service::slp::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        disable_service { "svc:/network/slp:default": }
      }
    }
  }
}
