# pulsar::service::nisplus
#
# NIS+ was designed to be a more secure version of NIS. However,
# the use of NIS+ has been deprecated by Oracle and customers are
# encouraged to use LDAP as an alternative naming service.
# This service is disabled by default unless the NIS+ service has
# been configured on the system.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::nisplus::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      if $kernelrelease == "5.10" {
        init_message { "pulsar::service::nisplus": }
      }
    }
  }
}

class pulsar::service::nisplus::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease == '5.10' {
        disable_service { 'svc:/network/rpc/nisplus': }
      }
    }
  }
}
