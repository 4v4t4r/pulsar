# pulsar::priv::pam::deny
#
# Add pam.deny to pam config files
#
# Refer to Section(s) 6.7 Page(s) 23 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 6.3.3 Page(s) 162 CIS Red Hat Linux 5 Benchmark v2.1.0
#.

# Requires fact: pulsar_pam
# Requires fact: pulsar_pamsshd

# Needs checking

class pulsar::priv::pam::deny::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /Linux|FreeBSD/ {
      init_message { "pulsar::priv::pam::deny": }
    }
  }
}

class pulsar::priv::pam::deny::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /Linux|FreeBSD/ {
      if $kernel == "FreeBSD" {
        add_line_to_file { "rsh\tauth\trequired\tpam_deny.so": path => "pam" }
        add_line_to_file { "rexecd\tauth\trequired\tpam_deny.so": path => "pam" }
      }
      if $kernel == "Linux" {
        add_line_to_file { "auth\trequisite\tpam_deny.so": path => "pamsshd" }
      }
    }
  }
}
