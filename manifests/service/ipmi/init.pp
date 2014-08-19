# pulsar::service::ipmi
#
# Turn off ipmi environment daemon
#.

# Requires fact: pulsar_systemservices

class pulsar::service::ipmi::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::ipmi": }
    }
  }
}

class pulsar::service::ipmi::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease =~ /10|11/ {
        disable_service { 'svc:/network/ipmievd:default': }
      }
    }
  }
}
