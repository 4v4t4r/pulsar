# pulsar::user::inactive
#
# Guidelines published by the U.S. Department of Defense specify that user
# accounts must be locked out after 35 days of inactivity. This number may
# vary based on the particular site's policy.
# Inactive accounts pose a threat to system security since the users are not
# logging in to notice failed login attempts or other anomalies.
#.

# Requires fact: pulsar_defadduser

class pulsar::user::inactive::init {
  if $pulsar_modules =~ /user|full/ {
    if $kernel == "SunOS" {
      init_message { "pulsar::user::inactive": }
    }
  }
}

class pulsar::user::inactive::main {
  if $pulsar_modules =~ /user|full/ {
    if $kernel == 'SunOS' {
      add_line_to_file { "definact=35": path => "defadduser" }
    }
  }
}
