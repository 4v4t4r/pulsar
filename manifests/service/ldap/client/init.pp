# pulsar::service::ldap::client
#
# Turn off ldap
#.

# Requires fact: pulsar_systemservices

class pulsar::service::ldap::client::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::ldap::client": }
    }
  }
}

class pulsar::service::ldap::client::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $operatiingsystemrelease =~ /10|!11/ {
        disable_service { 'svc:/network/ldap/client:default': }
      }
    }
  }
}
