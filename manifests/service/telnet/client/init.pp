# pulsar::service::telnet::client
#
# The telnet package contains the telnet client, which allows users to start
# connections to other systems via the telnet protocol.
#
# This module is not included by default as the telnet client is a useful
# debug tool
#
# Refer to Section(s) 2.1.2 Page(s) 49 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.2 Page(s) 56 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.2 Page(s) 51 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_installedpackages

class pulsar::service::telnet::client::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /CentOS|Red/ {
        init_message { "pulsar::service::telnet::client": }
      }
    }
  }
}

class pulsar::service::telnet::client::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /CentOS|Red/ {
        uninstall_package { "telnet": }
      }
    }
  }
}
