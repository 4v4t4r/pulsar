# pulsar::service::remote
#
# Turn off remote info services like rstat and finger
#
# Refer to Section(s) 1.3.16 Page(s) 52-3 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::remote::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::remote": }
    }
  }
}

class pulsar::service::remote::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        $info_services = [
          'svc:/network/rpc/rstat:default', 'svc:/network/nfs/rquota:default',
          'svc:/network/rpc/rusers:default', 'svc:/network/finger:default',
          'svc:/network/rpc/wall:default'
        ]
        disable_service { $info_services: }
      }
    }
  }
}
