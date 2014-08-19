# pulsar::fs::Home::perms
#
# While the system administrator can establish secure permissions for users'
# home directories, the users can easily override these.
# Group or world-writable user home directories may enable malicious users to
# steal or modify other users' data or to gain another user's system privileges.
#.

# Requires fact: pulsar_homeperms

class pulsar::fs::home::perms::init {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel =~ /SunOS||Linux|AIX|FreeBSD/ {
      init_message { "pulsar::fs::home::perms": }
    }
  }
}

class pulsar::fs::home::perms::main {
  if $pulsar_modules =~ /fs|full/ {
    if $kernel =~ /SunOS|Linux|AIX|FreeBSD/ {
      check_invalid_home_perms { "pulsar::fs::home::perms": }
    }
  }
}
