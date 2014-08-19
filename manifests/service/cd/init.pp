# pulsar::service::cd
#
# DVD or CD Sharing allows users to remotely access the system's optical drive.
# Disabling DVD or CD Sharing minimizes the risk of an attacker using the
# optical drive as a vector for attack.
#
# Refer to Section 2.4.6 Page(s) 22 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::cd::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::cd": }
    }
  }
}

class pulsar::service::cd::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      disable_service { "ODSAgent": }
    }
  }
}
