# pulsar::service::st
#
# A service tag enables automatic discovery of assets, including software and
# hardware. A service tag uniquely identifies each tagged asset, and allows
# information about the asset to be shared over a local network in a standard
# XML format.
# Turn off Service Tags if not being used. It can provide information that can
# be used as vector of attack.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::st::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        init_message { "pulsar::service::st": }
      }
    }
  }
}

class pulsar::service::st::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        $services_list = [
          "svc:/network/stdiscover:default",
          "svc:/network/stlisten:default",
          "svc:/application/stosreg:default",
        ]
        disable_service { $services_list: }
      }
    }
  }
}

