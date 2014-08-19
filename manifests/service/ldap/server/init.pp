# pulsar::service::ldap::server
#
# The Lightweight Directory Access Protocol (LDAP) was introduced as a
# replacement for NIS/YP. It is a service that provides a method for looking
# up information from a central database. The default client/server LDAP
# application for CentOS is OpenLDAP.
# If the server will not need to act as an LDAP client or server, it is
# recommended that the software be disabled.
#
# Refer to Section(s) 3.7 Page(s) 63-4 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.7 Page(s) 76 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 3.7 Page(s) 66-7 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 6.6 Page(s) 56-7 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_installedpackages
# Requires fact: pulsar_systemservices

# Needs fixing

class pulsar::service::ldap::server::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "Linux" {
        if $distid =~ /CentOS|Red/ {
          init_message { "pulsar::service::ldap::server": }
        }
      }
      if $kernel == "SunOS" {
        if $kernelrelease =~ /10|11/ {
          init_message { "pulsar::service::ldap::server": }
        }
      }
    }
  }
}

class pulsar::service::ldap::server::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS|Linux/ {
      if $kernel == "Linux" {
        if $distid =~ /CentOS|Red/ {
          uninstall_package { "openldap-servers": }
        }
      }
      if $kernel == "SunOS" {
        if $kernelrelease == "5.11" {
          disable_service { "svc:/network/ldap/server:openldap_24": }
        }
      }
    }
  }
}
