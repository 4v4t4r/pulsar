# pulsar::service::rsh::client
#
# The rsh package contains the client commands for the rsh services.
#
# This module is not enabled by default as the rsh client cna be used as a
# debug tool to ensure the rsh service isn't running on other machines
#
# Refer to Section(s) 2.1.4 Page(s) 49 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.4 Page(s) 57 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.4 Page(s) 52-3 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 5.1.4 Page(s) 42-3 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_installedpackages

class pulsar::service::rsh::client::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Linux/ {
      if $lsbdistid =~ /CentOS|Red|Scientific|SuSE/ {
        init_message { "pulsar::service::rsh::client": }
      }
    }
  }
}

class pulsar::service::rsh::client::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Linux/ {
      if $lsbdistid =~ /CentOS|Red|Scientific|SuSE/ {
        uninstall_package { "rsh": }
      }
    }
  }
}
