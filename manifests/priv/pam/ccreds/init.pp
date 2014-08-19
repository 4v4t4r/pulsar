# pulsar::priv::pam::deny
#
# The pam_ccreds module provides the ability for Linux users to locally
# authenticate using an enterprise identity when the network is unavailable.
# While cached credentials provide flexibility in allowing enterprise users to
# authenticate when not attached to the network, it provides attackers with the
# ability of compromising those credentials if they've compromised the system.
#
# Refer to Section(s) 6.3.6 Page(s) 164-5 CIS Red Hat Linux 5 Benchmark v2.1.0
#.

# Requires fact: pulsar_installedpackages

class pulsar::priv::pam::ccreds::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::priv::pam::ccreds": }
    }
  }
}

class pulsar::priv::pam::ccreds::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "Linux" {
      uninstall_package { "pam_ccreds": }
    }
  }
}
