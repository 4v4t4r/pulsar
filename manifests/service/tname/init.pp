# pulsar::service::tname
#
# Turn off tname
#.

# Requires fact: pulsar_systemservices

class pulsar::service::tname::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /5.10|5.11/ {
        init_message { "pulsar::service::tname": }
      }
    }
  }
}

class pulsar::service::tname::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /5.10|5.11/ {
        disable_service { "svc:/network/tname:default": }
      }
    }
  }
}
