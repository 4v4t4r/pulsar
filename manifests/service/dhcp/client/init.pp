# pulsar::service::dhcp::client
#
# The dhcpcd daemon is the DHCP client that receives address and configuration
# information from the DHCP server. This must be disabled if DHCP is not used
# to serve IP address to the local system.
#
# Refer to Section(s) 1.3.8 Page(s) 43-4 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_rctcpservices

class pulsar::service::dhcp::client::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "AIX" {
      init_message { "pulsar::service::dhcp::client": }
    }
  }
}


class pulsar::service::dhcp::client::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "AIX" {
      disable_service { 'dhcpcd': }
    }
  }
}
