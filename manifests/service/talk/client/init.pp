# pulsar::service::talk::client
#
# The talk software makes it possible for users to send and receive messages
# across systems through a terminal session.
# The talk client (allows initialization of talk sessions) is installed by
# default.
#
# Refer to Section(s) 2.1.9 Page(s) 53 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.9 Page(s) 61 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.9 Page(s) 55-6 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 5.2.6 Page(s) 43-4 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_installedpackages

class pulsar::service::talk::client::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Linux/ {
      if $lsbdistid =~ /SuSE|Red/ {
        init_message { "pulsar::service::talk::client": }
      }
    }
  }
}

class pulsar::service::talk::client::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Linux/ {
      if $lsbdistid =~ /SuSE|Red/ {
        uninstall_package { "talk": }
      }
    }
  }
}
