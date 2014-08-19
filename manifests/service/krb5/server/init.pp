# pulsar::service::krb5::server
#
# Turn off kerberos if not required
#.

# Requires fact: pulsar_systemservices

class pulsar::service::krb5::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::krb5::server": }
    }
  }
}

class pulsar::service::krb5::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        $krb_service_list = [
          'svc:/network/security/krb5kdc:default',
          'svc:/network/security/kadmin:default',
          'svc:/network/security/krb5_prop:default'
        ]
      }
      if $kernel == 'Linux' {
        $krb_service_list = [ 'kadmin', 'kprop', 'krb524', 'krb5kdc' ]
      }
      disable_service { $krb_service_list: }
    }
  }
}
