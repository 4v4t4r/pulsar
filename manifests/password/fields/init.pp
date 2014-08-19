# pulsar::password::fields
#
# Ensure Password Fields are Not Empty
# Verify System Account Default Passwords
# Ensure Password Fields are Not Empty
#
# An account with an empty password field means that anybody may log in as
# that user without providing a password at all (assuming that PASSREQ=NO
# in /etc/default/login). All accounts must have passwords or be locked.
#
# Refer to Section(s) 9.2.1 Page(s) 162-3 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 9.2.1 Page(s) 187-8 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 9.2.1 Page(s) 166 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 13.1 Page(s) 154 SLES 11 Benchmark v1.0.0
# Refer to Section(s) 8.2 Page(s) 27 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.2.15 Page(s) 219 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 9.4 Page(s) 75 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 9.3 Page(s) 118 CIS Solaris 10 v1.1.0
#.

# Requires fact: pulsar_emptypasswordfields

# Need to be fixed

class pulsar::password::fields::init {
  if $pulsar_modules =~ /password|passwd|full/ {
    if $kernel =~ /SunOS|Linux/ {
      init_message { "pulsar::password::fields": }
    }
  }
}

class pulsar::password::fields::main {
  if $pulsar_modules =~ /password|passwd|full/ {
    if $kernel =~ /SunOS|Linux/ {
      check_empty_password_fields { "pulsar::password::fields": }
    }
  }
}
