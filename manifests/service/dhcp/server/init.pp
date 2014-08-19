# pulsar::service::dhcp::server
#
# The Dynamic Host Configuration Protocol (DHCP) is a service that allows
# machines to be dynamically assigned IP addresses.
# Unless a server is specifically set up to act as a DHCP server, it is
# recommended that this service be removed.
#
# Turn off dhcp server
#
# Refer to Section(s) 3.5 Page(s) 61-2 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.3 Page(s) 74 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.5 Page(s) 64-5 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.4 Page(s) 54-5 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.3.10 Page(s) 45-6 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_installedpackages
# Requires fact: pulsar_rctcpservices

class pulsar::service::dhcp::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::dhcp::server": }
    }
  }
}

class pulsar::service::dhcp::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "AIX" {
      disable_service { 'dhcprd': }
    }
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          disable_service { "svc:/network/dhcp-server:default": }
        }
      }
      if $kernel == "Linux" {
        if $osfamily =~ /CentOS|RedHat/ {
          uninstall_package { "dhcp": }
        }
      }
    }
  }
}
