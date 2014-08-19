# pulsar::service::wol
#
# Disabling this feature mitigates the risk of an attacker remotely waking
# the system and gaining access.
#
# Refer to Section 2.5.1 Page(s) 26-27 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_pmset_womp

class pulsar::service::wol::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::wol": }
    }
  }
}

class pulsar::service::wol::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      check_pmset { "womp": value => "0", }
    }
  }
}
