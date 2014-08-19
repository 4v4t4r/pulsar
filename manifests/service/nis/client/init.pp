# pulsar::service::nis::client
#
# If the local site is not using the NIS naming service to distribute
# system and user configuration information, this service may be disabled.
# This service is disabled by default unless the NIS service has been
# configured on the system.
#
# Refer to Section(s) 2.5 Page(s) 18 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.2.3 Page(s) 24-5 CIS Solaris 10 v5.1.0
# Refer to Section(s) 2.1.5 Page(s) 58 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 2.1.5 Page(s) 53 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 5.1.2 Page(s) 41 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_systemservices

class pulsar::service::nis::client::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::service::nis::client": }
    }
  }
}

class pulsar::service::nis::client::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == 'SunOS' {
        disable_service { 'svc:/network/nis/client': }
      }
      if $kernel == 'Linux' {
        disable_service { 'ypbind': }
      }
    }
  }
}
