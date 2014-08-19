# pulsar::file::writable
#
# Unix-based systems support variable settings to control access to files.
# World writable files are the least secure. See the chmod(2) man page for more
# information.
# Data in world-writable files can be modified and compromised by any user on
# the system. World writable files may also indicate an incorrectly written
# script or program that could potentially be the cause of a larger compromise
# to the system's integrity.
#
# Refer to Section(s) 9.1.10 Page(s) 159-160 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.1.10 Page(s) 183-4 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.1.10 Page(s) 162-3 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 12.8 Page(s) 150-1 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.4 Page(s) 22 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.16.3 Page(s) 233-4 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 5.1,9.22 Page(s) 45,88 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.22 Page(s) 134 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_worldwritablefiles

class pulsar::file::writable::init {
  if $pulsar_modules =~ /file|full/ {
    if $pulsar_filesystemsearch == "yes" {
      if $kernel =~ /SunOS|FreeBSD|AIX|Linux/ {
        init_message { "pulsar::file::writable": }
      }
    }
  }
}

class pulsar::file::writable::main {
  if $pulsar_modules =~ /file|full/ {
    if $pulsar_filesystemsearch == "yes" {
      if $kernel =~ /SunOS|FreeBSD|AIX|Linux/ {
        check_user_files { "worldwritable": }
      }
    }
  }
}
