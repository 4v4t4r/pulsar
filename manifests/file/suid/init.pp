# pulsar::file::suid
#
# The owner of a file can set the file's permissions to run with the owner's or
# group's permissions, even if the user running the program is not the owner or
# a member of the group. The most common reason for a SUID/SGID program is to
# enable users to perform functions (such as changing their password) that
# require root privileges.
# There are valid reasons for SUID/SGID programs, but it is important to
# identify and review such programs to ensure they are legitimate.
#
# Refer to Section(s) 9.1.13-4 Page(s) 161-2 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.1.13-4 Page(s) 186-7 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.1.13-4 Page(s) 164-5 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 12.11-12 Page(s) 152-3 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 6.5 Page(s) 22 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.16.1 Page(s) 231-2 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.23 Page(s) 88-9 CIS Solaris 11.1 v1.0.0
#.

# Requires fact: pulsar_suidfiles

class pulsar::file::suid::init {
  if $pulsar_modules =~ /file|full/ {
    if $pulsar_filesystemsearch == "yes" {
      if $kernel =~ /SunOS|Linux|Darwin|AIX|FreeBSD/ {
        init_message { "pulsar::file::suid": }
      }
    }
  }
}

class pulsar::file::suid::main {
  if $pulsar_modules =~ /file|full/ {
    if $pulsar_filesystemsearch == "yes" {
      if $kernel =~ /SunOS|Linux|Darwin|AIX|FreeBSD/ {
        check_user_files { "suid": }
      }
    }
  }
}
