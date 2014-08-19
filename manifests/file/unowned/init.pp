# pulsar::file::unowned
#
# Sometimes when administrators delete users from the password file they
# neglect to remove all files owned by those users from the system.
# A new user who is assigned the deleted user's user ID or group ID may then
# end up "owning" these files, and thus have more access on the system than
# was intended.
#
# Refer to Section(s) 9.1.11-2 Page(s) 160-1 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.1.11-2 Page(s) 184-6 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.1.11-2 Page(s) 163-4 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 12.9-10 Page(s) 151-2 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.7 Page(s) 23 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.16.2 Page(s) 232-3 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.24 Page(s) 89-90 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.24 Page(s) 135-6 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_unownedfiles

class pulsar::file::unowned::init {
  if $pulsar_modules =~ /file|full/ {
    if $pulsar_filesystemsearch == "yes" {
      if $kernel =~ /SunOS|Linux|Darwin|AIX|FreeBSD/ {
        init_message { "pulsar::file::unowned": }
      }
    }
  }
}

class pulsar::file::unowned::main {
  if $pulsar_modules =~ /file|full/ {
    if $pulsar_filesystemsearch == "yes" {
      if $kernel =~ /SunOS|Linux|Darwin|AIX|FreeBSD/ {
        check_user_files { "unowned": }
      }
    }
  }
}
