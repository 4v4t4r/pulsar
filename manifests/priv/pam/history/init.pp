# pulsar::priv::pam::history
#
# Audit the number of remembered passwords
#
# The /etc/security/opasswd file stores the users' old passwords and can be
# checked to ensure that users are not recycling recent passwords.
# Forcing users not to reuse their past 5 passwords make it less likely that
# an attacker will be able to guess the password.
#
# Refer to Section(s) 6.3.4 Page(s) 141-2 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.3.4 Page(s) 144-5 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 9.3.3 Page(s) 134 SLES 11 Benchmark v1.0.0
#.

# Requires fact: pulsar_pamcommonauth
# Requires fact: pulsar_pamsystemauth

# Needs checkin

class pulsar::priv::pam::history::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /Linux/ {
      init_message { "pulsar::priv::pam::historyy": }
    }
  }
}

class pulsar::priv::pam::history::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /Linux/ {
      if $lsbdistid =~ /Debian|SuSE|Ubuntu/ {
        $path = "pamcommonauth"
      }
      else {
        $path = "pamsystemauth"
      }
      add_line_to_file { "password\tsufficient\tpam_unix.so remember=5": path => $path }
    }
  }
}
