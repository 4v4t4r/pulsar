# pulsar::login::failed
#
# The SYS_FAILED_LOGINS variable is used to determine how many failed login
# attempts occur before a failed login message is logged. Setting the value
# to 0 will cause a failed login message on every failed login attempt.
# The SYSLOG_FAILED_LOGINS parameter in the /etc/default/login file is used
# to control how many login failures are allowed before log messages are
# generated-if set to zero then all failed logins will be logged.
#
# Refer to Section(s) 4.6 Page(s) 70-1 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_su

# Needs fixing

class pulsar::login::failed::init {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::login::failed": }
    }
  }
}

class pulsar::login::failed::main {
  if $pulsar_modules =~ /login|full/ {
    if $kernel == "SunOS" {
      add_line_to_file { "SYSLOG_FAILED_LOGINS=0": path => "login" }
      add_line_to_file { "SYSLOG=YES": path => "login" }
      add_line_to_file { "%SYSLOG=YES": path => "su" }
    }
  }
}
