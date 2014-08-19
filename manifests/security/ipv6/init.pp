# pulsar::security::ipv6
#
# Although IPv6 has many advantages over IPv4, few organizations have
# implemented IPv6.
# If IPv6 is not to be used, it is recommended that the driver not be installed.
# While use of IPv6 is not a security issue, it will cause operational slowness
# as packets are tried via IPv6, when there are no recipients. In addition,
# disabling unneeded functionality reduces the potential attack surface.
#
# AIX
#
# authoconf6 is used to automatically configure IPv6 interfaces at boot time.
# Running this service may allow other hosts on the same physical subnet to
# connect via IPv6, even when the network does not support it.
# You must disable this unless you utilize IPv6 on the server.
#
# Refer to Section(s) 1.3.11,22-3 Page(s) 47,60-2 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 4.4.2 Page(s) 94 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 4.4.2 Page(s) 85-6 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 7.3.3 Page(s) 76 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_modprobe
# Requires fact: pulsar_network

# Need to add Solaris

class pulsar::security::ipv6::init {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /Linux|AIX/ {
      init_message { "pulsar::security::ipv6": }
    }
  }
}

class pulsar::security::ipv6::main {
  if $pulsar_modules =~ /security|full/ {
    if $kernel =~ /Linux|AIX/ {
      if $kernel == "AIX" {
        $service_list = [ 'autoconf6', 'ndpd-host', 'ndpd-router' ]
        disable_rctcp { $service_list: }
      }
      if $kernel == "Linux" {
        add_line_to_file { "NETWORKING_IPV6=no": path => "network" }
        add_line_to_file { "IPV6INIT=no": path => "network" }
      }
    }
  }
}

