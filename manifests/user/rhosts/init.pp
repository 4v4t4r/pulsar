# pulsar::user::rhosts
#
# While no .rhosts files are shipped with Solaris, users can easily create them.
# This action is only meaningful if .rhosts support is permitted in the file
# /etc/pam.conf. Even though the .rhosts files are ineffective if support is
# disabled in /etc/pam.conf, they may have been brought over from other systems
# and could contain information useful to an attacker for those other systems.
#
# Refer to Section(s) 9.2.10 Page(s) 169-70 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.10 Page(s) 195-6 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.10 Page(s) 172-3 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 13.10 Page(s) 161 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 7.2 Page(s) 25 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.5.1 Page(s) 101-2 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.10 Page(s) 79 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.10 Page(s) 124 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_rhostsfiles

class pulsar::user::rhosts::init {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /SunOS|Linux|Darwin|AIX|FreeBSD/ {
      init_message { "pulsar::user::rhosts": }
    }
  }
}

class pulsar::user::rhosts::main {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /SunOS|Linux|Darwin|AIX|FreeBSD/ {
      check_user_files { "rhost": }
    }
  }
}
