# pulsar::priv::pam::uid
#
# Audit wheel Set UID
#
# The su command allows a user to run a command or shell as another user.
# The program has been superseded by sudo, which allows for more granular
# control over privileged access. Normally, the su command can be executed
# by any user. By uncommenting the pam_wheel.so statement in /etc/pam.d/su,
# the su command will only allow users in the wheel group to execute su.
#
# Refer to Section(s) 6.5 Page(s) 165-6 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.5 Page(s) 145-6 CIS Red Hat Linux 6 Benchmark v1.2.0
#.

# Requires fact: pulsar_pamsu

class pulsar::priv::pam::uid::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /Linux/ {
      init_message { "pulsar::priv::pam::uid": }
      install_package { "libpam-cracklib": }
    }
  }
}

class pulsar::priv::pam::uid::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /Linux/ {
      add_line_to_file { "auth\trequired\tpam_wheel.so use_uid": path => "pamsu" }
    }
  }
}
