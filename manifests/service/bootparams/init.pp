# pulsar::service::bootparams
#
# Turn off bootparams if not required
# Required for jumopstart servers
#.

# Requires fact: pulsar_systemservices

class pulsar::service::bootparams::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::bootparams": }
    }
  }
}

class pulsar::service::bootparams::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          $service_name = "svc:/network/rpc/bootparams:default"
        }
        else {
          $service_name = "boot.server"
        }
        disable_service { $service_name: }
      }
      if $kernel == "Linux" {
        disable_service { "bootparamd": }
      }
    }
  }
}
