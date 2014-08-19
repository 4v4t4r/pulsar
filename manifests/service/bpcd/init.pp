# pulsar::service::bpcd
#
# BPC
#
# Turn off bpcd
#.

# Requires fact: pulsar_systemservices

class pulsar::service::bpcd::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        init_message { "pulsar::service::bpcd": }
      }
    }
  }
}

class pulsar::service::bpcd::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        disable_service { "svc:/network/bpcd/tcp:default": }
      }
    }
  }
}
