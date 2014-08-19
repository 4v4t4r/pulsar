# pulsar::service::krb5::tgt
#
# While Kerberos can be a security enhancement, if the local site is
# not currently using Kerberos then there is no need to have the
# Kerberos TGT expiration warning enabled.
#.

# Requires fact: pulsar_systemservices

class pulsar::service::krb5::tgt::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::service::krb5::tgt": }
    }
  }
}

class pulsar::service::krb5::tgt::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel == 'SunOS' {
      if $kernelrelease =~ /10|11/ {
        disable_service { 'svc:/network/security/ktkt_warn': }
      }
    }
  }
}
