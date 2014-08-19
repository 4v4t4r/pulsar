# pulsar::user::old
#
# Audit users to check for accounts that have not been logged into etc
#.

# Requires fact: pulsar_oldusers

class pulsar::user::old::init {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::user::old": }
    }
  }
}

class pulsar::user::old::main {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /SunOS|Linux/ {
      check_old_users { "pulsar::user::old": }
    }
  }
}
