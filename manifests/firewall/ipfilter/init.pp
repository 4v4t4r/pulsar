# pulsar::firewall::ipfilter
#
# Turn off IP filter

# Requires fact: pulsar_systemservices

class pulsar::firewall::ipfilter::init {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::firewall::ipfilter": }
    }
  }
}

class pulsar::firewall::ipfilter::main {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        $filter_services = [ 'svc:/network/ipfilter:default', 'svc:/network/pfil:default' ]
        disable_service { $filter_services: }
      }
    }
  }
}
