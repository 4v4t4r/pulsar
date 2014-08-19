# pulsar::service::gss
#
# The GSS API is a security abstraction layer that is designed to make it
# easier for developers to integrate with different authentication schemes.
# It is most commonly used in applications for sites that use Kerberos for
# network authentication, though it can also allow applications to
# interoperate with other authentication schemes.
# Note: Since this service uses Oracle's standard RPC mechanism, it is
# important that the system's RPC portmapper (rpcbind) also be enabled
# when this service is turned on. This daemon will be taken offline if
# rpcbind is disabled.
#
# GSS does not expose anything external to the system as it is configured
# to use TLI (protocol = ticotsord) by default. However, unless your
# organization is using the GSS API, disable it.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::gss::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::gss": }
    }
  }
}

class pulsar::service::gss::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease =~ /10|11/ {
        disable_service { 'svc:/network/rpc/gss': }
      }
    }
  }
}
