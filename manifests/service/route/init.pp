# pulsar::service::route
#
# Turn off routing services if not required
#
# AIX:
#
# Refer to Section(s) 1.3.12-3,5 Page(s) 47-50,51-2 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_rctcpservices

class pulsar::service::route::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|AIX/ {
      init_message { "pulsar::service::route": }
    }
  }
}

class pulsar::service::route::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux|AIX/ {
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          $service_list = [
            'svc:/network/routing/zebra:quagga',
            'svc:/network/routing/ospf:quagga',
            'svc:/network/routing/rip:quagga',
            'svc:/network/routing/ripng:default',
            'svc:/network/routing/ripng:quagga',
            'svc:/network/routing/ospf6:quagga',
            'svc:/network/routing/bgp:quagga',
            'svc:/network/routing/legacy-routing:ipv4',
            'svc:/network/routing/legacy-routing:ipv6',
            'svc:/network/routing/rdisc:default',
            'svc:/network/routing/route:default',
            'svc:/network/routing/ndp:default'
          ]
        }
        disable_service { $service_list: }
     }
      if $kernel == "Linux" {
        $service_list = [ 'bgpd', 'ospf6d', 'ospfd', 'ripd', 'ripngd' ]
        disable_service { $service_list: }
      }
      if $kernel == "AIX" {
        $service_list = [ 'gated', 'mrouted', 'routed' ]
        disable_aix_rctcp { $service_list: }
      }
    }
  }
}
