# pulsar::priv::pam::wheel
#
# PAM Wheel group membership. Make sure wheel group membership is required to su.
#
# Refer to Section(s) 6.5 Page(s) 142-3 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.5 Page(s) 165-6 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.5 Page(s) 145-6 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 9.5 Page(s) 135-6 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_pamsu

class pulsar::priv::pam::wheel::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "Linux" {
      init_message { "pulsar::priv::pam::wheel": }
    }
  }
}

class pulsar::priv::pam::wheel::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel == "Linux" {
      add_line_to_file { "auth required pam_wheel.so use_uid": path => "pamsu" }
    }
  }
}
