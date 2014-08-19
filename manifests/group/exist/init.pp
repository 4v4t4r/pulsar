# pulsar::group::exist
#
# Over time, system administration errors and changes can lead to groups being
# defined in /etc/passwd but not in /etc/group.
# Groups defined in the /etc/passwd file but not in the /etc/group file pose a
# threat to system security since group permissions are not properly managed.
#.

# Requires fact: pulsar_unusedgroups
# Requires fact: pulsar_unusedgids

class pulsar::group::exist::init {
  if $pulsar_modules =~ /group|full/ {
    if $kernel =~ /SunOS|Linux|AIX|FreeBSD/ {
      init_message { "pulsar::group::exist": }
    }
  }
}

class pulsar::group::exist::main {
  if $pulsar_modules =~ /group|full/ {
    if $kernel =~ /SunOS|Linux|AIX|FreeBSD/ {
      check_unused { "groups": }
      check_unused { "gids": }
    }
  }
}
