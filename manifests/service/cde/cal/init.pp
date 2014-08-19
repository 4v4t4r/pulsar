# pulsar::service::cde::cal () {
#
# CDE Calendar Manager is an appointment and resource scheduling tool.
# Not required unless running CDE applications.
#
# Refer to Section(s) 2.1.2 Page(s) 18-9 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::cde::cal::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::cde::cal": }
    }
  }
}

class pulsar::service::cde::cal::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease == '5.10' {
        disable_service { "svc:/network/rpc/cde-calendar-manager:default": }
      }
    }
  }
}
