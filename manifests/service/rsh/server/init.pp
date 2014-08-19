# pulsar::service::rsh::server
#
# The Berkeley rsh-server (rsh, rlogin, rcp) package contains legacy services
# that exchange credentials in clear-text.
# These legacy service contain numerous security exposures and have been
# replaced with the more secure SSH package.
#
# Refer to Section(s) 2.1.3 Page(s) 48 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 2.1.3 Page(s) 56-7 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.3 Page(s) 51-2 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 5.1.3 Page(s) 41-2 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_installedpackages

class pulsar::service::rsh::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Linux/ {
      if $lsbdistid =~ /CentOS|Red|Scientific|SuSE/ {
        init_message { "pulsar::service::rsh::server": }
      }
    }
  }
}

class pulsar::service::rsh::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /Linux/ {
      if $lsbdistid =~ /CentOS|Red|Scientific|SuSE/ {
        uninstall_package { "rsh-server": }
      }
    }
  }
}
