# pulsar::service::hotplug
#
# Turn off hotplug
#.

# Requires fact: pulsar_systemservices

class pulsar::service::hotplug::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::hotplug": }
    }
  }
}

class pulsar::service::hotplug::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          disable_service { "svc:/system/hotplug:default": }
        }
      }
      if $kernel == "Linux" {
        $linux_hw_services = [ 'pcscd', 'haldaemon', 'kudzu' ]
        disable_service { $linux_hw_services: }
      }
    }
  }
}
