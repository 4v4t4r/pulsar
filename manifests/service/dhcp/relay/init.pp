# pulsar::service::dhcp::relay
#
# The dhcprd daemon is the DHCP relay deamon that forwards the DHCP and BOOTP
# packets in the network. You must disable this service if DHCP is not enabled
# in the network.
#
# Refer to Section(s) 1.3.9 Page(s) 44-5 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_rctcpservices

class pulsar::service::dhcp::relay::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "AIX" {
      init_message { "pulsar::service::dhcp::relay": }
    }
  }
}

class pulsar::service::dhcp::relay::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "AIX" {
      disable_service { 'dhcprd': }
    }
  }
}
