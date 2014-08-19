# pulsar::service::x11::server
#
# The X Windows system provides a Graphical User Interface (GUI) where users
# can have multiple windows in which to run programs and various add on.
# The X Windows system is typically used on desktops where users login,
# but not on servers where users typically do not login.
#
# Refer to Section(s) 3.2 Page(s) 59-60 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.3 Page(s) 72-3 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.2 Page(s) 62-3 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.1 Page(s) 52 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_installedpackages

# Needs fixing - need to hanle package bundles

class pulsar::service::x11::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::service::x11::server": }
    }
  }
}

class pulsar::service::x11::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Linux" {
      if $lsbdistid =~ /CentOS|Red/ {
        uninstall_package { "X Window System": }
      }
    }
  }
}
