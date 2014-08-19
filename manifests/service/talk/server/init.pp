# pulsar::service::talk::server
#
# The talk software makes it possible for users to send and receive messages
# across systems through a terminal session. The talk client (allows initiate
# of talk sessions) is installed by default.
# The software presents a security risk as it uses unencrypted protocols for
# communication.
#
# Refer to Section(2) 2.1.10 Page(s) 53-54 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.10 Page(s) 61-2 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.10 Page(s) 56 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 5.1.5 Page(s) 43 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_installedpackages

class pulsar::service::talk::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Linux/ {
      if $lsbdistid =~ /SuSE|Red/ {
        init_message { "pulsar::service::talk::server": }
      }
    }
  }
}

class pulsar::service::talk::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Linux/ {
      if $lsbdistid =~ /SuSE|Red/ {
        uninstall_package { "talk-server": }
      }
    }
  }
}
