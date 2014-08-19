# pulsar::user::path
#
# The root user can execute any command on the system and could be fooled into
# executing programs unemotionally if the PATH is not set correctly.
# Including the current working directory (.) or other writable directory in
# root's executable path makes it likely that an attacker can gain superuser
# access by forcing an administrator operating as root to execute a Trojan
# horse program.
#
# Refer to Section(s) 9.2.6 Page(s) 165-166 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.6 Page(s) 191-2 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.6 Page(s) 167 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 13.6 Page(s) 157-8 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.12.20 Page(s) 223 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.6 Page(s) 76-7 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.6 Page(s) 120-1 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_rootenv_path

class pulsar::user::path::init {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /SunOS|Linux|AIX|FreeBSD|Darwin/ {
      init_message { "pulsar::user::path": }
    }
  }
}
class pulsar::user::path::main {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /SunOS|Linux|AIX|FreeBSD|Darwin/ {
      check_path { "root": }
    }
  }
}
