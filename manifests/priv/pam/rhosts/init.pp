# pulsar::priv::pam::rhosts
#
# Used in conjunction with the BSD-style "r-commands" (rlogin, rsh, rcp),
# .rhosts files implement a weak form of authentication based on the network
# address or host name of the remote computer (which can be spoofed by a
# potential attacker to exploit the local system).
# Disabling .rhosts support helps prevent users from subverting the system's
# normal access control mechanisms.
#
# Refer to Section(s) 6.8 Page(s) 51-52 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 6.4 Page(s) 89 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_pam

# Needs fixing - Need to comment out line

class pulsar::priv::pam::rhosts::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::priv::pam::rhosts": }
    }
  }
}

class pulsar::priv::pam::rhosts::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == 'SunOS' {
      check_value { "pulsar::priv::pam::rhosts::auth":
        path   => "pam",
        match  => "pam_rhosts_auth",
        ensure => "absent",
      }
    }
  }
}
