# pulsar::service::xinetd::server
#
# The eXtended InterNET Daemon (xinetd) is an open source super daemon that
# replaced the original inetd daemon. The xinetd daemon listens for well known
# services and dispatches the appropriate daemon to properly respond to service
# requests.
# If there are no xinetd services required, it is recommended that the daemon
# be deleted from the system.
#
# Refer to Section(s) 2.1.11 Page(s) 54 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.11 Page(s) 62 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.11 Page(s) 46-7 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 5.1.9 Page(s) 45-6 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::xinetd::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::xinetd::server": }
    }
  }
}

class pulsar::service::xinetd::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /CentOS|Red/ {
        uninstall_package { "xinetd": }
      }
    }
  }
}
