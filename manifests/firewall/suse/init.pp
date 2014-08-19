# pulsar::firewall::suse
#
# SuSEfirewall2 is a script that generates IPtables rules from configuration
# stored in the /etc/sysconfig/SuSEfirewall2 file. IPtables is an application
# that allows a system administrator to configure the IPv4 tables, chains and
# rules provided by the Linux kernel firewall.
# IPtables provides extra protection for the Linux system by limiting
# communications in and out of the box to specific IPv4 addresses and ports.
# SuSEfirewall2 is the default interface for SuSE systems and provides
# configuration through YaST in addition to standard configuration files.
# Note: SuSEFirewall2 has limited support for ipv6, if ipv6 is in use in your
# environment consider configuring IPtables and IP6tables directly.
#
# Refer to Section(s) 7.7 Page(s) 83-4 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::firewall::suse::init {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /SuSE/ {
        init_message { "pulsar::firewall::suse": }
      }
    }
  }
}

class pulsar::firewall::suse::main {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /SuSE/ {
        $service_list = [ 'SuSEfirewall2_init', 'SuSEfirewall2_setup' ]
        enable_service { $service_list: }
      }
    }
  }
}
