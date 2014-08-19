# pulsar::service::spctl
#
# Disabling this feature mitigates the risk of an attacker remotely waking
# the system and gaining access.
#
# Refer to Section 2.5.1 Page(s) 26-27 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_spctl_status

class pulsar::service::spctl::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::spctl": }
    }
  }
}

class pulsar::service::spctl::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      check_exec { "pulsar::service::spctl":
        fact  => $pulsar_spctl_status,
        check => "spctl --status",
        exec  => "/usr/bin/sudo /usr/bin/spctl --master-enable",
        value => "assessments enabled",
      }
    }
  }
}
