# pulsar::service::tnd
#
# Turn off tnd
#.

# Requires fact: pulsar_systemservices

class pulsar::service::tnd::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /5.10|5.11/ {
        init_message { "pulsar::service::tnd": }
      }
    }
  }
}

class pulsar::service::tnd::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /5.10|5.11/ {
        disable_service { "svc:/network/tnd:default": }
      }
    }
  }
}
