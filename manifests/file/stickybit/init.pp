# pulsar::file::stickybit
#
# When the so-called sticky bit (set with chmod +t) is set on a directory,
# then only the owner of a file may remove that file from the directory
# (as opposed to the usual behavior where anybody with write access to that
# directory may remove the file).
# Setting the sticky bit prevents users from overwriting each others files,
# whether accidentally or maliciously, and is generally appropriate for most
# world-writable directories (e.g. /tmp). However, consult appropriate vendor
# documentation before blindly applying the sticky bit to any world writable
# directories found in order to avoid breaking any application dependencies
# on a given directory.
#
# Refer to Section(s) 1.17 Page(s) 26 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 1.1.17 Page(s) 28 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 1.1.17 Page(s) 27 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 2.17 Page(s) 26 SLES 11 Benchmark v1.2.0
# Refer to Section(s) 6.3 Page(s) 21-22 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.3 Page(s) 77-8 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_stickybitfiles

class pulsar::file::stickybit::init {
  if $pulsar_modules =~ /file|full/ {
    if $kernel =~ /SunOS|Linux|Darwin|AIX|FreeBSD/ {
      init_message { "pulsar::file::stickybit": }
    }
  }
}

class pulsar::file::stickybit::main {
  if $pulsar_modules =~ /file|full/ {
    if $kernel =~ /SunOS|Linux|Darwin|AIX|FreeBSD/ {
      check_user_files { "stickybit": }
    }
  }
}
