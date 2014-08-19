# pulsar::firewall::ipsec
#
# Turn off IPSEC
#.

# Requires fact: pulsar_systemservices

# Needs fixing

class pulsar::firewall::ipsec::init {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::firewall::ipsec": }
    }
  }
}

class pulsar::firewall::ipsec::main {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        $ipsec_services = [
          'svc:/network/ipsec/manual-key:default',
          'svc:/network/ipsec/ike:default',
          'svc:/network/ipsec/ipsecalgs:default',
          'svc:/network/ipsec/policy:default'
        ]
        disable_service { $ipsec_services: }
      }
    }
  }
}
