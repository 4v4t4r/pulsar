# pulsar::priv::pam::policy
#
# Audit /etc/pam.d/system-auth on RedHat
# Audit /etc/pam.d/common-auth on Debian
# Lockout accounts after 5 failures
# Set to remember up to 4 passwords
# Set password length to a minimum of 9 characters
# Set strong password creation via pam_cracklib.so and pam_passwdqc.so
# Restrict su command using wheel
#
# Refer to Section(s) 6.3.1 Page(s) 160-1 CIS Red Hat Linux 5 Benchmark v2.1.0
# Refer to Section(s) 6.3.5-6 Page(s) 163-5 CIS Red Hat Linux 5 Benchmark v2.1.0
#.

# Requires fact: pulsar_pamcommonauth
# Requires fact: pulsar_pamsystemauth

# Needs checking

class pulsar::priv::pam::policy::init {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /Linux/ {
      init_message { "audit_system_auth_password": }
    }
  }
}

class pulsar::priv::pam::policy::main {
  if $pulsar_modules =~ /priv|full/ {
    if $kernel =~ /Linux/ {
      if $lsbdistid =~ /Debian|SuSE|Ubuntu/ {
        $path = "pamcommonauth"
      }
      else {
        $path = "pamsystemauth"
      }
      add_line_to_file { "password\trequired\tpam_cracklib.so try_first_pass retry=3 minlen=14 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1": path => $path }
    }
  }
}
