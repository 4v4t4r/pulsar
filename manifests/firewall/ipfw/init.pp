# pulsar::filter::ipfw
#
# Loading the firewall module will offer a default to deny policy.
# All Internet connections will be blocked regardless of where the connection
# originates. The next item will discuss configuring a default policy.
#
# FreeBSD includes an open for:
#
# - a completely open configuration;
# - a client which will attempt to protect this machine;
# - a simple which will attempt to protect the network;
# - a closed which will close off all connections other than those to the
#   loopback interface.
#
# Either selection will load the respected policy from the rc.firewall file
# and load it into the kernel module.
# There is an opportunity to load a customized firewall script, see the rc.conf
# file for more information on that option and corresponding firewall options.
#
# Refer to Section 1.3 Page(s) 3-4 CIS FreeBSD Benchmark v1.0.5
#.

# Requires fact: pulsar_rc
# Requires fact: pulsar_systemservices

class pulsar::filter::ipfw::init {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel == "FreeBSD" {
      init_message { "pulsar::filter::ipfw": }
    }
  }
}

class pulsar::filter::ipfw::main {
  if $pulsar_modules =~ /firewall|full/ {
    if $kernel == "FreeBSD" {
      enable_service { "ipfw": }
      add_line_to_file { "firewall_enable = YES": path => "rc" }
      add_line_to_file { "firewall_type = client": path => "rc" }
    }
  }
}
