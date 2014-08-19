# pulsar::service::ldap::cache
#
# If the local site is not currently using LDAP as a naming service,
# there is no need to keep LDAP-related daemons running on the local
# machine. This service is disabled by default unless LDAP client
# services have been configured on the system.
# If a naming service is required, users are encouraged to use LDAP
# instead of NIS/NIS+.
#
# Refer to Section(s) 2.2.5 Page(s) 25-6 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::ldap::cache::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::ldap::cache": }
    }
  }
}

class pulsar::service::ldap::cache::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        disable_service { 'svc:/network/ldap/client': }
      }
      if $kernel == 'Linux' {
        disable_service { 'ldap': }
      }
    }
  }
}
