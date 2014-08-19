# pulsar::service::keyserv::server
#
# The keyserv process is only required for sites that are using
# Oracle's Secure RPC mechanism. The most common uses for Secure RPC on
# Solaris machines are NIS+ and "secure NFS", which uses the Secure RPC
# mechanism to provide higher levels of security than the standard NFS
# protocols. Do not confuse "secure NFS" with sites that use Kerberos
# authentication as a mechanism for providing higher levels of NFS security.
# "Kerberized" NFS does not require the keyserv process to be running.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::keyserv::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::keyserv::server": }
    }
  }
}

class pulsar::service::keyserv::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease =~ /10|11/ {
        disable_service { 'svc:/network/rpc/keyserv': }
      }
    }
  }
}
