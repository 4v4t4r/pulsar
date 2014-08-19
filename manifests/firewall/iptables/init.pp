# pulsar::firewall::iptables
#
# Turn on iptables
#
# IPtables is an application that allows a system administrator to configure
# the IPv4 tables, chains and rules provided by the Linux kernel firewall.
# IPtables provides extra protection for the Linux system by limiting
# communications in and out of the box to specific IPv4 addresses and ports.
#
# Refer to Section(s) 5.7-8 Page(s) 114-8 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 4.7-8 Page(s) 101-3 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 4.7-8 Page(s) 92-3 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

# Requires fact: pulsar_systemservices

# Needs to be fixed

class pulsar::firewall::iptables::init {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::firewall::iptables": }
    }
  }
}

class pulsar::firewall::iptables::main {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel == "Linux" {
      $iptables_services = [ "iptables", "ip6tables" ]
      enable_service { $iptables_services: }
    }
  }
}
