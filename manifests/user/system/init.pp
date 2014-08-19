# pulsar::user::system
#
# There are a number of accounts provided with the Solaris OS that are used to
# manage applications and are not intended to provide an interactive shell.
# It is important to make sure that accounts that are not being used by regular
# users are locked to prevent them from logging in or running an interactive
# shell. By default, Solaris sets the password field for these accounts to an
# invalid string, but it is also recommended that the shell field in the
# password file be set to "false." This prevents the account from potentially
# being used to run any commands.
#
# Refer to Section(s) 7.2 Page(s) 146-147 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 7.2 Page(s) 169 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 7.2 Page(s) 149-150 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 10.2 Page(s) 138-9 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.1 Page(s) 27 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 9.3 Page(s) 73-4 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 7.1 Page(s) 100-1 CIS Solaris 10 v5.1.0
#.

# Requires fact: pulsar_invalidsystemshells

class pulsar::user::system::init {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /AIX|Linux|SunOS|FreeBSD/ {
      init_message { "pulsar::user::system": }
    }
  }
}

class pulsar::user::system::main {
  if $pulsar_modules =~ /user|full/ {
    if $kernel =~ /AIX|Linux|SunOS|FreeBSD/ {
      check_system_shells { "pulsar::user::system": }
    }
  }
}
