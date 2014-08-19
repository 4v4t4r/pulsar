# pulsar::group::root
#
# Set Default Group for root Account
# For Solaris 9 and earlier, the default group for the root account is the
# "other" group, which may be shared by many other accounts on the system.
# Solaris 10 has adopted GID 0 (group "root") as default group for the root
# account.
# If your system has been upgraded from an earlier version of Solaris, the
# password file may contain the older group classification for the root user.
# Using GID 0 for the root account helps prevent root-owned files from
# accidentally becoming accessible to non-privileged users.
#
# Refer to Section(s) 7.3 Page(s) 147 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 7.3 Page(s) 170 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 7.3 Page(s) 150 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 10.3 Page(s) 139-140 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.4 Page(s) 104-5 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_primarygid_root

class pulsar::group::root::init {
  if $pulsar_modules =~ /group|full/ {
    if $kernel =~ /SunOS|Linux|AIX|Darwin|FreeBSD/ {
      init_message { "pulsar::group::root": }
    }
  }
}


class pulsar::group::root::main {
  if $pulsar_modules =~ /group|full/ {
    if $kernel =~ /SunOS|Linux|AIX|Darwin|FreeBSD/ {
      check_primary_gid { "root":
        fact => $pulsar_primarygid_root,
        gid  => "0",
      }
    }
  }
}
