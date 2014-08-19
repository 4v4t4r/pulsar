# pulsar::service::apocd
#
# Turn off apocd
#.

# Requires fact: pulsar_systemservices

class pulsar::service::apocd::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::apocd": }
    }
  }
}

class pulsar::service::apocd::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        disable_service { "svc:/network/apocd/udp:default": }
      }
    }
  }
}
