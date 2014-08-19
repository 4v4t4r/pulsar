# pulsar::service::ticotsord
#
# Turn off ticotsord
#.

# Requires fact: pulsar_systemservices

class pulsar::service::ticotsord::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /5.10|5.11/ {
        init_message { "pulsar::service::ticotsord": }
      }
    }
  }
}

class pulsar::service::ticotsord::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /5.10|5.11/ {
        disable_service { "svc:/network/rpc-100235_1/rpc_ticotsord:default": }
      }
    }
  }
}
