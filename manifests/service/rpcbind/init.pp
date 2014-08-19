# pulsar::service::rpcbind
#
# The rpcbind utility is a server that converts RPC program numbers into
# universal addresses. It must be running on the host to be able to make
# RPC calls on a server on that machine.
# When an RPC service is started, it tells rpcbind the address at which it is
# listening, and the RPC program numbers it is prepared to serve. When a client
# wishes to make an RPC call to a given program number, it first contacts
# rpcbind on the server machine to determine the address where RPC requests
# should be sent.
# The rpcbind utility should be started before any other RPC service. Normally,
# standard RPC servers are started by port monitors, so rpcbind must be started
# before port monitors are invoked.
# Check that rpc bind has tcp wrappers enabled in case it's turned on.
#
# Refer to Section(s) 2.2.14 Page(s) 34-5 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_svcprop_svc_network_rpc_bind_prop_config_enable_tcpwrappers

class pulsar::service::rpcbind::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        init_message { "pulsar::service::rpcbind": }
      }
    }
  }
}

class pulsar::service::rpcbind::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease =~ /10|11/ {
        if $kernelrelease == "5.10" {
          check_svccfg { "pulsar::service::rpcbind":
            service => "svc:/network/rpc/bind",
            prop    => "config/enable_tcpwrappers",
            value   => "true",
          }
        }
        if $kernelrelease == "5.11" {
          disable_service { "svc:/network/rpc/bind": }
        }
        disable_service { $service_name: }
      }
    }
  }
}
