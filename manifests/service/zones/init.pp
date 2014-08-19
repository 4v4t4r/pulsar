# pulsar::service::zones
#
# Operating system-level virtualization is a server virtualization method
# where the kernel of an operating system allows for multiple isolated
# user-space instances, instead of just one. Such instances (often called
# containers, VEs, VPSs or jails) may look and feel like a real server,
# from the point of view of its owner.
#
# Turn off Zone services if zones are not being used.

# Requires fact: pulsar_systemservices

class pulsar::service::zones::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::zones": }
    }
  }
}

class pulsar::service::zones::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        if $zones < 2 {
          $services_list = [
            'svc:/system/rcap:default', 'svc:/system/pools:default',
            'svc:/system/tsol-zones:default', 'svc:/system/zones:default'
          ]
          disable_service { $services_list: }
        }
      }
    }
  }
}
