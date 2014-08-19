# pulsar::service::tftp::client
#
# Trivial File Transfer Protocol (TFTP) is a simple file transfer protocol,
# typically used to automatically transfer configuration or boot files between
# machines. TFTP does not support authentication and can be easily hacked.
# The package tftp is a client program that allows for connections to a tftp
# server.
#
# This module is not included by default as the tftp client is a useful debug
# tool for tftp services
#
# Refer to Section(s) 2.1.7 Page(s) 51 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.7 Page(s) 59 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.7 Page(s) 54-5 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

# Requires fact: pulsar_systemservices
# Requires fact: pulsar_installedpackages

class pulsar::service::tftp::client::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /CentOS|Red/ {
        init_message { "pulsar::service::tftp::client": }
      }
    }
  }
}

class pulsar::service::tftp::client::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /CentOS|Red/ {
        uninstall_package { "tftp": }
      }
    }
  }
}
