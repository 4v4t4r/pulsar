# pulsar::service::cde::spc
#
# CDE Subprocess control. Not required unless running CDE applications.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::cde::spc::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::cde::spc": }
    }
  }
}

class pulsar::service::cde::spc::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == '5.10' {
        disable_service { "svc:/network/cde-spc:default": }
      }
    }
  }
}
