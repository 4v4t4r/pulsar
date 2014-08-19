# pulsar::service::ard
#
# Remote Management is the client portion of Apple Remote Desktop (ARD).
# Remote Management can be used by remote administrators to view the current
# Screen, install software, report on, and generally manage client Macs.
#
# Remote management should only be enabled on trusted networks with strong
# user controls present in a Directory system, mobile devices without strict
# controls are vulnerable to exploit and monitoring.
#
# Refer to Section 2.2.9 Page(s) 25-26 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::ard::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      init_message { "pulsar::service::ard": }
    }
  }
}

class pulsar::service::ard::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "Darwin" {
      disable_service { "ARDAgent": }
    }
  }
}
