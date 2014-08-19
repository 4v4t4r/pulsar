# pulsar::service::echo
#
# Turn off echo and chargen services
#.

# Requires fact: pulsar_systemservices

class pulsar::service::echo::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" and $kernelrelease =~ /10|11/ {
      init_message { "pulsar::service::echo": }
    }
  }
}

class pulsar::service::echo::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' and $kernelrelease =~ /10|11/ {
      $echo_services_list = [
        'svc:/network/echo:dgram',        'svc:/network/echo:stream',
        'svc:/network/time:dgram',        'svc:/network/talk:default',
        'svc:/network/time:stream',       'svc:/network/comsat:default',
        'svc:/network/discard:dgram',     'svc:/network/discard:stream',
        'svc:/network/chargen:dgram',     'svc:/network/chargen:stream',
        'svc:/network/rpc/spray:default', 'svc:/network/daytime:dgram',
        'svc:/network/daytime:stream',
      ]
      disable_service { $echo_services_list: }
    }
  }
}
