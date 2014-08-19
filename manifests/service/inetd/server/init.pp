# pulsar::service::inetd::server
#
# If the actions in this section result in disabling all inetd-based services,
# then there is no point in running inetd at boot time.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::inetd::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::inetd::server": }
    }
  }
}

class pulsar::service::inetd::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease =~ /10|11/ {
        disable_service { 'svc:/network/inetd:default': }
      }
    }
  }
}
