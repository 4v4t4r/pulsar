# pulsar::service::kdm::config
#
# Turn off kdm config
#.

# Requires fact: pulsar_systemservices

class pulsar::service::kdm::config::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::kdm::config": }
    }
  }
}

class pulsar::service::kdm::config::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease =~ /10|11/ {
        disable_service { 'svc:/platform/i86pc/kdmconfig:default': }
      }
    }
  }
}
