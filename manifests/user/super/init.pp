# pulsar::user::super
#
# Any account with UID 0 has superuser privileges on the system.
# This access must be limited to only the default root account
# and only from the system console.
#
# Refer to Section(s) 9.2.5 Page(s) 190-1 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.5 Page(s) 165 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.5 Page(s) 168 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 13.5 Page(s) 156-7 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.6 Page(s) 28 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.2.8 Page(s) 32 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9-5 Page(s) 75-6 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.5 Page(s) 119-20 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_invalidsystemaccounts

class pulsar::user::super::init {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /Linux|SunOS|AIX|FreeBSD|Darwin/ {
      init_message { "pulsar::user::super": }
    }
  }
}

class pulsar::user::super::main {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /Linux|SunOS|AIX|FreeBSD|Darwin/ {
      check_system_accounts { "pulsar::user::super": }
    }
  }
}
