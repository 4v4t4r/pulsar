# pulsar::service::vnetd
#
# VNET Daemon
#
# Turn off vnetd
#.

# Requires fact: pulsar_systemservices

class pulsar::service::vnetd::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::vnetd": }
    }
  }
}

class pulsar::service::vnetd::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        disable_service { "svc:/network/vnetd/tcp:default": }
      }
    }
  }
}
