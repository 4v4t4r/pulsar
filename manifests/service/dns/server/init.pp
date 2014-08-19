# pulsar::service::dns::server
#
# The Domain Name System (DNS) is a hierarchical distributed naming system
# for computers, services, or any resource connected to the Internet or a
# private network. It associates various information with domain names
# assigned to each of the participating entities.
# In general servers will be clients of an upstream DNS server within an
# organisation so do not need to provide DNS server services themselves.
# An obvious exception to this is DNS servers themselves and servers that
# provide boot and install services such as Jumpstart or Kickstart servers.
#
# Refer to Section(s) 3.9 Page(s) 65-6 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.9 Page(s) 77-8 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.9 Page(s) 68 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.8 Page(s) 58 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 3.6 Page(s) 11 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.14 Page(s) 50-1 CIS AIX Benchmark v1.1.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_rctcpservices
# Requires fact: pulsar_rcconf

# Needs fixing

class pulsar::service::dns::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::dns::server": }
    }
  }
}

class pulsar::service::dns::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        if $kernelrelease =~ /10|11/ {
          disable_service { 'svc:/network/dns/server:default': }
        }
      }
    }
    if $kernel == 'Linux' {
      disable_service { "named": }
    }
    if $kernel == 'FreeBSD' {
      add_line_to_file { "named_enable=NO": path => "rc" }
    }
    if $kernel == 'AIX' {
      disable_service { 'named': }
    }
  }
}
