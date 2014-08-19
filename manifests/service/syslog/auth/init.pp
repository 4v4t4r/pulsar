# pulsar::service::syslog::auth
#
# Make sure authentication requests are logged. This is especially important
# for authentication requests to accounts/roles with raised priveleges.
#
# Refer to Section(s) 4.4 Page(s) 68-9 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_syslog
# Requires fact: pulsar_logadm_auth

class pulsar::service::syslog::auth::init {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS/ {
      init_message { "pulsar::service::syslog::auth": }
    }
  }
}

class pulsar::service::syslog::auth::main {
  if $pulsar_modules =~ /service|full/ {
    if $kernel =~ /SunOS/ {
      add_line_to_file { "auth.info\t\t\t/var/log/authlog": path => "syslog" }
      check_logadm_facility { "auth.info": }
    }
  }
}
