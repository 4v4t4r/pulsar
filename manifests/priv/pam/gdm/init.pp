# pulsar::priv::pam::gdm
#
# As automatic logins are a known security risk for other than "kiosk" types
# of systems, GNOME automatic login should be disabled in pam.conf(4).
#
# Refer to Section(s) 16.11 Page(s) 54-5 Solaris 11.1 Benchmark v1.0.0
#.

# Requires fact: pulsar_pamgdmautologin

# Needs checking

class pulsar::priv::pam::gdm::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::priv::pam::gdm": }
    }
  }
}

class pulsar::priv::pam::gdm::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "SunOS" {
      check_value { "pulsar::priv::pam::deny::auth":
        path   => "pamgdmautologin",
        match  => "gdm-autologin",
        ensure => "absent",
      }
    }
  }
}
